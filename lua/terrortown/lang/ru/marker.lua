local L = LANG.GetLanguageTableReference("ru")

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
--L["label_mark_hurt_marked_factor"] = "Damage marked players deal to the Marker"

--L["marker_corpse_player"] = "Corpse of {nick}"
