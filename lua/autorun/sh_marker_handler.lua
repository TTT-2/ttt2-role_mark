MARKER_DATA = {}
MARKER_DATA.marked_players = {}
MARKER_DATA.marked_amount = 0

if CLIENT then
    net.Receive('ttt2_role_marker_new_marking', function()
        local marked_player = net.ReadEntity()

        MARKER_DATA.marked_players[tostring(marked_player:SteamID64() or marked_player:EntIndex())] = true

        MARKER_DATA:Count()
    end)

    net.Receive('ttt2_role_marker_remove_marking', function()
        local marked_player = net.ReadEntity()

        MARKER_DATA.marked_players[tostring(marked_player:SteamID64() or marked_player:EntIndex())] = nil

        MARKER_DATA:Count()
    end)
end

if SERVER then
    util.AddNetworkString('ttt2_role_marker_new_marking')
    util.AddNetworkString('ttt2_role_marker_remove_marking')

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
    end

    hook.Add('PlayerDeath', 'ttt2_role_marker_death', function(victim, infl, attacker)
        -- remove player from marked list
        MARKER_DATA:RemoveMarkedPlayer(victim)

        -- handle death of marker
        if victim:GetSubRole() ~= ROLE_MARKER then return end

        for _, p in ipairs(player.GetAll()) do
            if p:GetSubRole() == ROLE_MARKER  and p:Alive() and p:IsTerror() then return end-- more than one marker was active
        end
        MARKER_DATA:UnmarkPlayers()
    end)
end

function MARKER_DATA:Count()
    local marked_amount = 0
    for i,_ in pairs(MARKER_DATA.marked_players) do
        marked_amount = marked_amount + 1
    end
    MARKER_DATA.marked_amount = marked_amount
end

hook.Add('TTTBeginRound', 'ttt2_role_marker_reset', function()
    MARKER_DATA.marked_players = {}
    MARKER_DATA.marked_amount = 0
end)