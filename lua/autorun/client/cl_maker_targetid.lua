-- handle looking at sodas
hook.Add('TTTRenderEntityInfo', 'ttt2_marker_highlight_players', function(tData)
	-- while client is setting up, ignore missing MARKER
	if not MARKER then return end

	local ent = tData:GetEntity()

	-- has to be a player
	if not ent:IsPlayer() then return end

	if LocalPlayer():GetSubRole() ~= ROLE_MARKER then return end

	if GetGlobalBool('ttt_mark_deal_no_damage', false) then
		tData:AddDescriptionLine(
			LANG.GetTranslation('ttt_marker_player_deal_no_damage'),
			COLOR_RED
		)
	end

	-- only add further text to marked players
	if not MARKER_DATA:IsMarked(ent) then return end

	if GetGlobalBool('ttt_mark_take_no_damage', false) then
		tData:AddDescriptionLine(
			LANG.GetTranslation('ttt_marker_player_take_no_damage'),
			COLOR_GREEN
		)
	end

	tData:AddDescriptionLine(
		LANG.GetTranslation('ttt_marker_player_marked'),
		MARKER.ltcolor
	)

	tData:AddIcon(
		MARKER.iconMaterial,
		MARKER.ltcolor
	)
end)
