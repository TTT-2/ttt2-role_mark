MARKER_DATA = {}
MARKER_DATA.marked_players = {}
MARKER_DATA.marked_amount = 0

if CLIENT then
    net.Receive('ttt2_role_marker_new_marking', function()
        local marked_player = net.ReadEntity()

        MARKER_DATA.marked_players[tostring(marked_player:SteamID64() or marked_player:EntIndex())] = true

        local marked_amount = 0
        for i,_ in pairs(MARKER_DATA.marked_players) do
            marked_amount = marked_amount + 1
        end
        MARKER_DATA.marked_amount = marked_amount
    end)
end

if SERVER then
    util.AddNetworkString('ttt2_role_marker_new_marking')

    function MARKER_DATA:SetMarkedPlayer(ply, attacker)
        MARKER_DATA.marked_players[tostring(ply:SteamID64() or ply:EntIndex())] = true

        net.Start('ttt2_role_marker_new_marking')
		net.WriteEntity(ply)
        net.Send(attacker)
        
        local marked_amount = 0
        for i,_ in pairs(MARKER_DATA.marked_players) do
            marked_amount = marked_amount + 1
        end
        MARKER_DATA.marked_amount = marked_amount
    end
end

hook.Add('TTTBeginRound', 'ttt2_role_marker_reset', function()
    MARKER_DATA.marked_players = {}
    MARKER_DATA.marked_amount = 0
end)