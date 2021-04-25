SWEP.Base = "weapon_tttbase"

SWEP.Kind = WEAPON_NONE

if SERVER then
	AddCSLuaFile("weapon_ttt2_markergun.lua")
end

if CLIENT then
	SWEP.PrintName = "Marker Gun"
	SWEP.Author = "TTT2 Team"
	SWEP.Instructions = "Shoot with primary and secondary fire."
	SWEP.CSMuzzleFlashes = true

	SWEP.Icon = "vgui/ttt/icon_markergun.png"

	SWEP.EquipMenuData = {
		type = "item_weapon",
		name = "ttt2_paintgun_name",
		desc = "ttt2_paintgun_desc"
	}

	hook.Add("Initialize", "TTTInitMarkerGunLang", function()
		LANG.AddToLanguage("English", "ttt2_paintgun_desc", "Shoot a player to mark hin")
		LANG.AddToLanguage("Deutsch", "ttt2_paintgun_desc", "Schieße auf einen Spieler, um ihn zu markieren.")
	end)
end

SWEP.data                   = {}
SWEP.data.newclip           = false

SWEP.Spawnable			    = true
SWEP.AdminSpawnable		    = true

SWEP.HoldType			    = "pistol"
SWEP.ViewModel			    = "models/Weapons/v_blazer.mdl"
SWEP.WorldModel			    = "models/Weapons/w_blazer.mdl"
SWEP.ViewModelFlip		    = false

SWEP.Drawammo               = true
SWEP.DrawCrosshair          = false

SWEP.Weight			        = 5
SWEP.AutoSwitchTo		    = false
SWEP.AutoSwitchFrom		    = false
SWEP.AllowDrop              = false
SWEP.notBuyable             = true

SWEP.Primary.Sound		    = Sound("marker/pbfire.wav")
SWEP.Primary.Recoil		    = 1.5
SWEP.Primary.Damage		    = 1
SWEP.Primary.NumShot        = 1
SWEP.Primary.Cone		    = 0.01
SWEP.Primary.Delay		    = 0.30
SWEP.Primary.ClipSize	    = 250
SWEP.Primary.DefaultClip    = 250
SWEP.Primary.AmmoSize       = 0
SWEP.Primary.DefaultAmmo    = 0
SWEP.Primary.Automatic	    = false
SWEP.Primary.Ammo		    = "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		    = "none"

function SWEP:Reload()
	self:DefaultReload(ACT_VM_RELOAD);
end

function SWEP:OnDrop()
	self:Remove()
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	self:EmitSound(Sound("marker/pbfire.wav"))
	self:SetNextPrimaryFire(CurTime() + 0.25)
	self:ShootEffects()
	self:TakePrimaryAmmo(0)

	if SERVER then
		local pb = ents.Create("paint_ball")

		local shoot_pos = self.Owner:GetShootPos()
		shoot_pos = shoot_pos + self.Owner:GetForward() * 10
		shoot_pos = shoot_pos + self.Owner:GetRight() * 7
		shoot_pos = shoot_pos + self.Owner:GetUp() * -0.75

		local shoot_vector = self.Owner:GetEyeTrace().HitPos - shoot_pos

		pb:SetPos(shoot_pos)
		pb:SetAngles(Angle(shoot_vector))
		pb:SetOwner(self.Owner)
		pb:Spawn()

		local phys = pb:GetPhysicsObject()
		phys:ApplyForceCenter(shoot_vector * 7000)
	end
end

function SWEP:ShootEffects()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:MuzzleFlash()
end

-- marker handling
if SERVER then
	hook.Add("ScalePlayerDamage", "MarkerHitReg", function(ply, hitgroup, dmginfo)
		local attacker = dmginfo:GetAttacker()

		if GetRoundState() ~= ROUND_ACTIVE or not attacker or not IsValid(attacker)
			or not attacker:IsPlayer() or not IsValid(attacker:GetActiveWeapon())
		then return end

		local wep = attacker:GetActiveWeapon()

		if wep:GetClass() ~= "weapon_ttt2_markergun" then return end

		-- send to marker that he has marked another player
		if ply:GetTeam() ~= TEAM_MARKER then
			MARKER_DATA:SetMarkedPlayer(attacker, ply, false)
		end

		dmginfo:SetDamage(0)

		return true
	end)
end
