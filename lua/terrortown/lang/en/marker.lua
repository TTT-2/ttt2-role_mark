local L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[MARKER.name] = "Marker"
L[TEAM_MARKER] = "Team Marker"
L["info_popup_" .. MARKER.name] = [[You are the Marker!
	Try to mark all players! It's hard, but don't wait until only a few players are left...]]
L["body_found_" .. MARKER.abbr] = "They were a Marker."
L["search_role_" .. MARKER.abbr] = "This person was a Marker!"
L["target_" .. MARKER.name] = "Marker"
L["ttt2_desc_" .. MARKER.name] = [[The Marker needs to win alone!]]
L["hilite_win_" .. TEAM_MARKER] = "TEAM MARKER WON"
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

L["weapon_markerdefi_name"] = "Marker's Defi"
L["weapon_markerdefi_desc"] = "Revives dead people as marked players. They keep their role."

L["ttt2_paintgun_name"] = "Marker's Gun"
L["ttt2_paintgun_desc"] = "Marks players while covering them in color."

L["revived_by_marker"] = "You are revived by {name}. You will keep your role but you will be marked. Prepare yourself!"

L["tooltip_marked_score"] = "Marked: {score}"
L["marked_score"] = "Marked:"
L["title_event_marked"] = "A player got marked"
L["desc_event_marked"] = "{marker} has marked {markee} ({mrole} / {mteam})."
L["desc_event_marked_paintgun"] = "They used their Marker's Gun."
L["desc_event_marked_revival"] = "They used their Marker's Defi."

L["label_mark_show_sidebar"] = "Marked players get symbol in their status display"
L["label_mark_show_messages"] = "Marker informed via message if player was marked/marked player dies"
L["label_mark_deal_no_damage"] = "Marker can't deal damage"
L["label_mark_take_no_damage"] = "Marked players can't damage the Marker"
L["label_mark_min_alive"] = "Lower limit when the Marker is unable to win"
L["label_mark_max_to_mark"] = "Upper limit of how many players have to be marked"
L["label_mark_pct_marked"] = "Pct of alive non Marker to be marked to win"
L["label_mark_fixed_mark_amount"] = "Max value (-1 to use scaled max)"
L["label_mark_hurt_marked_factor"] = "Damage marked players deal to the Marker"

L["marker_corpse_player"] = "Corpse of {nick}"
