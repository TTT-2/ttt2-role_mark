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
