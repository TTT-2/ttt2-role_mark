local L = LANG.GetLanguageTableReference("Русский")

-- GENERAL ROLE LANGUAGE STRINGS
L[MARKER.name] = "Маркер"
L[TEAM_MARKER] = "Команда маркеров"
L["info_popup_" .. MARKER.name] = [[Вы маркер!
	Попробуйте отметить всех игроков! Это сложно, но не ждите, пока останется несколько игроков...]]
L["body_found_" .. MARKER.abbr] = "Он был маркером."
L["search_role_" .. MARKER.abbr] = "Этот человек был маркером!"
L["target_" .. MARKER.name] = "Маркер"
L["ttt2_desc_" .. MARKER.name] = [[Маркер должен победить в одиночку!]]
L["hilite_win_" .. TEAM_MARKER] = "ПОБЕДА МАРКЕРОВ"
L["win_" .. TEAM_MARKER] = "Маркер выиграл!"
L["ev_win_" .. TEAM_MARKER] = "Злой Маркер выиграл раунд!"
L["credit_" .. MARKER.abbr .. "_all"] = "Маркеры, за вашу работу вы получили {num} кредит(а/ов) за вашу работу."

-- OTHER ROLE LANGUAGE STRINGS
L["ttt_marker_was_marked"] = "Этот игрок кажется покрыт цветом. Они были отмечены!"
L["ttt_marker_player_deal_no_damage"] = "Вы маркер, вы не можете нанести урон!"
L["ttt_marker_player_take_no_damage"] = "Этот игрок отмечен и не может причинить вам вреда!"
L["ttt_marker_marked"] = "Похоже, игрок был отмечен."
L["ttt_marker_died"] = "Похоже, что отмеченный игрок умер."
L["ttt_marker_player_marked"] = "ИГРОК ОТМЕЧЕН"

L["weapon_markerdefi_name"] = "Дефи маркера"
L["weapon_markerdefi_desc"] = "Оживляет мёртвых людей как отмеченных игроков. Они сохраняют свою роль."

L["ttt2_paintgun_name"] = "Маркерное ружьё"
L["ttt2_paintgun_desc"] = "Отмечает игроков, покрывая их цветом."

L["revived_by_marker"] = "Вас возрождает {name}. Вы сохраните свою роль, но будете отмечены. Приготовься!"
L["markerdefi_hold_key_to_revive"] = "Удерживайте [{key}], чтобы оживить игрока как отмеченного игрока"
L["markerdefi_revive_progress"] = "Осталось времени: {time}с"
L["markerdefi_charging"] = "Дефибриллятор заряжается, подождите"
L["markerdefi_player_already_reviving"] = "Игрок уже оживает"
L["markerdefi_error_no_space"] = "Недостаточно места для этой попытки возрождения."
L["markerdefi_error_too_fast"] = "Дефибриллятор заряжается. Пожалуйста, подождите."
L["markerdefi_error_lost_target"] = "Вы потеряли цель. Пожалуйста, попробуйте ещё раз."
L["markerdefi_error_no_valid_ply"] = "Вы не можете оживить этого игрока, так как он больше не действителен."
L["markerdefi_error_already_reviving"] = "Вы не можете оживить этого игрока, так как он уже оживает."
L["markerdefi_error_failed"] = "Попытка возрождения не удалась. Пожалуйста, попробуйте ещё раз."
