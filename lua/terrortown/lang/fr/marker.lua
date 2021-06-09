local L = LANG.GetLanguageTableReference("fr")

-- GENERAL ROLE LANGUAGE STRINGS
L[MARKER.name] = "Marqueur"
L[TEAM_MARKER] = "TEAM du Marqueur"
L["info_popup_" .. MARKER.name] = [[Vous êtes le Marqueur!
	Essayez de marquer tous les joueurs! C'est difficile, mais n'attendez pas qu'il ne reste plus que quelques joueurs...]]
L["body_found_" .. MARKER.abbr] = "C'était un Marqueur."
L["search_role_" .. MARKER.abbr] = "C'était un Marqueur!"
L["target_" .. MARKER.name] = "Marqueur"
L["ttt2_desc_" .. MARKER.name] = [[Le Marqueur doit gagner seul!]]
L["hilite_win_" .. TEAM_MARKER] = "LE MARQUEUR A GAGNÉ"
L["win_" .. TEAM_MARKER] = "Le Marqueur a gagné!"
L["ev_win_" .. TEAM_MARKER] = "Le méchant Marqueur a gagné le round!"
L["credit_" .. MARKER.abbr .. "_all"] = "Marqueur, vous avez été récompensé de {num} crédit(s) d'équipement pour votre performances."

-- OTHER ROLE LANGUAGE STRINGS
L["ttt_marker_was_marked"] = "Ce joueur semble être couvert de peinture. Il a été marqué!"
L["ttt_marker_player_deal_no_damage"] = "Vous êtes un Marqueur, vous ne pouvez pas faire de dégâts!"
L["ttt_marker_player_take_no_damage"] = "Ce joueur est marqué et ne peut pas vous faire de mal!"
L["ttt_marker_marked"] = "Il semble qu'un joueur ait été marqué."
L["ttt_marker_died"] = "Il semble qu'un joueur marqué soit mort."
L["ttt_marker_player_marked"] = "LE JOUEUR EST MARQUÉ"

L["weapon_markerdefi_name"] = "Défibrillateur du Marqueur"
L["weapon_markerdefi_desc"] = "Ressuscite les morts en tant que joueurs marqués. Ils conservent leur rôle."

L["ttt2_paintgun_name"] = "Pistolet a Peinture"
L["ttt2_paintgun_desc"] = "Marque les joueurs en les couvrant de peinture."

L["revived_by_marker"] = "Vous êtes réanimé par {name}. Vous conserverez votre rôle mais vous serez marqué. Préparez-vous!"
L["markerdefi_hold_key_to_revive"] = "Maintenez [{key}] pour réanimer le joueur en tant que joueur marqué"
L["markerdefi_revive_progress"] = "Temps restant: {time}s"
L["markerdefi_charging"] = "Le défibrillateur est en train de se recharger, veuillez patienter"
L["markerdefi_player_already_reviving"] = "Ce joueur est déjà ressuscité"
L["markerdefi_error_no_space"] = "Il n'y a pas assez de place pour réanimer a cet endroit."
L["markerdefi_error_too_fast"] = "Le défibrillateur est en train de se recharger. Veuillez patienter."
L["markerdefi_error_lost_target"] = "Vous avez perdu votre cible. Veuillez réessayer."
L["markerdefi_error_no_valid_ply"] = "Vous ne pouvez pas réanimer ce joueur car son corps n'existe pas ou n'est plus valide."
L["markerdefi_error_already_reviving"] = "Vous ne pouvez pas réanimer ce joueur parce qu'il est déjà réanimé."
L["markerdefi_error_failed"] = "La tentative de réanimation a échoué. Veuillez réessayer."
L["markerdefi_error_player_alive"] = "Vous ne pouvez pas réanimer ce joueur parce qu'il est déjà réanimé."

L["tooltip_marked_score"] = "Joueur Marqué: {score}"
L["marked_score"] = "Joueur Marqué:"
L["title_event_marked"] = "Un joueur a était marqué"
L["desc_event_marked"] = "{marker} a marqué {markee} ({mrole} / {mteam})."
L["desc_event_marked_paintgun"] = "Il a utilisé le Pistolet a Peinture."
L["desc_event_marked_revival"] = "Il a utilisé le Défibrillateur du Marqueur."
