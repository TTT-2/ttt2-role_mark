L = LANG.GetLanguageTableReference("italiano")

-- GENERAL ROLE LANGUAGE STRINGS
L[MARKER.name] = "Marker"
L[TEAM_MARKER] = "TEAM marker"
L["info_popup_" .. MARKER.name] = [[Sei il Marker!
	Prova a marcare tutti i giocatori! È difficile, ma non aspettare fino a quando non rimangono pochi giocatori...]]
L["body_found_" .. MARKER.abbr] = "Era un Marker."
L["search_role_" .. MARKER.abbr] = "Questa persona era un Marker!"
L["target_" .. MARKER.name] = "Marker"
L["ttt2_desc_" .. MARKER.name] = [[Il marker deve vincere da solo!]]
L["hilite_win_" .. TEAM_MARKER] = "IL MARKER HA VINTO"
L["win_" .. TEAM_MARKER] = "Il Marker ha vinto!"
L["ev_win_" .. TEAM_MARKER] = "Il Marker malvagio ha vinto round!"
L["credit_" .. MARKER.abbr .. "_all"] = "Marker, vi sono stati dati {num} credito/i per la vostra performance."

-- OTHER ROLE LANGUAGE STRINGS
L["ttt_marker_was_marked"] = "Questo giocatore sembra essere pieno di vernice. È stato marcato!"
L["ttt_marker_player_deal_no_damage"] = "Sei un marker, non puoi fare danno!"
L["ttt_marker_player_take_no_damage"] = "Questo giocatore è un marker e non può farti danno!"
L["ttt_marker_marked"] = "Sembra che questo giocatore sia stato marcato."
L["ttt_marker_died"] = "Sembra che un giocatore marcato sia morto."
L["ttt_marker_player_marked"] = "IL GIOCATORE È MARCATO"
L["ttt_markerdefi_desc"] = "Riporta in vita i giocatori morti come marcati. Mantengono il loro ruolo."

--L["weapon_markerdefi_name"] = "Marker's Defi"
--L["weapon_markerdefi_desc"] = "Revives dead people as marked players. They keep their role."

--L["revived_by_marker"] = "You are revived by {name}. You will keep your role but you will be marked. Prepare yourself!"
--L["markerdefi_hold_key_to_revive"] = "Hold [{key}] to revive player as a marked player"
--L["markerdefi_revive_progress"] = "Time left: {time}s"
--L["markerdefi_charging"] = "Defibrillator is recharging, please wait"
--L["markerdefi_player_already_reviving"] = "Player is already reviving"
--L["markerdefi_error_no_space"] = "There is insufficient room available for this revival attempt."
--L["markerdefi_error_too_fast"] = "Defibrillator is recharging. Please wait."
--L["markerdefi_error_lost_target"] = "You lost your target. Please try again."
--L["markerdefi_error_no_valid_ply"] = "You can't revive this player since they are no longer valid."
--L["markerdefi_error_already_reviving"] = "You can't revive this player since they are already reviving."
--L["markerdefi_error_failed"] = "Revival attempt failed. Please try again."
