include("shared.lua")

local paintball = Material( "sprites/pb" )

function ENT:Initialize()
	local i = math.random(0, 3)
	if i == 0 then
		self.Color = Color(255, 0, 0, 255)
	elseif i == 1 then
		self.Color = Color(0, 255, 0, 255)
	elseif i == 2 then
		self.Color = Color(255, 255, 0, 255)
	else
		self.Color = Color(0, 0, 255, 255)
	end
end

function ENT:Draw()
	local pos = self:GetPos()
	local vel = self:GetVelocity()

	render.SetMaterial(paintball)

	local lcolor = render.GetLightColor(pos) * 2
	lcolor.x = self.Color.r * math.Clamp(lcolor.x, 0, 1)
	lcolor.y = self.Color.g * math.Clamp(lcolor.y, 0, 1)
	lcolor.z = self.Color.b * math.Clamp(lcolor.z, 0, 1)

	// Fake motion blur
	for i = 1, 10 do
		local col = Color(lcolor.x, lcolor.y, lcolor.z, 200 / i)
		render.DrawSprite(pos + vel * ( i * -0.005), 1, 1, col)
	end

	render.DrawSprite(pos, 1, 1, lcolor)
end

