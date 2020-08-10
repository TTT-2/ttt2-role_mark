CreateConVar("ttt_mark_show_sidebar", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_mark_show_messages", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_mark_min_alive", 4, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_mark_max_to_mark", 9, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_mark_pct_marked", 0.75, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_mark_fixed_mark_amount", -1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_mark_deal_no_damage", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_mark_take_no_damage", 1, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_mark_defi_factor", 0.34, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_mark_defi_revive_time", 2.0, {FCVAR_NOTIFY, FCVAR_ARCHIVE})
CreateConVar("ttt_mark_defi_error_time", 1.0, {FCVAR_NOTIFY, FCVAR_ARCHIVE})

if SERVER then
	-- ConVar replication is broken in GMod, so we do this, at least Alf added a hook!
	-- I don't like it any more than you do, dear reader. Copycat!
	hook.Add("TTT2SyncGlobals", "ttt2_marker_sync_convars", function()
		SetGlobalBool("ttt_mark_deal_no_damage", GetConVar("ttt_mark_deal_no_damage"):GetBool())
		SetGlobalBool("ttt_mark_take_no_damage", GetConVar("ttt_mark_take_no_damage"):GetBool())
	end)

	-- sync convars on change
	cvars.AddChangeCallback("ttt_mark_deal_no_damage", function(cv, old, new)
		SetGlobalBool("ttt_mark_deal_no_damage", tobool(tonumber(new)))
	end)

	cvars.AddChangeCallback("ttt_mark_take_no_damage", function(cv, old, new)
		SetGlobalBool("ttt_mark_take_no_damage", tobool(tonumber(new)))
	end)
end

hook.Add("TTTUlxDynamicRCVars", "ttt2_ulx_dynamic_marker_convars", function(tbl)
	tbl[ROLE_MARKER] = tbl[ROLE_MARKER] or {}

	table.insert(tbl[ROLE_MARKER], {cvar = "ttt_mark_show_sidebar", checkbox = true, desc = "ttt_mark_show_sidebar (def. 1)"})
	table.insert(tbl[ROLE_MARKER], {cvar = "ttt_mark_show_messages", checkbox = true, desc = "ttt_mark_show_messages (def. 1)"})
	table.insert(tbl[ROLE_MARKER], {cvar = "ttt_mark_deal_no_damage", checkbox = true, desc = "ttt_mark_deal_no_damage (def. 1)"})
	table.insert(tbl[ROLE_MARKER], {cvar = "ttt_mark_take_no_damage", checkbox = true, desc = "ttt_mark_take_no_damage (def. 1)"})
	table.insert(tbl[ROLE_MARKER], {cvar = "ttt_mark_min_alive", slider = true, min = 0, max = 25, decimal = 0, desc = "ttt_mark_min_alive (def. 4)"})
	table.insert(tbl[ROLE_MARKER], {cvar = "ttt_mark_max_to_mark", slider = true, min = 0, max = 25, decimal = 0, desc = "ttt_mark_max_to_mark (def. 9)"})
	table.insert(tbl[ROLE_MARKER], {cvar = "ttt_mark_pct_marked", slider = true, min = 0, max = 1, decimal = 2, desc = "ttt_mark_pct_marked (def. 0.75)"})
	table.insert(tbl[ROLE_MARKER], {cvar = "ttt_mark_fixed_mark_amount", slider = true, min = -1, max = 25, decimal = 0, desc = "ttt_mark_fixed_mark_amount (def. -1)"})
	table.insert(tbl[ROLE_MARKER], {cvar = "ttt_mark_defi_factor", slider = true, min = 0, max = 1, decimal = 2, desc = "ttt_mark_defi_factor (def. 0.34)"})
	table.insert(tbl[ROLE_MARKER], {cvar = "ttt_mark_defi_revive_time", slider = true, min = 0, max = 30, decimal = 1, desc = "ttt_mark_defi_revive_time (def. 1.0)"})
	table.insert(tbl[ROLE_MARKER], {cvar = "ttt_mark_defi_error_time", slider = true, min = 0, max = 30, decimal = 1, desc = "ttt_mark_defi_error_time (def. 1.0)"})
end)
