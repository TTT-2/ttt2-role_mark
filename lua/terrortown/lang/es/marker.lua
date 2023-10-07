local L = LANG.GetLanguageTableReference("es")

-- GENERAL ROLE LANGUAGE STRINGS
L[MARKER.name] = "Pintor"
L[TEAM_MARKER] = "Equipo Pintor"
L["info_popup_" .. MARKER.name] = [[¡Eres el Pintor!
	¡Intenta marcar a todos los jugadores! Es difícil, pero no esperes a que sean pocas personas...]]
L["body_found_" .. MARKER.abbr] = "¡Era un Pintor!."
L["search_role_" .. MARKER.abbr] = "Esta persona era Pintor."
L["target_" .. MARKER.name] = "Pintor"
L["ttt2_desc_" .. MARKER.name] = [[¡El Pintor gana solo!]]
L["hilite_win_" .. TEAM_MARKER] = "EL Pintor GANA"
L["win_" .. TEAM_MARKER] = "¡El Pintor ha ganado!"
L["ev_win_" .. TEAM_MARKER] = "¡El Malvado Pintor ha ganado esta ronda!"
L["credit_" .. MARKER.abbr .. "_all"] = "Pintores, han sido recompensados con {num} crédito(s) por su desempeño."

-- OTHER ROLE LANGUAGE STRINGS
L["ttt_marker_was_marked"] = "Parece que esta persona estaba pintada de color ¡Estaba marcado!"
L["ttt_marker_player_deal_no_damage"] = "¡Eres un Pintor, no puedes hacer daño!"
L["ttt_marker_player_take_no_damage"] = "¡Este jugador es un Pintor y no puede hacerte daño!"
L["ttt_marker_marked"] = "Parece que un jugador ha sido marcado."
L["ttt_marker_died"] = "Parece que un jugador marcado ha muerto."
L["ttt_marker_player_marked"] = "JUGADOR MARCADO"

L["weapon_markerdefi_name"] = "Desfribilador"
L["weapon_markerdefi_desc"] = "Revive a las personas como MARCADO. Mantienen su rol original."

L["ttt2_paintgun_name"] = "Brocha del Pintor"
L["ttt2_paintgun_desc"] = "Marca a los jugadores pintándolos de color."

L["revived_by_marker"] = "Estás siendo revivido por {name}. Mantendrás tu rol pero reaparecerás marcado ¡Prepárate!"
L["markerdefi_hold_key_to_revive"] = "Mantén [{key}] para vivir a una persona como marcada"
L["markerdefi_revive_progress"] = "Tiempo restante: {time}s"
L["markerdefi_charging"] = "El Desfribilador está recargándose, por favor espera."
L["markerdefi_player_already_reviving"] = "Este jugador ya está siendo revivido."
L["markerdefi_error_no_space"] = "No hay espacio suficiente en la habitación para revivir a esta persona."
L["markerdefi_error_too_fast"] = "El Desfribilador está recargándose, por favor espere."
L["markerdefi_error_lost_target"] = "Perdió de vista a su objetivo. Intenta de nuevo."
L["markerdefi_error_no_valid_ply"] = "No puedes revivir a este jugador ya que su cuerpo no existe o no es válido."
L["markerdefi_error_already_reviving"] = "No puedes revivir a este jugador porque ya lo están reviviendo."
L["markerdefi_error_failed"] = "Intento de revivir fallido. Intenta de nuevo."
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
