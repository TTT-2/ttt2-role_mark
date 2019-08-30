if SERVER then
	AddCSLuaFile()

	resource.AddFile('materials/vgui/ttt/dynamic/roles/icon_mark.vmt')
end

ROLE.Base = 'ttt_role_base'

ROLE.color = Color(125, 70, 135, 255) -- ...
ROLE.dkcolor = Color(90, 45, 100, 255) -- ...
ROLE.bgcolor = Color(160, 115, 165, 255) -- ...
ROLE.abbr = 'mark' -- abbreviation
ROLE.surviveBonus = 0 -- bonus multiplier for every survive while another player was killed
ROLE.scoreKillsMultiplier = 1 -- multiplier for kill of player of another team
ROLE.scoreTeamKillsMultiplier = -16 -- multiplier for teamkill
ROLE.preventFindCredits = true
ROLE.preventKillCredits = true
ROLE.preventTraitorAloneCredits = true
ROLE.preventWin = true

roles.InitCustomTeam(ROLE.name, {
    icon = 'vgui/ttt/dynamic/roles/icon_mark',
    color = ROLE.color
})
ROLE.defaultTeam = TEAM_MARKER

ROLE.conVarData = {
	pct = 0.15, -- necessary: percentage of getting this role selected (per player)
	maximum = 1, -- maximum amount of roles in a round
	minPlayers = 7, -- minimum amount of players until this role is able to get selected
	credits = 0, -- the starting credits of a specific role
	shopFallback = SHOP_DISABLED,
	togglable = true, -- option to toggle a role for a client if possible (F1 menu)
	random = 33
}

hook.Add('TTT2FinishedLoading', 'MarkInitT', function()

	if CLIENT then
		LANG.AddToLanguage('English', MARKER.name, 'Marker')
		LANG.AddToLanguage('English', TEAM_MARKER, 'TEAM marker')
		LANG.AddToLanguage('English', 'info_popup_' .. MARKER.name,
			[[You are the Marker!
			Try to mark all players! It's hard, but don't wait until only a few players are left...]])
		LANG.AddToLanguage('English', 'body_found_' .. MARKER.abbr, 'They were a Marker.')
		LANG.AddToLanguage('English', 'search_role_' .. MARKER.abbr, 'This person was a marker!')
		LANG.AddToLanguage('English', 'target_' .. MARKER.name, 'Marker')
		LANG.AddToLanguage('English', 'ttt2_desc_' .. MARKER.name, [[The Marker needs to win alone!]])
		LANG.AddToLanguage('English', 'hilite_win_' .. TEAM_MARKER, 'THE MARKER WON') -- name of base role of a team
		LANG.AddToLanguage('English', 'win_' .. TEAM_MARKER, 'The Marker has won!') -- teamname
		LANG.AddToLanguage('English', 'ev_win_' .. TEAM_MARKER, 'The evil Marker won the round!')
		LANG.AddToLanguage('English', 'credit_' .. MARKER.abbr .. '_all', 'Markers, you have been awarded {num} equipment credit(s) for your performance.')

		---------------------------------

		-- maybe this language as well...
		LANG.AddToLanguage('Deutsch', MARKER.name, 'Markierer')
		LANG.AddToLanguage('Deutsch', TEAM_MARKER, 'TEAM Markierer')
		LANG.AddToLanguage('Deutsch', 'info_popup_' .. MARKER.name,
			[[Du bist ein Markierer!
			Versuche alle anderen spieler zu markieren! Aber warte nicht so lange bis nur noch ein paar Spieler übrig sind...]])
		LANG.AddToLanguage('Deutsch', 'body_found_' .. MARKER.abbr, 'Er war ein Markierer...')
		LANG.AddToLanguage('Deutsch', 'search_role_' .. MARKER.abbr, 'Diese Person war ein Markierer!')
		LANG.AddToLanguage('Deutsch', 'target_' .. MARKER.name, 'Markierer')
		LANG.AddToLanguage('Deutsch', 'ttt2_desc_' .. MARKER.name, [[Der Markierer muss alleine gewinnen!]])
		LANG.AddToLanguage('Deutsch', 'hilite_win_' .. TEAM_MARKER, 'THE MARKER WON') -- name of base role of a team
		LANG.AddToLanguage('Deutsch', 'win_' .. TEAM_MARKER, 'Der Marker hat gewonnen!') -- teamname
		LANG.AddToLanguage('Deutsch', 'ev_win_' .. TEAM_MARKER, 'Der böse Marker hat die Runde gewonnen!')
		LANG.AddToLanguage('Deutsch', 'credit_' .. MARKER.abbr .. '_all', 'Marker, dir wurde(n) {num} Ausrüstungs-Credit(s) für deine Leistung gegeben.')
	end
end) 

if SERVER then
	-- modify roles table of rolesetup addon
	hook.Add('TTTAModifyRolesTable', 'ModifyRoleMarkToInno', function(rls, printrls)
		printrls[ROLE_MARKER] = true

		local markers = rls[ROLE_MARKER]

		if not markers then return end

		rls[ROLE_INNOCENT] = rls[ROLE_INNOCENT] + markers
		rls[ROLE_MARKER] = 0
	end)

	local function InitRoleMarker(ply)
		ply:GiveEquipmentWeapon('weapon_ttt2_markergun')
		ply:GiveEquipmentWeapon('weapon_ttt2_markerdefi')
		ply:GiveEquipmentItem('item_ttt_armor')
		ply:GiveEquipmentItem('item_ttt_radar')
    end
 
    hook.Add('TTT2UpdateSubrole', 'TTT2MarkerGivePaintGun_UpdateSubtole', function(ply, old, new) -- called on normal role set
        if new == ROLE_MARKER then
            InitRoleMarker(ply)
        elseif old == ROLE_MARKER then
            ply:StripWeapon('weapon_ttt2_markergun')
            ply:StripWeapon('weapon_ttt2_markerdefi')
 
            -- remove markings when no marker is alive
            MARKER_DATA:MarkerDied()
        end
    end)
   
	hook.Add('PlayerSpawn', 'TTT2MarkerGivePaintGun_PlayerSpawn', function(ply) -- called on player respawn
		timer.Simple(0.5, function()
			if ply:GetSubRole() ~= ROLE_MARKER then return end
			InitRoleMarker(ply)
		end)
    end)

	hook.Add('TTTCheckForWin', 'TTT2MarkerCheckWin', function()
		if not MARKER_DATA:AbleToWin() then return end

		if MARKER_DATA:GetMarkedAmount() >= MARKER_DATA:AmountToWin() then
			if MARKER_DATA:AmountNoMarkerAlive() == 0 or MARKER_DATA:GetMarkedAmount() == 0 then return end
			return TEAM_MARKER
		end
	end)

	hook.Add('EntityTakeDamage', 'TTT2MarkerDealNoDamage', function(ply, dmginfo)
		if not ply:IsPlayer() then return end

		if not GetConVar('ttt_mark_deal_no_damage'):GetBool() then return end

		if not ply or not IsValid(ply) or not ply:IsPlayer() then return end

		local attacker = dmginfo:GetAttacker()

		if not attacker or not IsValid(attacker) or not attacker:IsPlayer() then return end

		if attacker:GetTeam() == TEAM_MARKER and attacker ~= ply then
			dmginfo:ScaleDamage(0)
			dmginfo:SetDamage(0)
		end
	end)

	hook.Add('EntityTakeDamage', 'TTT2MarkerTakeNoDamage', function(ply, dmginfo)
		if not ply:IsPlayer() then return end

		if not GetConVar('ttt_mark_take_no_damage'):GetBool() then return true end

		if not ply or not IsValid(ply) or not ply:IsPlayer() then return end

		local attacker = dmginfo:GetAttacker()

		if not attacker or not IsValid(attacker) or not attacker:IsPlayer() then return end

		if ply:GetTeam() == TEAM_MARKER and attacker ~= ply and MARKER_DATA:IsMarked(attacker) then
			dmginfo:ScaleDamage(0)
			dmginfo:SetDamage(0)
		end		
	end)
end