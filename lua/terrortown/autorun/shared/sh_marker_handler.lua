MARKER_DATA = {}
MARKER_DATA.marked_players = {}
MARKER_DATA.amount_marked = 0
MARKER_DATA.amount_marker_alive = 0
MARKER_DATA.amount_no_marker_alive = 0
MARKER_DATA.able_to_win = true
MARKER_DATA.amount_to_win = 0

if CLIENT then
	net.Receive("ttt2_role_marker_new_marking", function()
		local marked_player = net.ReadEntity()
		if not marked_player or not marked_player:IsPlayer() then return end

		local marked_player_id = tostring(marked_player:SteamID64() or marked_player:EntIndex())

		if LocalPlayer():GetTeam() ~= TEAM_MARKER then return end

		if not MARKER_DATA.marked_players[marked_player_id] then
			if GetConVar("ttt_mark_show_messages"):GetBool() then MSTACK:AddMessage(LANG.GetTranslation("ttt_marker_marked")) end
			MARKER_DATA.marked_players[marked_player_id] = true
			MARKER_DATA:Count()
		end
	end)

	net.Receive("ttt2_role_marker_remove_marking", function()
		local marked_player = net.ReadEntity()
		if not marked_player or not marked_player:IsPlayer() then return end

		local marked_player_id = tostring(marked_player:SteamID64() or marked_player:EntIndex())

		if LocalPlayer():GetTeam() ~= TEAM_MARKER then return end

		if MARKER_DATA.marked_players[marked_player_id] then
			if GetConVar("ttt_mark_show_messages"):GetBool() then MSTACK:AddMessage(LANG.GetTranslation("ttt_marker_died")) end
			MARKER_DATA.marked_players[marked_player_id] = nil
			MARKER_DATA:Count()
		end
	end)

	net.Receive("ttt2_role_marker_remove_all", function()
		MARKER_DATA:ClearMarkedPlayers()
	end)

	net.Receive("ttt2_role_marker_update", function()
		MARKER_DATA.nmarker_alive = net.ReadUInt(16)
		MARKER_DATA.amount_no_marker_alive = net.ReadUInt(16)
		MARKER_DATA.able_to_win = net.ReadBool()
		MARKER_DATA.amount_to_win = net.ReadUInt(16)
	end)

	net.Receive("ttt2_role_marker_scoreboard", function()
		MARKER_DATA:UpdateScoreboard()
	end)

	net.Receive("ttt2_role_marker_corpse_update", function()
		local ply = net.ReadEntity()

		if not ply or not ply:IsPlayer() then return end

		ply.was_marked = net.ReadBool()
	end)

	hook.Add("TTTScoreboardColumns", "ttt2_marked_players_column", function(pnl)
		local client = LocalPlayer()

		-- this prevention is needed when a player connects in the moment that a round starts
		if not client or not IsValid(client) or not client:IsPlayer() then return end

		if client:GetTeam() ~= TEAM_MARKER then return end
		pnl:AddColumn("Marked", function(ply, label)
			if MARKER_DATA:IsMarked(ply) then
				return "yes"
			else
				return "-"
			end
		end, 65)
	end)

	-- the marked column should only be visible when you're in the marker team
	function MARKER_DATA:UpdateScoreboard()
		GAMEMODE:ScoreboardCreate()
		GAMEMODE:ScoreboardHide()
	end
end

if SERVER then
	util.AddNetworkString("ttt2_role_marker_new_marking")
	util.AddNetworkString("ttt2_role_marker_remove_marking")
	util.AddNetworkString("ttt2_role_marker_remove_all")
	util.AddNetworkString("ttt2_role_marker_update")
	util.AddNetworkString("ttt2_role_marker_scoreboard")
	util.AddNetworkString("ttt2_role_marker_corpse_update")

	function MARKER_DATA:SetMarkedPlayer(marker, markee, isRevival)
		if not IsValid(markee) or not markee:IsPlayer() then return end

		-- show player that they are marked
		if GetConVar("ttt_mark_show_sidebar"):GetBool() then
			self:MarkPlayer(markee)
		end

		MARKER_DATA.marked_players[tostring(markee:SteamID64() or markee:EntIndex())] = true

		net.Start("ttt2_role_marker_new_marking")
		net.WriteEntity(markee)
		net.Broadcast() -- send to all players, only markers will handle the data

		self:Count()

		events.Trigger(EVENT_MARKED, marker, markee, isRevival)
	end

	function MARKER_DATA:PrepareCorpseOnDeath(ply)
		if not ply or not ply:IsPlayer() then return end
		if not self:IsMarked(ply) then return end

		net.Start("ttt2_role_marker_corpse_update")
		net.WriteEntity(ply)
		net.WriteBool(true)
		net.Broadcast()
	end

	function MARKER_DATA:ResetCorpseOnSpawn(ply)
		if not ply or not ply:IsPlayer() then return end

		net.Start("ttt2_role_marker_corpse_update")
		net.WriteEntity(ply)
		net.WriteBool(false)
		net.Broadcast()
	end

	function MARKER_DATA:RemoveMarkedPlayer(ply)
		if not ply or not ply:IsPlayer() then return end

		MARKER_DATA.marked_players[tostring(ply:SteamID64() or ply:EntIndex())] = nil

		net.Start("ttt2_role_marker_remove_marking")
		net.WriteEntity(ply)
		net.Broadcast() -- send to all players, only markers will handle the data

		self:Count()
	end

	function MARKER_DATA:MarkPlayer(ply)
		STATUS:AddStatus(ply, "ttt2_role_marker_marked")
	end

	function MARKER_DATA:UnmarkPlayers()
		STATUS:RemoveStatus(player.GetAll(), "ttt2_role_marker_marked")

		-- clear on server
		MARKER_DATA:ClearMarkedPlayers()

		-- clear on client
		net.Start("ttt2_role_marker_remove_all")
		net.Broadcast() -- send to all players, only markers will handle the data
	end

	function MARKER_DATA:UpdateAfterChange()
		-- player alive
		local player_alive, amnt_marker = 0, 0
		for _, p in ipairs(player.GetAll()) do
			if p:Alive() and p:IsTerror() then
				player_alive = player_alive + 1
			end
			if p:Alive() and p:IsTerror() and p:GetTeam() == TEAM_MARKER then
				amnt_marker = amnt_marker + 1
			end
		end
		self.amount_marker_alive = amnt_marker
		self.amount_no_marker_alive = player_alive - amnt_marker


		-- amount to win
		if GetConVar("ttt_mark_fixed_mark_amount"):GetInt() == -1 then
			self.amount_to_win = math.ceil(GetConVar("ttt_mark_pct_marked"):GetFloat() * self:AmountNoMarkerAlive())
			self.amount_to_win = math.max(self.amount_to_win, GetConVar("ttt_mark_min_alive"):GetInt())
			self.amount_to_win = math.min(self.amount_to_win, GetConVar("ttt_mark_max_to_mark"):GetInt())
		else
			self.amount_to_win = GetConVar("ttt_mark_fixed_mark_amount"):GetInt()
		end

		-- able to win (over max threshold, should be overwritten by fixed amount)
		self.able_to_win = self:AmountNoMarkerAlive() >= math.min(GetConVar("ttt_mark_min_alive"):GetInt(), self.amount_to_win)

		-- sync to client
		net.Start("ttt2_role_marker_update")
		net.WriteUInt(self.amount_marker_alive, 16)
		net.WriteUInt(self.amount_no_marker_alive, 16)
		net.WriteBool(self.able_to_win)
		net.WriteUInt(self.amount_to_win, 16)
		net.Broadcast() -- send to all players, only markers will handle the data
	end

	function MARKER_DATA:MarkerDied()
		if MARKER_DATA:IsMarkerAlive() then return end
		MARKER_DATA:UnmarkPlayers()
	end

	function MARKER_DATA:UpdateScoreboard()
		-- needs a short time so that the marker has received his role
		timer.Simple(0.1, function()
			net.Start("ttt2_role_marker_scoreboard")
			net.Broadcast()
		end)
	end

	hook.Add("PostPlayerDeath", "ttt2_role_marker_death", function(victim, infl, attacker)
		-- HANDLE DEATH OF MARKED PLAYER
		MARKER_DATA:PrepareCorpseOnDeath(victim)
		MARKER_DATA:RemoveMarkedPlayer(victim)
		MARKER_DATA:UpdateAfterChange()

		-- HANDLE DEATH OF MARKER
		if victim:GetTeam() ~= TEAM_MARKER then return end
		MARKER_DATA:MarkerDied()
	end)

	hook.Add("PlayerSpawn", "ttt2_role_marker_player_respawn", function(ply)
		MARKER_DATA:ResetCorpseOnSpawn(ply)
		MARKER_DATA:UpdateAfterChange()
	end)

	hook.Add("TTT2UpdateSubrole", "ttt2_role_marker_update_subrole", function()
		MARKER_DATA:UpdateAfterChange()
	end)

	hook.Add("TTTEndRound", "ttt2_role_marker_round_end", function()
		MARKER_DATA:UpdateScoreboard()
	end)

	hook.Add("TTT2UpdateSubrole", "ttt2_role_marker_role_change", function(ply, old, new)
		if new ~= ROLE_MARKER and old ~= ROLE_MARKER then return end
		MARKER_DATA:UpdateScoreboard()
	end)

	-- handle marker-pirate interaction
	hook.Add("TTT2UpdateTeam", "ttt2_role_marker_team_change", function(ply, old, new)
		if ply:GetSubRole() ~= ROLE_PIRATE and ply:GetSubRole() ~= ROLE_PIRATE_CAPTAIN then return end
		-- give/remove equipment when a pirate joins/leaves the marker team
		if new ~= TEAM_MARKER and old == TEAM_MARKER then
			ply:StripWeapon("weapon_ttt2_markergun")
		elseif new == TEAM_MARKER and old ~= TEAM_MARKER then
			ply:GiveEquipmentWeapon("weapon_ttt2_markergun")
		end

		-- remove marking of pirate
		MARKER_DATA:RemoveMarkedPlayer(ply)
		STATUS:RemoveStatus(ply, "ttt2_role_marker_marked")

		-- recount marker team
		MARKER_DATA:UpdateAfterChange()

		-- recheck if markers could still win since pirate team change gets triggered after marker died
		MARKER_DATA:MarkerDied()

		-- update scoreboard
		MARKER_DATA:UpdateScoreboard()
	end)
end

function MARKER_DATA:Count()
	local marked_amount = 0
	for i,_ in pairs(MARKER_DATA.marked_players) do
		marked_amount = marked_amount + 1
	end
	self.amount_marked = marked_amount
end

function MARKER_DATA:ClearMarkedPlayers()
	self.marked_players = {}
	self.amount_marked = 0
	self.amount_marker_alive = 0
	self.amount_no_marker_alive = 0
	self.able_to_win = true
	self.amount_to_win = 0
end

function MARKER_DATA:AmountNoMarkerAlive()
	return self.amount_no_marker_alive
end

function MARKER_DATA:AmountMarkerAlive()
	return self.amount_marker_alive
end

function MARKER_DATA:IsMarkerAlive()
	return self:AmountMarkerAlive() > 0
end

function MARKER_DATA:GetMarkedAmount()
	return self.amount_marked
end

function MARKER_DATA:AbleToWin()
	return self.able_to_win
end

function MARKER_DATA:AmountToWin()
	return self.amount_to_win
end

function MARKER_DATA:IsMarked(ply)
	local steamid = tostring(ply:SteamID64() or ply:EntIndex())

	return MARKER_DATA.marked_players[steamid] or false
end

hook.Add("TTTBeginRound", "ttt2_role_marker_reset", function()
	MARKER_DATA:ClearMarkedPlayers()

	if SERVER then
		MARKER_DATA:UpdateAfterChange()
	end
end)
