if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/gui/ttt/icon_defi_marker.vmt")
end

local DEFI_IDLE = 0
local DEFI_BUSY = 1
local DEFI_CHARGE = 2

local DEFI_ERROR_NO_SPACE = 1
local DEFI_ERROR_TOO_FAST = 2
local DEFI_ERROR_LOST_TARGET = 3
local DEFI_ERROR_NO_VALID_PLY = 4
local DEFI_ERROR_ALREADY_REVIVING = 5
local DEFI_ERROR_FAILED = 6

local sounds = {
	empty = Sound("Weapon_SMG1.Empty"),
	beep = Sound("buttons/button17.wav"),
	hum = Sound("items/nvg_on.wav"),
	zap = Sound("ambient/energy/zap7.wav"),
	revived = Sound("items/smallmedkit1.wav")
}

SWEP.Base = "weapon_tttbase"

if CLIENT then
	SWEP.ViewModelFOV = 78
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFlip = false

	SWEP.EquipMenuData = {
		type = "item_weapon",
		name = "weapon_markerdefi_name",
		desc = "weapon_markerdefi_desc"
	}

	SWEP.Icon = "vgui/ttt/icon_defi_marker"
end

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = nil

SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/v_c4.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"

SWEP.AutoSpawnable = false
SWEP.NoSights = true

SWEP.HoldType = "pistol"
SWEP.LimitedStock = true

SWEP.Primary.Recoil = 0
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 1
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Recoil = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Delay = 0.5

SWEP.Charge = 0
SWEP.Timer = -1

SWEP.AllowDrop = false

if SERVER then
	util.AddNetworkString("RequestMarkerRevivalStatus")
	util.AddNetworkString("ReceiveMarkerRevivalStatus")

	function SWEP:Initialize()
		local ammo = math.max(1, MARKER_DATA:AmountToWin() * GetConVar("ttt_mark_defi_factor"):GetFloat())

		self:SetClip1(ammo)
	end

	function SWEP:OnDrop()
		self.BaseClass.OnDrop(self)

		self:CancelRevival()
		self:Remove()
	end

	function SWEP:SetState(state)
		self:SetNWInt("defi_state", state or DEFI_IDLE)
	end

	function SWEP:Reset()
		self:SetState(DEFI_IDLE)

		self.defiTarget = nil
		self.defiBone = nil
		self.defiStart = 0

		self.defiTimer = nil
	end

	function SWEP:Error(type)
		self:SetState(DEFI_CHARGE)
		self:StopSound("hum")
		self:PlaySound("beep")

		self.defiTarget = nil
		self.defiTimer = "defi_reset_timer_" .. self:EntIndex()

		if timer.Exists(self.defiTimer) then return end

		timer.Create(self.defiTimer, GetConVar("ttt_mark_defi_error_time"):GetFloat(), 1, function()
			if not IsValid(self) then return end

			self:Reset()
		end)

		self:Message(type)
	end

	function SWEP:Message(type)
		local owner = self:GetOwner()

		if type == DEFI_ERROR_NO_SPACE then
			LANG.Msg(owner, "markerdefi_error_no_space", nil, MSG_MSTACK_WARN)
		elseif type == DEFI_ERROR_TOO_FAST then
			LANG.Msg(owner, "markerdefi_error_too_fast", nil, MSG_MSTACK_WARN)
		elseif type == DEFI_ERROR_LOST_TARGET then
			LANG.Msg(owner, "markerdefi_error_lost_target", nil, MSG_MSTACK_WARN)
		elseif type == DEFI_ERROR_NO_VALID_PLY then
			LANG.Msg(owner, "markerdefi_error_no_valid_ply", nil, MSG_MSTACK_WARN)
		elseif type == DEFI_ERROR_ALREADY_REVIVING then
			LANG.Msg(owner, "markerdefi_error_already_reviving", nil, MSG_MSTACK_WARN)
		elseif type == DEFI_ERROR_FAILED then
			LANG.Msg(owner, "markerdefi_error_failed", nil, MSG_MSTACK_WARN)
		end
	end

	function SWEP:BeginRevival(ragdoll, bone)
		local ply = CORPSE.GetPlayer(ragdoll)
		local owner = self:GetOwner()

		if not IsValid(ply) then
			self:Error(DEFI_ERROR_NO_VALID_PLY)

			return
		end

		if ply:IsReviving() then
			self:Error(DEFI_ERROR_ALREADY_REVIVING)

			return
		end

		local reviveTime = GetConVar("ttt_mark_defi_revive_time"):GetFloat()

		self:SetState(DEFI_BUSY)
		self:SetStartTime(CurTime())
		self:SetReviveTime(reviveTime)
		self:PlaySound("hum")

		-- start revival
		ply:Revive(
			reviveTime,
			function(p)
				-- mark revived player
				timer.Simple(0.1, function()
					MARKER_DATA:SetMarkedPlayer(owner, p, true)
				end)
			end,
			nil,
			true,
			true
		)
		ply:SendRevivalReason("revived_by_marker", {name = self:GetOwner():Nick()})

		self.defiTarget = ragdoll
		self.defiBone = bone
	end

	function SWEP:FinishRevival()
		self:Reset()

		self:SetClip1(self:Clip1() - 1)

		if self:Clip1() < 1 then
			self:Remove()

			RunConsoleCommand("lastinv")
		end
	end

	function SWEP:CancelRevival()
		local ply = CORPSE.GetPlayer(self.defiTarget)

		self:Reset()

		if not IsValid(ply) then return end

		ply:CancelRevival()
		ply:SendRevivalReason(nil)
	end

	function SWEP:StopSound(soundName)
		self:GetOwner():StopSound(sounds[soundName])
	end

	function SWEP:PlaySound(soundName)
		self:GetOwner():EmitSound(sounds[soundName])
	end

	function SWEP:SetStartTime(time)
		self:SetNWFloat("defi_start_time", time or 0)
	end

	function SWEP:SetReviveTime(time)
		self:SetNWFloat("defi_revive_time", time or 0)
	end

	function SWEP:Think()
		if self:GetState() ~= DEFI_BUSY then return end

		local owner = self:GetOwner()

		if CurTime() >= self:GetStartTime() + GetConVar("ttt_mark_defi_revive_time"):GetFloat() - 0.01 then
			self:FinishRevival()
		elseif not owner:KeyDown(IN_ATTACK) or owner:GetEyeTrace(MASK_SHOT_HULL).Entity ~= self.defiTarget then
			self:CancelRevival()
			self:Error(DEFI_ERROR_LOST_TARGET)
		end
	end

	function SWEP:PrimaryAttack()
		local owner = self:GetOwner()

		local trace = owner:GetEyeTrace(MASK_SHOT_HULL)
		local distance = trace.StartPos:Distance(trace.HitPos)
		local ent = trace.Entity

		if distance > 100 or not IsValid(ent)
			or ent:GetClass() ~= "prop_ragdoll"
			or not CORPSE.IsValidBody(ent)
		then
			self:PlaySound("empty")

			return
		end

		local spawnPoint = spawn.MakeSpawnPointSafe(CORPSE.GetPlayer(ent), ent:GetPos())

		if self:GetState() ~= DEFI_IDLE then
			self:Error(DEFI_ERROR_TOO_FAST)

			return
		end

		if not spawnPoint then
			self:Error(DEFI_ERROR_NO_SPACE)
		else
			self:BeginRevival(ent, trace.PhysicsBone)
		end
	end

	net.Receive("RequestMarkerRevivalStatus", function(_, requester)
		local ply = net.ReadEntity()

		if not IsValid(ply) then return end

		net.Start("ReceiveMarkerRevivalStatus")
		net.WriteEntity(ply)
		net.WriteBool(ply:IsReviving())
		net.Send(requester)
	end)
end

-- do not play sound when swep is empty
function SWEP:DryFire()
	return false
end

function SWEP:GetState()
	return self:GetNWInt("defi_state", DEFI_IDLE)
end

function SWEP:GetStartTime()
	return self:GetNWFloat("defi_start_time", 0)
end

function SWEP:GetReviveTime()
	return self:GetNWFloat("defi_revive_time", 0)
end

if CLIENT then
	function SWEP:PrimaryAttack()

	end

	local colorGreen = Color(36, 160, 30)

	local materialMarker = Material("vgui/ttt/dynamic/roles/icon_mark")

	local function IsPlayerReviving(ply)
		if not ply.defi_lastRequest or ply.defi_lastRequest < CurTime() + 0.3 then
			net.Start("RequestMarkerRevivalStatus")
			net.WriteEntity(ply)
			net.SendToServer()

			ply.defi_lastRequest = CurTime()
		end

		return ply.defi_isReviving or false
	end

	net.Receive("ReceiveMarkerRevivalStatus", function()
		local ply = net.ReadEntity()

		if not IsValid(ply) then return end

		ply.defi_isReviving = net.ReadBool()
	end)

	hook.Add("TTTRenderEntityInfo", "ttt2_markerdefibrillator_display_info", function(tData)
		local ent = tData:GetEntity()
		local client = LocalPlayer()
		local activeWeapon = client:GetActiveWeapon()

		-- has to be a ragdoll
		if ent:GetClass() ~= "prop_ragdoll" or not CORPSE.IsValidBody(ent) then return end

		-- player has to hold a defibrillator
		if not IsValid(activeWeapon) or activeWeapon:GetClass() ~= "weapon_ttt2_markerdefi" then return end

		-- ent has to be in usable range
		if tData:GetEntityDistance() > 100 then return end

		if activeWeapon:GetState() == DEFI_CHARGE then
			tData:AddDescriptionLine(
				LANG.TryTranslation("markerdefi_charging"),
				COLOR_ORANGE
			)

			tData:SetOutlineColor(COLOR_ORANGE)

			return
		end

		local ply = CORPSE.GetPlayer(ent)

		if activeWeapon:GetState() ~= DEFI_BUSY and IsValid(ply) and IsPlayerReviving(ply) then
			tData:AddDescriptionLine(
				LANG.TryTranslation("markerdefi_player_already_reviving"),
				COLOR_ORANGE
			)

			tData:SetOutlineColor(COLOR_ORANGE)

			return
		end

		tData:AddDescriptionLine(
			LANG.GetParamTranslation("markerdefi_hold_key_to_revive", {key = Key("+attack", "LEFT MOUSE")}),
			colorGreen,
			{materialMarker}
		)

		if activeWeapon:GetState() ~= DEFI_BUSY then return end

		local progress = math.min((CurTime() - activeWeapon:GetStartTime()) / activeWeapon:GetReviveTime(), 1.0)
		local timeLeft = activeWeapon:GetReviveTime() - (CurTime() - activeWeapon:GetStartTime())

		local x = 0.5 * ScrW()
		local y = 0.5 * ScrH()
		local w, h = 0.2 * ScrW(), 0.025 * ScrH()

		y = 0.95 * y

		surface.SetDrawColor(50, 50, 50, 220)
		surface.DrawRect(x - 0.5 * w, y - h, w, h)
		surface.SetDrawColor(clr(colorGreen))
		surface.DrawOutlinedRect(x - 0.5 * w, y - h, w, h)
		surface.SetDrawColor(clr(ColorAlpha(colorGreen, (0.5 + 0.15 * math.sin(CurTime() * 4)) * 255)))
		surface.DrawRect(x - 0.5 * w + 2, y - h + 2, w * progress - 4, h - 4)

		tData:AddDescriptionLine(
			LANG.GetParamTranslation("markerdefi_revive_progress", {time = math.Round(timeLeft, 1)}),
			colorGreen
		)

		tData:SetOutlineColor(colorGreen)
	end)
end
