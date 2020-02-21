L = LANG.GetLanguageTableReference("english")

-- GENERAL ROLE LANGUAGE STRINGS
L[MARKER.name] = "Markierer"
L[TEAM_MARKER] = "TEAM Markierer"
L["info_popup_" .. MARKER.name] = [[Du bist ein Markierer!
	Versuche alle anderen spieler zu markieren! Aber warte nicht so lange bis nur noch ein paar Spieler übrig sind...]]
L["body_found_" .. MARKER.abbr] = "Er war ein Markierer..."
L["search_role_" .. MARKER.abbr] = "Diese Person war ein Markierer!"
L["target_" .. MARKER.name] = "Markierer"
L["ttt2_desc_" .. MARKER.name] = [[Der Markierer muss alleine gewinnen!]]
L["hilite_win_" .. TEAM_MARKER] = "THE MARKER WON"
L["win_" .. TEAM_MARKER] = "Der Marker hat gewonnen!"
L["ev_win_" .. TEAM_MARKER] = "Der böse Marker hat die Runde gewonnen!"
L["credit_" .. MARKER.abbr .. "_all"] = "Marker, dir wurde(n) {num} Ausrüstungs-Credit(s) für deine Leistung gegeben."

-- OTHER ROLE LANGUAGE STRINGS
L["ttt_marker_was_marked"] = "Dieser Spieler scheint mit Farbe übergossen zu sein. Er wurde markiert!"
L["ttt_marker_player_deal_no_damage"] = "Du bist ein Markierer, du kannst keinen Schaden machen!"
L["ttt_marker_player_take_no_damage"] = "Dieser Spieler ist markiert und kann dich nicht verletzen!"
L["ttt_marker_marked"] = "Es scheint so, als wäre ein weiterer Spieler markiert worden."
L["ttt_marker_died"] = "Es scheint so, als wäre ein markierter Spieler gestorben."
L["ttt_marker_player_marked"] = "SPIELER IST MARKIERT"
L["ttt_markerdefi_desc"] = "Belebt tote Spieler als markierte Spieler wieder. Sie behalten ihre Rolle."
