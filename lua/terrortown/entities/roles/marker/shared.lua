if SERVER then
	AddCSLuaFile()

	resource.AddFile('materials/vgui/ttt/dynamic/roles/icon_mark.vmt')
end

ROLE.Base = 'ttt_role_base'

roles.InitCustomTeam(ROLE.name, {
	icon = 'vgui/ttt/dynamic/roles/icon_mark',
	color = Color(125, 70, 135, 255)
})

function ROLE:PreInitialize()
	self.color = Color(125, 70, 135, 255)
	self.dkcolor = Color(90, 45, 100, 255)
	self.bgcolor = Color(160, 115, 165, 255)
	self.radarColor = Color(160, 115, 165, 255)

	self.abbr = 'mark'
	self.surviveBonus = 0
	self.scoreKillsMultiplier = 1
	self.scoreTeamKillsMultiplier = -16
	self.preventFindCredits = true
	self.preventKillCredits = true
	self.preventTraitorAloneCredits = true
	self.preventWin = true

	self.defaultTeam = TEAM_MARKER

	self.conVarData = {
		pct = 0.15, -- necessary: percentage of getting this role selected (per player)
		maximum = 1, -- maximum amount of roles in a round
		minPlayers = 7, -- minimum amount of players until this role is able to get selected
		credits = 0, -- the starting credits of a specific role
		shopFallback = SHOP_DISABLED,
		togglable = true, -- option to toggle a role for a client if possible (F1 menu)
		random = 33
	}
end

function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_MARKER)

	if CLIENT then
		-- Role specific language elements
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

		-- other role language elements
		LANG.AddToLanguage("English", "ttt2_marker_was_marked", "This player seems to be covered in color. They were marked!")
		LANG.AddToLanguage("Deutsch", "ttt2_marker_was_marked", "Dieser Spieler scheint mit Farbe übergossen zu sein. Er wurde markiert!")
	end
end

if CLIENT then
	hook.Add("TTTBodySearchPopulate", "ttt2_role_marker_add_marked_indicator", function(search, raw)
		if not raw.owner then return end
		if not raw.owner.was_marked then return end

		local highest_id = 0
		for _, v in pairs(search) do
			highest_id = math.max(highest_id, v.p)
		end

		search.was_marked = {img = "vgui/ttt/player_marked.png", text = LANG.GetTranslation("ttt2_marker_was_marked"), p = highest_id + 1}
	end)
end

if SERVER then
	-- giving the marker a custom radar, it does not show other players in the marker team
	-- the radar has three modes:
	-- - marked players (rolecolor)
	-- - dead players (gray)
	-- - unmarked players (default radar color)
	ROLE.CustomRadar = function(ply)
		local targets = {}

		-- get corpses
		local corpses = ents.FindByClass("prop_ragdoll")

		for _, c in ipairs(corpses) do
			local pos = c:LocalToWorld(c:OBBCenter())

			pos.x = math.Round(pos.x)
			pos.y = math.Round(pos.y)
			pos.z = math.Round(pos.z)

			table.insert(targets, {subrole = -1, pos = pos})
		end

		-- get players alive
		for _, p in ipairs(player.GetAll()) do
			if IsValid(p) and ply ~= p and p:GetTeam() ~= TEAM_MARKER and (p:IsPlayer() and p:IsTerror() and not p:GetNWBool("disguised", false) or not p:IsPlayer()) then
				local pos = p:LocalToWorld(p:OBBCenter())

				-- Round off, easier to send and inaccuracy does not matter
				pos.x = math.Round(pos.x)
				pos.y = math.Round(pos.y)
				pos.z = math.Round(pos.z)

				local subrole

				if MARKER_DATA:IsMarked(p) then
					subrole = ROLE_MARKER
				else
					subrole = ROLE_INNOCENT
				end

				table.insert(targets, {subrole = subrole, pos = pos})
			end
		end

		return targets
	end

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
		ply:GiveArmor(60)
		ply:GiveEquipmentItem('item_ttt_radar')
	end
	
	local function DeinitRoleMarker(ply)
		ply:StripWeapon('weapon_ttt2_markergun')
		ply:StripWeapon('weapon_ttt2_markerdefi')
		ply:RemoveArmor(60)
		ply:RemoveEquipmentItem('item_ttt_radar')
	end
	
	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		InitRoleMarker(ply)
	end

	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		DeinitRoleMarker(ply)
 
		-- remove markings when no marker is alive
		MARKER_DATA:MarkerDied()
	end
 
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

		if not GetConVar('ttt_mark_take_no_damage'):GetBool() then return end

		if not ply or not IsValid(ply) or not ply:IsPlayer() then return end

		local attacker = dmginfo:GetAttacker()

		if not attacker or not IsValid(attacker) or not attacker:IsPlayer() then return end

		if ply:GetTeam() == TEAM_MARKER and attacker ~= ply and MARKER_DATA:IsMarked(attacker) then
			dmginfo:ScaleDamage(0)
			dmginfo:SetDamage(0)
		end		
	end)
end