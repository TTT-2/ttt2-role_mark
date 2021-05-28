if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_mark")
end

ROLE.Base = "ttt_role_base"

roles.InitCustomTeam(ROLE.name, {
	icon = "vgui/ttt/dynamic/roles/icon_mark",
	color = Color(125, 70, 135, 255)
})

function ROLE:PreInitialize()
	self.color = Color(125, 70, 135, 255)

	self.abbr = "mark"
	self.score.surviveBonusMultiplier = 0
	self.score.timelimitMultiplier = 0
	self.score.killsMultiplier = 0
	self.score.teamKillsMultiplier = 0
	self.score.bodyFoundMuliplier = 0
	self.score.aliveTeammatesBonusMultiplier = 0
	self.preventFindCredits = true
	self.preventKillCredits = true
	self.preventTraitorAloneCredits = true
	self.preventWin = true

	self.defaultTeam = TEAM_MARKER

	self.conVarData = {
		pct = 0.15,
		maximum = 1,
		minPlayers = 7,
		credits = 0,
		shopFallback = SHOP_DISABLED,
		togglable = true,
		random = 33
	}
end

if CLIENT then
	hook.Add("TTTBodySearchPopulate", "ttt2_role_marker_add_marked_indicator", function(search, raw)
		if not raw.owner then return end
		if not raw.owner.was_marked then return end

		local highest_id = 0
		for _, v in pairs(search) do
			highest_id = math.max(highest_id, v.p)
		end

		search.was_marked = {img = "vgui/ttt/player_marked.png", text = LANG.GetTranslation("ttt_marker_was_marked"), p = highest_id + 1}
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
			-- make sure it is a player corpse and not a random map ragdoll
			if not c.player_ragdoll then continue end

			local pos = c:LocalToWorld(c:OBBCenter())

			pos.x = math.Round(pos.x)
			pos.y = math.Round(pos.y)
			pos.z = math.Round(pos.z)

			targets[#targets + 1] = {subrole = -1, pos = pos}
		end

		-- get players alive
		for _, p in ipairs(player.GetAll()) do
			if IsValid(p) and ply ~= p and p:GetTeam() ~= TEAM_MARKER and (p:IsPlayer() and p:IsTerror() and not p:GetNWBool("disguised", false) or not p:IsPlayer()) then
				local pos = p:LocalToWorld(p:OBBCenter())

				-- Round off, easier to send and inaccuracy does not matter
				pos.x = math.Round(pos.x)
				pos.y = math.Round(pos.y)
				pos.z = math.Round(pos.z)

				local subrole, team

				if MARKER_DATA:IsMarked(p) then
					subrole = ROLE_MARKER
					team = TEAM_MARKER
				else
					subrole = ROLE_INNOCENT
					team = TEAM_INNOCENT
				end

				targets[#targets + 1] = {subrole = subrole, team = team, pos = pos}
			end
		end

		-- get decoys
		local decoys = ents.FindByClass("ttt_decoy")
		for _, decoy in ipairs(decoys) do
			local pos = decoy:LocalToWorld(decoy:OBBCenter())

			-- Round off, easier to send and inaccuracy does not matter
			pos.x = math.Round(pos.x)
			pos.y = math.Round(pos.y)
			pos.z = math.Round(pos.z)

			targets[#targets + 1] = {subrole = ROLE_INNOCENT, pos = pos}
		end

		return targets
	end

	ROLE.radarTime = 10

	-- modify roles table of rolesetup addon
	hook.Add("TTTAModifyRolesTable", "ModifyRoleMarkToInno", function(rls, printrls)
		printrls[ROLE_MARKER] = true

		local markers = rls[ROLE_MARKER]

		if not markers then return end

		rls[ROLE_INNOCENT] = rls[ROLE_INNOCENT] + markers
		rls[ROLE_MARKER] = 0
	end)

	local function InitRoleMarker(ply)
		ply:GiveEquipmentWeapon("weapon_ttt2_markergun")
		ply:GiveEquipmentWeapon("weapon_ttt2_markerdefi")
		ply:GiveArmor(60)
		ply:GiveEquipmentItem("item_ttt_radar")
	end

	local function DeinitRoleMarker(ply)
		ply:StripWeapon("weapon_ttt2_markergun")
		ply:StripWeapon("weapon_ttt2_markerdefi")
		ply:RemoveArmor(60)
		ply:RemoveEquipmentItem("item_ttt_radar")
	end

	function ROLE:GiveRoleLoadout(ply, isRoleChange)
		InitRoleMarker(ply)
	end

	function ROLE:RemoveRoleLoadout(ply, isRoleChange)
		DeinitRoleMarker(ply)

		-- remove markings when no marker is alive
		MARKER_DATA:MarkerDied()
	end

	hook.Add("TTTCheckForWin", "TTT2MarkerCheckWin", function()
		if not MARKER_DATA:AbleToWin() then return end

		if MARKER_DATA:GetMarkedAmount() >= MARKER_DATA:AmountToWin() then
			if MARKER_DATA:AmountNoMarkerAlive() == 0 or MARKER_DATA:GetMarkedAmount() == 0 then return end

			return TEAM_MARKER
		end
	end)

	hook.Add("EntityTakeDamage", "TTT2MarkerDealNoDamage", function(ply, dmginfo)
		if SpecDM and (ply.IsGhost and ply:IsGhost()) then return end

		if not ply:IsPlayer() then return end

		if not GetConVar("ttt_mark_deal_no_damage"):GetBool() then return end

		if not ply or not IsValid(ply) or not ply:IsPlayer() then return end

		local attacker = dmginfo:GetAttacker()

		if not attacker or not IsValid(attacker) or not attacker:IsPlayer() then return end

		if attacker:GetTeam() ~= TEAM_MARKER or attacker == ply then return end

		local dmg_scale = GetConVar("ttt_mark_hurt_marked_factor"):GetFloat()

		if dmg_scale > 0 then
			dmginfo:ScaleDamage(dmg_scale)
		else
			dmginfo:ScaleDamage(0)
			dmginfo:SetDamage(0)
		end
	end)

	hook.Add("EntityTakeDamage", "TTT2MarkerTakeNoDamage", function(ply, dmginfo)
		if not ply:IsPlayer() then return end

		if not GetConVar("ttt_mark_take_no_damage"):GetBool() then return end

		if not ply or not IsValid(ply) or not ply:IsPlayer() then return end

		local attacker = dmginfo:GetAttacker()

		if not attacker or not IsValid(attacker) or not attacker:IsPlayer() then return end

		if ply:GetTeam() == TEAM_MARKER and attacker ~= ply and MARKER_DATA:IsMarked(attacker) then
			dmginfo:ScaleDamage(0)
			dmginfo:SetDamage(0)
		end
	end)
end
