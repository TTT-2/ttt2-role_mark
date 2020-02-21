L = LANG.GetLanguageTableReference("english")

-- GENERAL ROLE LANGUAGE STRINGS
L[MARKER.name] = "Marker"
L[TEAM_MARKER] = "TEAM marker"
L["info_popup_" .. MARKER.name] = [[You are the Marker!
	Try to mark all players! It"s hard, but don"t wait until only a few players are left...]]
L["body_found_" .. MARKER.abbr] = "They were a Marker."
L["search_role_" .. MARKER.abbr] = "This person was a Marker!"
L["target_" .. MARKER.name] = "Marker"
L["ttt2_desc_" .. MARKER.name] = [[The Marker needs to win alone!]]
L["hilite_win_" .. TEAM_MARKER] = "THE MARKER WON"
L["win_" .. TEAM_MARKER] = "The Marker has won!"
L["ev_win_" .. TEAM_MARKER] = "The evil Marker won the round!"
L["credit_" .. MARKER.abbr .. "_all"] = "Markers, you have been awarded {num} equipment credit(s) for your performance."

-- OTHER ROLE LANGUAGE STRINGS
L["ttt_marker_was_marked"] = "This player seems to be covered in color. They were marked!"
L["ttt_marker_player_deal_no_damage"] = "You are a marker, you can't deal any damage!"
L["ttt_marker_player_take_no_damage"] = "This player is marked and can't hurt you!"
L["ttt_marker_marked"] = "It seems like a player was marked."
L["ttt_marker_died"] = "It seems like a marked player died."
L["ttt_marker_player_marked"] = "PLAYER IS MARKED"
L["ttt_markerdefi_desc"] = "Revives dead people as marked players. They keep their role."
