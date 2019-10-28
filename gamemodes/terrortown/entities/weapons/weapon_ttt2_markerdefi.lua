--- Defib v2 (revision 20170303)

-- This code is copyright (c) 2016-2017 all rights reserved - 'Vadim' @ jmwparq@gmail.com
-- (Re)sale of this code and/or products containing part of this code is strictly prohibited
-- Exclusive rights to usage of this product in 'Trouble in Terrorist Town' are given to:
-- - The Garry's Mod community
-- Modified the mechanics to work as zombie reviving swep

if SERVER then
	AddCSLuaFile()
end

SWEP.HoldType = 'pistol'
SWEP.LimitedStock = true

if CLIENT then
	SWEP.PrintName = 'Marker\'s Defi'
	SWEP.Slot = 7

	SWEP.ViewModelFOV = 78
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFlip = false

	SWEP.EquipMenuData = {
		type = 'item_weapon',
		desc = 'ttt2_markerdefi_desc'
	}

    SWEP.Icon = 'vgui/ttt/marker_defi'
    
    hook.Add('Initialize', 'TTTInitMarkerDefiLang', function()
		LANG.AddToLanguage('English', 'ttt2_markerdefi_desc', 'Revives dead people as marked players. They keep their role.')
		LANG.AddToLanguage('Deutsch', 'ttt2_markerdefi_desc', 'Belebt tote Spieler als markierte Spieler wieder. Sie behalten ihre Rolle.')
	end)
end

SWEP.notBuyable = true

SWEP.Base = 'weapon_tttbase'

SWEP.Primary.Recoil = 0
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 1
SWEP.Primary.Ammo = 'none'

SWEP.Secondary.Recoil = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Delay = 1.25

SWEP.AllowDrop = false

SWEP.Charge = 0
SWEP.Timer = -1

-- settings
local maxdist = CreateConVar('ttt_defib_maxdist', '64', {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE})
local charge = CreateConVar('ttt_defib_chargetime', '3', {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE})
local mutateok = CreateConVar('ttt_defib_allowmutate', '1', {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE})
local mutatemax = CreateConVar('ttt_defib_mutatemaxscale', '2', {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE})
local spawnhealth = CreateConVar('ttt_defib_spawnhealth', '100', {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE})

local mutate = {
	['models/props_junk/watermelon01.mdl'] = true,
	['models/props/cs_italy/orange.mdl'] = true,
	['models/props/cs_italy/bananna.mdl'] = true,
	['models/props/cs_italy/bananna_bunch.mdl'] = true
}

-- content
resource.AddSingleFile('materials/vgui/ttt/marker_defi.vtf')
resource.AddSingleFile('materials/vgui/ttt/marker_defi.vmt')

local beep = Sound('buttons/button17.wav')
local hum = Sound('items/nvg_on.wav')
local zap = Sound('ambient/energy/zap7.wav')
local revived = Sound('items/smallmedkit1.wav')

SWEP.Kind = WEAPON_EQUIP2

hook.Add('TTT2RolesLoaded', 'TTT2MarkerDefi', function()
	local wep = weapons.GetStored('weapon_ttt2_markerdefi')
	if wep then
		wep.CanBuy = {ROLE_NECROMANCER}
	end
end)

SWEP.UseHands = true
SWEP.ViewModel = 'models/weapons/v_c4.mdl'
SWEP.WorldModel = 'models/weapons/w_c4.mdl'

SWEP.AutoSpawnable = false
SWEP.NoSights = true

local DEFIB_IDLE = 0
local DEFIB_BUSY = 1
local DEFIB_ERROR = 2

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)

	local ammo = MARKER_DATA:AmountToWin() * GetConVar('ttt_mark_defi_factor'):GetFloat()
	ammo = math.max(1, ammo)

	self:SetClip1(ammo)
end

function SWEP:SetupDataTables()
	self:NetworkVar('Int', 0, 'State')
	self:NetworkVar('Float', 1, 'Begin')
	self:NetworkVar('String', 0, 'Message')
end

local function braindead(body)
	if not IsValid(body) or not body.sid64 or not player.GetBySteamID64(body.sid64) then
		return true
	end

	return false
end

local function validbody(body)
	return CORPSE.GetPlayerNick(body, false) ~= false
end

local function bodyply(body)
	local ply = false

	if body.sid == 'BOT' then
		ply = player.GetByUniqueID(body.uqid)
	else
		ply = player.GetBySteamID64(body.sid64)
	end

	if not IsValid(ply) then
		return false
	end

	return ply
end

local function IsStucking(ply, pos)
	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos
	tracedata.filter = ply
	tracedata.mins = ply:OBBMins()
	tracedata.maxs = ply:OBBMaxs()

	local trace = util.TraceHull(tracedata)

	if trace.Entity and (trace.Entity:IsWorld() or trace.Entity:IsValid()) then
		return true
	end

	return false
end

if SERVER then
	util.AddNetworkString('TTT_Defib_Hide')
	util.AddNetworkString('TTT_Defib_Revived')

	local offsets = {}

	for i = 0, 360, 15 do
		table.insert(offsets, Vector(math.sin(i), math.cos(i), 0))
	end

	function SWEP:FindRespawnLocation()
		local owner = self:GetOwner()
		local pos = owner:GetPos()
		local maxRepeats = 50
		local newPos

		repeat
			maxRepeats = maxRepeats - 1

			if maxRepeats <= 0 then break end

			local midsize = Vector(33, 33, 74)
			local tstart = pos + Vector(0, 0, midsize.z * 0.5)

			for i = 1, #offsets do
				local o = offsets[i]
				local v = tstart + o * midsize * 1.5

				local t = {
					start = v,
					endpos = v,
					filter = target,
					mins = midsize * -0.5,
					maxs = midsize * 0.5
				}

				local tr = util.TraceHull(t)

				if not tr.Hit then
					newPos = v - Vector(0, 0, midsize.z * 0.5)
				end
			end
		until(not util.IsInWorld(newPos) or IsStucking(owner, newPos))

		return newPos or false
	end

	function SWEP:Reset()
		self:SetState(DEFIB_IDLE)
		self:SetBegin(-1)
		self:SetMessage('')

		self.Target = nil
	end

	function SWEP:Error(msg)
		self:SetState(DEFIB_ERROR)
		self:SetBegin(CurTime())
		self:SetMessage(msg)

		self.Owner:EmitSound(beep, 60, 50, 1)

		self.Target = nil

		timer.Simple(charge:GetFloat() * 0.75, function()
			if IsValid(self) then
				self:Reset()
			end
		end)
	end

	function SWEP:DoRespawn(body)
		local ply = bodyply(body)

		if not ply then return end

		local credits = CORPSE.GetCredits(body, 0) or 0

		net.Start('TTT_Defib_Revived')
		net.WriteBool(true)
		net.Send(ply)

		ply:SpawnForRound(true)
		ply:SetCredits(credits)
		ply:SetPos(self.Location or body:GetPos())
		ply:SetEyeAngles(Angle(0, body:GetAngles().y, 0))
		ply:SetHealth(spawnhealth:GetInt())

		body:Remove()

		self.Owner:ConCommand('lastinv')

		self:SetClip1(self:Clip1() - 1)

		if self:Clip1() < 1 then
			self:Remove()
		end

		-- mark revived player
		timer.Simple(0.1, function()
			MARKER_DATA:SetMarkedPlayer(ply)
		end)
	end

	function SWEP:Defib()
		sound.Play(zap, self.Target:GetPos(), 75, math.random(95, 105), 1)

		if not self.Target or not IsValid(self.Target) or braindead(self.Target) then
			self:Error('SUBJECT BRAINDEAD')

			return
		end

		if not IsFirstTimePredicted() then return end

		local ply = bodyply(self.Target)

		if not ply or not IsValid(ply) then
			self:Error('INVALID TARGET')

			return
		end

		if ply:GetSubRole() == ROLE_MARKER then
			self:Error('Do you think you can revive an other marker?')

			return
		end

		self:DoRespawn(self.Target)
		self:Reset()
	end

	function SWEP:Begin(body, bone)
		local ply = bodyply(body)

		if not ply or not IsValid(ply) then
			self:Error('INVALID TARGET')

			return
		end

		if ply:GetSubRole() == ROLE_MARKER then
			self:Error('Do you think you can revive an other marker?')

			return
		end

		self:SetState(DEFIB_BUSY)
		self:SetBegin(CurTime())
		self:SetMessage('DEFIBRILLATING ' .. string.upper(ply:Nick()))

		self.Owner:EmitSound(hum, 75, math.random(98, 102), 1)

		self.Target = body
		self.Bone = bone
	end

	function SWEP:Think()
		if self:GetState() == DEFIB_BUSY then
			if self:GetBegin() + charge:GetFloat() <= CurTime() then
				self:Defib()
			elseif not self.Owner:KeyDown(IN_ATTACK) or self.Owner:GetEyeTrace(MASK_SHOT_HULL).Entity ~= self.Target then
				self:Error('DEFIBRILLATION ABORTED')
			end
		end
	end
end

if CLIENT then
	net.Receive('TTT_Defib_Hide', function(len, ply)
		if ply or len <= 0 then return end

		local hply = net.ReadEntity()

		hply.DefibHide = net.ReadBool()
	end)

	net.Receive('TTT_Defib_Revived', function(len, ply)
		if ply or len <= 0 then return end

		surface.PlaySound(revived)
	end)

	hook.Remove('TTTEndRound', 'RemoveDefibHide')

	hook.Add('TTTEndRound', 'RemoveDefibHide', function()
		for _, v in ipairs(player.GetAll()) do
			v.DefibHide = nil
		end
	end)

	oldScoreGroup = oldScoreGroup or ScoreGroup

	function ScoreGroup(ply)
		if ply.DefibHide then
			return GROUP_FOUND
		end

		return oldScoreGroup(ply)
	end

	function SWEP:DrawHUD()
		local state = self:GetState()

		self.BaseClass.DrawHUD(self)

		if state == DEFIB_IDLE then return end

		local time = self:GetBegin() + charge:GetFloat()

		local x = ScrW() * 0.5
		local y = ScrH() * 0.5

		y = y + y / 3

		local w, h = 255, 20

		if state == DEFIB_BUSY then
			if time < 0 then return end

			local cc = math.min(1, 1 - (time - CurTime()) / charge:GetFloat())

			surface.SetDrawColor(0, 255, 0, 155)
			surface.DrawOutlinedRect(x - w * 0.5, y - h, w, h)
			surface.DrawRect(x - w * 0.5, y - h, w * cc, h)

			surface.SetFont('TabLarge')
			surface.SetTextColor(255, 255, 255, 180)
			surface.SetTextPos((x - w * 0.5) + 3, y - h - 15)
			surface.DrawText(self:GetMessage())
		elseif state == DEFIB_ERROR then
			surface.SetDrawColor(200 + math.sin(CurTime() * 32) * 50, 0, 0, 155)
			surface.DrawOutlinedRect(x - w * 0.5, y - h, w, h)
			surface.DrawRect(x - w * 0.5, y - h, w, h)

			surface.SetFont('TabLarge')
			surface.SetTextColor(255, 255, 255, 180)
			surface.SetTextPos((x - w * 0.5) + 3, y - h - 15)
			surface.DrawText(self:GetMessage())
		end
	end
end

function SWEP:PrimaryAttack()
	if SERVER then
		if self:GetState() ~= DEFIB_IDLE then return end

		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

		local tr = self.Owner:GetEyeTrace(MASK_SHOT_HULL)

		if tr.HitPos:Distance(self.Owner:GetPos()) > maxdist:GetInt() or GetRoundState() ~= ROUND_ACTIVE then return end

		local ent = tr.Entity

		if IsValid(ent) then
			if ent:GetClass() == 'prop_physics' and mutate[ent:GetModel()] and mutateok:GetInt() > 0 then
				ent:EmitSound(zap, 75, math.random(98, 102))
				ent:SetModelScale(math.min(mutatemax:GetFloat(), ent:GetModelScale() + 0.25), 1)
			elseif ent:GetClass() == 'prop_ragdoll' and validbody(ent) then
				if braindead(ent) then
					self:Error('SUBJECT BRAINDEAD')

					return
				else
					self.Location = self:FindRespawnLocation()

					if self.Location then
						self:Begin(ent, tr.PhysicsBone)
					else
						self:Error('INSUFFICIENT ROOM')

						return
					end
				end
			end
		end
	else
		return false
	end
end

function SWEP:DryFire()
	return false
end

function SWEP:OnDrop()
	self:Remove()
end
