local materialDamage = Material("vgui/ttt/dynamic/roles/icon_traitor")

-- handle looking at sodas
hook.Add("TTTRenderEntityInfo", "ttt2_marker_highlight_focused_players", function(tData)
	-- while client is setting up, ignore missing MARKER
	if not MARKER then return end

	local ent = tData:GetEntity()

	-- has to be a player
	if not ent:IsPlayer() then return end

	if LocalPlayer():GetSubRole() ~= ROLE_MARKER then return end

	if tData:GetAmountDescriptionLines() > 0
		and (MARKER_DATA:IsMarked(ent) or GetGlobalBool("ttt_mark_deal_no_damage", false))
	then
		tData:AddDescriptionLine()
	end

	if MARKER_DATA:IsMarked(ent) then
		tData:AddDescriptionLine(
			LANG.GetTranslation("ttt_marker_player_marked"),
			MARKER.ltcolor
		)

		tData:AddIcon(
			MARKER.iconMaterial,
			MARKER.ltcolor
		)

		if GetGlobalBool("ttt_mark_take_no_damage", false) then
			tData:AddDescriptionLine()

			tData:AddDescriptionLine(
				LANG.GetTranslation("ttt_marker_player_take_no_damage"),
				COLOR_WHITE,
				{materialDamage}
			)
		end
	end

	if GetGlobalBool("ttt_mark_deal_no_damage", false) and not (MARKER_DATA:IsMarked(ent) and GetGlobalBool("ttt_mark_hurt_marked", false))  then
		tData:AddDescriptionLine(
			LANG.GetTranslation("ttt_marker_player_deal_no_damage"),
			COLOR_ORANGE,
			{materialDamage}
		)
	end
end)
