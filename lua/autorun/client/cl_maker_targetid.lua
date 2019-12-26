-- handle looking at sodas
hook.Add('TTTRenderEntityInfo', 'ttt2_marker_highlight_players', function(data, params)
	-- while client is setting up, ignore missing MARKER
	if not MARKER then return end

	-- has to be a player
	if not data.ent:IsPlayer() then return end

	if LocalPlayer():GetSubRole() ~= ROLE_MARKER then return end

	if GetGlobalBool('ttt_mark_deal_no_damage', false) then
		params.displayInfo.desc[#params.displayInfo.desc + 1] = {
			text = LANG.GetTranslation('ttt_marker_player_deal_no_damage'),
			color = COLOR_RED
		}
	end

	-- only add further text to marked players
	if not MARKER_DATA:IsMarked(data.ent) then return end

	if GetGlobalBool('ttt_mark_take_no_damage', false) then
		params.displayInfo.desc[#params.displayInfo.desc + 1] = {
			text = LANG.GetTranslation('ttt_marker_player_take_no_damage'),
			color = COLOR_GREEN
		}
	end

	params.displayInfo.desc[#params.displayInfo.desc + 1] = {
		text = LANG.GetTranslation('ttt_marker_player_marked'),
		color = MARKER.ltcolor
	}

	params.displayInfo.icon[#params.displayInfo.icon + 1] = {
		material = MARKER.iconMaterial,
		color = MARKER.ltcolor
	}
end)