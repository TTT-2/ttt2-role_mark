-- handle looking at sodas
hook.Add('TTTRenderEntityInfo', 'ttt2_marker_highlight_players', function(data, params)
    -- while client is setting up, ignore missing MARKER
    if not MARKER then return end

    local client = LocalPlayer()
    local obsTgt = client:GetObserverTarget()

    -- has to be a player
    if not data.ent:IsPlayer() then return end

    -- only add text to marked players
    if not MARKER_DATA:IsMarked(data.ent) then return end

    params.displayInfo.desc[#params.displayInfo.desc + 1] = {
        text = LANG.GetTranslation('ttt_marker_player_marked'),
        color = MARKER.bgcolor
    }

    params.displayInfo.icon[#params.displayInfo.icon + 1] = {
        material = MARKER.iconMaterial,
        color = Color(MARKER.bgcolor.r, MARKER.bgcolor.g, MARKER.bgcolor.b, 75)
    }
end)