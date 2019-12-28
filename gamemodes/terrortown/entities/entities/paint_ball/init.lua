AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

paintballdamage = tonumber(1)

concommand.Add("paintball_damage",SetPaintDamage)

function SetPaintDamage(ply, cmd, args)
	if cmd == "paintball_damage" then
		paintballdamage = tonumber(args[1])
	end
end

function ENT:SpawnFunction(ply, tr)
	if not tr.Hit then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 1

	local ent = ents.Create( "paint_ball" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:Initialize()
	self:SetModel("models/paintball/paintball.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:OnTakeDamage(dmginfo)
	-- React physically when shot/getting blown
	self:TakePhysicsDamage(dmginfo)
end

function ENT:PhysicsCollide(data, phy)
	local trace = {}
	trace.filter = {self}
	data.HitNormal = data.HitNormal * -1

	local start = data.HitPos + data.HitNormal
	local endpos = data.HitPos - data.HitNormal

	util.Decal("splat" .. math.random(1, 12), start, endpos)
	self:EmitSound(Sound("marker/pbhit.wav"))

	util.BlastDamage(self:GetOwner(), self:GetOwner(), data.HitPos, 1, paintballdamage)
	self:Fire("kill", "", 0)
end

function ENT:Touch(ent)
	if ent:IsValid() then
		self:Fire("kill", "", 0)
	end
end

function ENT:Use(activator, caller)
end

function ENT:Think()
end
