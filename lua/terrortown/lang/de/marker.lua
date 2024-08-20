local L = LANG.GetLanguageTableReference("de")

-- GENERAL ROLE LANGUAGE STRINGS
L[MARKER.name] = "Markierer"
L[TEAM_MARKER] = "Team Markierer"
L["info_popup_" .. MARKER.name] = [[Du bist ein Markierer!
	Versuche alle anderen Spieler zu markieren! Aber warte nicht so lange bis nur noch ein paar Spieler übrig sind...]]
L["body_found_" .. MARKER.abbr] = "Er war ein Markierer..."
L["search_role_" .. MARKER.abbr] = "Diese Person war ein Markierer!"
L["target_" .. MARKER.name] = "Markierer"
L["ttt2_desc_" .. MARKER.name] = [[Der Markierer muss alleine gewinnen!]]
L["hilite_win_" .. TEAM_MARKER] = "TEAM MARKIERER GEWANN"
L["win_" .. TEAM_MARKER] = "Der Markierer hat gewonnen!"
L["ev_win_" .. TEAM_MARKER] = "Der böse Markierer hat die Runde gewonnen!"
L["credit_" .. MARKER.abbr .. "_all"] = "Markierer, dir wurde(n) {num} Ausrüstungs-Credit(s) für deine Leistung gegeben."

-- OTHER ROLE LANGUAGE STRINGS
L["ttt_marker_was_marked"] = "Dieser Spieler scheint mit Farbe übergossen zu sein. Er wurde markiert!"
L["ttt_marker_player_deal_no_damage"] = "Du bist ein Markierer, du kannst keinen Schaden machen!"
L["ttt_marker_player_take_no_damage"] = "Dieser Spieler ist markiert und kann dich nicht verletzen!"
L["ttt_marker_marked"] = "Es scheint so, als wäre ein weiterer Spieler markiert worden."
L["ttt_marker_died"] = "Es scheint so, als wäre ein markierter Spieler gestorben."
L["ttt_marker_player_marked"] = "SPIELER IST MARKIERT"

L["weapon_markerdefi_name"] = "Markierer Defi"
L["weapon_markerdefi_desc"] = "Belebt tote Spieler als markierte Spieler wieder. Sie behalten ihre Rolle."

L["ttt2_paintgun_name"] = "Markierer Farbwaffe"
L["ttt2_paintgun_desc"] = "Markiert Spieler indem sie mit Farbe übergossen werden."

L["revived_by_marker"] = "Du wirst von {name} wiederbelebt. Du behältst deine Rolle, bist aber automatisch markiert. Halte dich bereit!"

L["tooltip_marked_score"] = "Markiert: {score}"
L["marked_score"] = "Markiert:"
L["title_event_marked"] = "Ein Spieler wurde markiert"
L["desc_event_marked"] = "{marker} hat {markee} ({mrole} / {mteam}) markiert."
L["desc_event_marked_paintgun"] = "Er hat seine Markierer Farbwaffe verwendet."
L["desc_event_marked_revival"] = "Er hat seinen Markierer Defi verwendet."

L["label_mark_show_sidebar"] = "Markierte Spieler erhalten Symbol in ihrer Statusanzeige"
L["label_mark_show_messages"] = "Markierer wird per Nachricht informiert, wenn Spieler markiert wurde/markierter Spieler stirbt"
L["label_mark_deal_no_damage"] = "Markierer kann keinen Schaden verursachen"
L["label_mark_take_no_damage"] = "Markierte Spieler können den Markierer nicht schaden"
L["label_mark_min_alive"] = "Untergrenze, wenn Markierer nicht gewinnen kann"
L["label_mark_max_to_mark"] = "Obergrenze, wie viele Spieler markiert werden müssen"
L["label_mark_pct_marked"] = "Prozent lebender Nicht-Markierer zum markieren um zu gewinnen"
L["label_mark_fixed_mark_amount"] = "Maximalwert (-1, um skalierten Maximalwert zu nutzen)"
L["label_mark_hurt_marked_factor"] = "Schaden markierte Spieler dem Markierer zufügen"

--L["marker_corpse_player"] = "Leiche von {nick}"
