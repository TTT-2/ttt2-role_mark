MARKER_DATA = {}
MARKER_DATA.marked_players = {}
MARKER_DATA.marked_amount = 0
MARKER_DATA.player_alive = 0
MARKER_DATA.able_to_win = true

if CLIENT then
    hook.Add('Initialize', 'TTTInitMarkerMessageLang', function()
		LANG.AddToLanguage('English', 'ttt2_marker_marked', 'It seems like a player was marked.')
		LANG.AddToLanguage('English', 'ttt2_marker_died', 'It seems like a marked player died.')
		LANG.AddToLanguage('Deutsch', 'ttt2_marker_marked', 'Es scheint so, als wäre ein weiterer Spieler markiert worden.')
		LANG.AddToLanguage('Deutsch', 'ttt2_marker_died', 'Es scheint so, als wäre ein markierter Spieler gestorben.')
    end)
    

    net.Receive('ttt2_role_marker_new_marking', function()
        local marked_player = net.ReadEntity()
        local marked_player_id = tostring(marked_player:SteamID64() or marked_player:EntIndex())

        if LocalPlayer():GetSubRole() ~= ROLE_MARKER then return end

        if not MARKER_DATA.marked_players[marked_player_id] then
            if GetConVar('ttt_mark_show_messages'):GetBool() then MSTACK:AddMessage(LANG.GetTranslation('ttt2_marker_marked')) end
            MARKER_DATA.marked_players[marked_player_id] = true
            MARKER_DATA:Count()
        end
    end)

    net.Receive('ttt2_role_marker_remove_marking', function()
        local marked_player = net.ReadEntity()
        local marked_player_id = tostring(marked_player:SteamID64() or marked_player:EntIndex())

        if LocalPlayer():GetSubRole() ~= ROLE_MARKER then return end

        if MARKER_DATA.marked_players[marked_player_id] then
            if GetConVar('ttt_mark_show_messages'):GetBool() then MSTACK:AddMessage(LANG.GetTranslation('ttt2_marker_died')) end
            MARKER_DATA.marked_players[marked_player_id] = nil
            MARKER_DATA:Count()
        end
    end)

    net.Receive('ttt2_role_marker_remove_all', function()
        MARKER_DATA:ClearMarkedPlayers()
    end)

    net.Receive('ttt2_role_marker_update', function()
        MARKER_DATA.player_alive = net.ReadUInt(16)
        MARKER_DATA.able_to_win = net.ReadBool()
    end)
end

if SERVER then
    util.AddNetworkString('ttt2_role_marker_new_marking')
    util.AddNetworkString('ttt2_role_marker_remove_marking')
    util.AddNetworkString('ttt2_role_marker_remove_all')
    util.AddNetworkString('ttt2_role_marker_update')

    function MARKER_DATA:SetMarkedPlayer(ply)
        MARKER_DATA.marked_players[tostring(ply:SteamID64() or ply:EntIndex())] = true

        net.Start('ttt2_role_marker_new_marking')
		net.WriteEntity(ply)
        net.Send(player.GetAll()) -- send to all players, only markers will handle the data
        
        self:Count()
    end

    function MARKER_DATA:RemoveMarkedPlayer(ply)
        MARKER_DATA.marked_players[tostring(ply:SteamID64() or ply:EntIndex())] = nil

        net.Start('ttt2_role_marker_remove_marking')
		net.WriteEntity(ply)
        net.Send(player.GetAll()) -- send to all players, only markers will handle the data

        self:Count()
    end

    function MARKER_DATA:MarkPlayer(ply)
        STATUS:AddStatus(ply, 'ttt2_role_marker_marked')
    end

    function MARKER_DATA:UnmarkPlayers()
        STATUS:RemoveStatus(player.GetAll(), 'ttt2_role_marker_marked')

        -- clear on server
        MARKER_DATA:ClearMarkedPlayers()

        -- clear on client
        net.Start('ttt2_role_marker_remove_all')
        net.Send(player.GetAll()) -- send to all players, only markers will handle the data
    end

    function MARKER_DATA:NumMarkerAlive()
        local amount = 0
        for _, p in ipairs(player.GetAll()) do
            if p:GetSubRole() == ROLE_MARKER and p:Alive() and p:IsTerror() then 
                amount = amount + 1
            end
        end
        return amount
    end

    function MARKER_DATA:MarkerAlive()
        return self:NumMarkerAlive() > 0
    end

    function MARKER_DATA:UpdateAfterChange()
        -- player alive
        local player_alive, amnt_marker = 0, 0
		for _, p in ipairs(player.GetAll()) do
			if p:Alive() and p:IsTerror() then
				player_alive = player_alive + 1
			end
			if p:Alive() and p:IsTerror() and p:GetSubRole() == ROLE_MARKER then
				amnt_marker = amnt_marker + 1
			end
        end
        self.player_alive = player_alive - amnt_marker

        -- able to win
        self.able_to_win = self.player_alive >= GetConVar('ttt_mark_min_alive'):GetInt()

        -- sync to client
        net.Start('ttt2_role_marker_update')
        net.WriteUInt(self.player_alive, 16)
        net.WriteBool(self.able_to_win)
        net.Send(player.GetAll()) -- send to all players, only markers will handle the data
    end

    function MARKER_DATA:MarkerDied()
        if MARKER_DATA:MarkerAlive() then return end        
        MARKER_DATA:UnmarkPlayers()
    end

    hook.Add('PostPlayerDeath', 'ttt2_role_marker_death', function(victim, infl, attacker)
        -- HANDLE DEATH OF MARKED PLAYER
        MARKER_DATA:RemoveMarkedPlayer(victim)
        MARKER_DATA:UpdateAfterChange()

        -- HANDLE DEATH OF MARKER
        if victim:GetSubRole() ~= ROLE_MARKER then return end
        MARKER_DATA:MarkerDied()
    end)

    hook.Add('PlayerSpawn', 'ttt2_role_marker_player_respawn', function()
        MARKER_DATA:UpdateAfterChange()
    end)

    hook.Add('TTT2UpdateSubrole', 'ttt2_role_marker_update_subrole', function()
        MARKER_DATA:UpdateAfterChange()
    end)
end

function MARKER_DATA:Count()
    local marked_amount = 0
    for i,_ in pairs(MARKER_DATA.marked_players) do
        marked_amount = marked_amount + 1
    end
    self.marked_amount = marked_amount
end

function MARKER_DATA:ClearMarkedPlayers()
    self.marked_players = {}
    self.marked_amount = 0
    self.player_alive = 0
    self.able_to_win = true
end

function MARKER_DATA:GetNoMarkerPlayerAlive()
    return self.player_alive
end

function MARKER_DATA:GetMarkedAmount()
    return self.marked_amount
end

function MARKER_DATA:AbleToWin()
    return self.able_to_win
end

hook.Add('TTTBeginRound', 'ttt2_role_marker_reset', function()
    MARKER_DATA:ClearMarkedPlayers()

    if SERVER then
        MARKER_DATA:UpdateAfterChange()
    end
end)