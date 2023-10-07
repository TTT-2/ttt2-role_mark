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
CreateConVar("ttt_mark_hurt_marked_factor", 0, {FCVAR_NOTIFY, FCVAR_ARCHIVE})

if SERVER then
	-- ConVar replication is broken in GMod, so we do this, at least Alf added a hook!
	-- I don't like it any more than you do, dear reader. Copycat!
	hook.Add("TTT2SyncGlobals", "ttt2_marker_sync_convars", function()
		SetGlobalBool("ttt_mark_deal_no_damage", GetConVar("ttt_mark_deal_no_damage"):GetBool())
		SetGlobalBool("ttt_mark_take_no_damage", GetConVar("ttt_mark_take_no_damage"):GetBool())
		SetGlobalBool("ttt_mark_hurt_marked", GetConVar("ttt_mark_hurt_marked_factor"):GetFloat() > 0)
	end)

	-- sync convars on change
	cvars.AddChangeCallback("ttt_mark_deal_no_damage", function(cv, old, new)
		SetGlobalBool("ttt_mark_deal_no_damage", tobool(tonumber(new)))
	end)

	cvars.AddChangeCallback("ttt_mark_take_no_damage", function(cv, old, new)
		SetGlobalBool("ttt_mark_take_no_damage", tobool(tonumber(new)))
	end)

	cvars.AddChangeCallback("ttt_mark_hurt_marked_factor", function(cv, old, new)
		SetGlobalBool("ttt_mark_hurt_marked", tonumber(new) > 0)
	end)
end
