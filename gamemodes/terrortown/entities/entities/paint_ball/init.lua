AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

paintballdamage = tonumber(1)

game.AddDecal("splat1","decals/splat1")
game.AddDecal("splat2","decals/splat2")
game.AddDecal("splat3","decals/splat3")
game.AddDecal("splat4","decals/splat4")
game.AddDecal("splat5","decals/splat5")
game.AddDecal("splat6","decals/splat6")
game.AddDecal("splat7","decals/splat7")
game.AddDecal("splat8","decals/splat8")
game.AddDecal("splat9","decals/splat9")
game.AddDecal("splat10","decals/splat10")
game.AddDecal("splat11","decals/splat11")
game.AddDecal("splat12","decals/splat12")

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
	self.Entity:SetModel("models/paintball/paintball.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	 
	local phys = self.Entity:GetPhysicsObject()
	
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:OnTakeDamage(dmginfo)

	-- React physically when shot/getting blown
	self.Entity:TakePhysicsDamage( dmginfo )

end

function ENT:PhysicsCollide(data, phy)
	local trace = {}
	trace.filter = {self.Entity}
	data.HitNormal = data.HitNormal * -1
	local start = data.HitPos + data.HitNormal
	local endpos = data.HitPos - data.HitNormal
  
	util.Decal("splat"..math.random(1,12),start,endpos)
	self.Entity:EmitSound(Sound( "marker/pbhit.wav" ))
 
	util.BlastDamage(self.Entity:GetOwner(),self.Entity:GetOwner(),data.HitPos,1,paintballdamage)
	self.Entity:Fire("kill", "", 0)
end

function ENT:Touch(ent)
if ent:IsValid() then	
	self.Entity:Fire("kill", "", 0)
	end
end

function ENT:Use(activator, caller)
end

function ENT:Think()
end


