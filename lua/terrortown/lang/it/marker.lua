local L = LANG.GetLanguageTableReference("it")

-- GENERAL ROLE LANGUAGE STRINGS
L[MARKER.name] = "Marker"
L[TEAM_MARKER] = "Team Marker"
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

L["weapon_markerdefi_name"] = "Defibrillatore Marker"
L["weapon_markerdefi_desc"] = "Riporta in vita i giocatori morti come marcati. Mantengono il loro ruolo."

--L["ttt2_paintgun_name"] = "Marker's Gun"
--L["ttt2_paintgun_desc"] = "Marks players while covering them in color."

L["revived_by_marker"] = "Sei stato rianimato da {name}. Terrai il tuo ruolo ma sarai marcato. Preparati!"
L["markerdefi_hold_key_to_revive"] = "Tieni premuto [{key}] per rianimarli marchiati"
L["markerdefi_revive_progress"] = "Tempo rimasto: {time} secondi"
L["markerdefi_charging"] = "Il defibrillatore si sta ricaricando, per favore aspetta"
L["markerdefi_player_already_reviving"] = "Il giocatore sta venendo rianimato"
L["markerdefi_error_no_space"] = "Non c'è abbastanza spazio disponibile per questo tentativo di rianimazione."
L["markerdefi_error_too_fast"] = "Il defibrillatore si sta ricaricando, per favore aspetta"
L["markerdefi_error_lost_target"] = "Hai perso il tuo bersaglio. Per favore riprova."
L["markerdefi_error_no_valid_ply"] = "Non puoi rianimare questo giocatore perchè non è più valido."
L["markerdefi_error_already_reviving"] = "Non puoi rianimare questo giocatore perchè lo stanno rianimando."
L["markerdefi_error_failed"] = "Tentativo di rianimazione fallito. Per favore riprova."
--L["markerdefi_error_player_alive"] = "You can't revive this player since they are already alive."

--L["tooltip_marked_score"] = "Marked: {score}"
--L["marked_score"] = "Marked:"
--L["title_event_marked"] = "A player got marked"
--L["desc_event_marked"] = "{marker} has marked {markee} ({mrole} / {mteam})."
--L["desc_event_marked_paintgun"] = "They used their Marker's Gun."
--L["desc_event_marked_revival"] = "They used their Marker's Defi."

--L["label_mark_show_sidebar"] = "Marked players get symbol in their status display"
--L["label_mark_show_messages"] = "Marker informed via message if player was marked/marked player dies"
--L["label_mark_deal_no_damage"] = "Marker can't deal damage"
--L["label_mark_take_no_damage"] = "Marked players can't damage the Marker"
--L["label_mark_min_alive"] = "Lower limit when the Marker is unable to win"
--L["label_mark_max_to_mark"] = "Upper limit of how many players have to be marked"
--L["label_mark_pct_marked"] = "Pct of alive non Marker to be marked to win"
--L["label_mark_fixed_mark_amount"] = "Max value (-1 to use scaled max)"
--L["label_mark_defi_factor"] = "Factor to calculate amount of defis"
--L["label_mark_defi_revive_time"] = "Time it takes for revival"
--L["label_mark_defi_error_time"] = "Timeout after failed revival"
--L["label_mark_hurt_marked_factor"] = "Damage marked players deal to the Marker"

--L["marker_corpse_player"] = "Corpse of {nick}"
