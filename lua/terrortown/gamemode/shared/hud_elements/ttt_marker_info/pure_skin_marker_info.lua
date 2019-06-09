local base = 'pure_skin_element'

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then -- CLIENT
    local const_defaults = {
        basepos = {x = 0, y = 0},
        size = {w = 110, h = 40},
        minsize = {w = 110, h = 40}
    }

    HUDELEMENT.marker_icon = Material("vgui/ttt/hud_icon_marked.png")
    HUDELEMENT.marker_icon_end = Material("vgui/ttt/hud_icon_marked_end.png")
    
    function HUDELEMENT:Initialize()
		self.scale = 1.0
		self.basecolor = self:GetHUDBasecolor()

		BaseClass.Initialize(self)
    end

    function HUDELEMENT:PerformLayout()
		self.basecolor = self:GetHUDBasecolor()

		BaseClass.PerformLayout(self)
	end
    
    function HUDELEMENT:GetDefaults()
		const_defaults['basepos'] = {x = math.Round(ScrW() - (10 * self.scale + self.size.w)), y = math.Round(ScrH() * 0.5 - self.size.h * 0.5)}

		return const_defaults
	end

	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return false, false
    end

    function HUDELEMENT:ShouldDraw()
        local c = LocalPlayer()
        return (GetRoundState() == ROUND_ACTIVE and LocalPlayer():GetSubRole() == ROLE_MARKER and c:Alive() and c:IsTerror()) or HUDEditor.IsEditing
	end
    -- parameter overwrites end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()
		local pos = self:GetPos()
		local size = self:GetSize()
		local x, y = pos.x, pos.y
		local w, h = size.w, size.h
		
		-- draw bg
        self:DrawBg(x, y, w, h, self.basecolor)

        local color = nil
        if MARKER_DATA:AbleToWin() then
            util.DrawFilteredTexturedRect(x + 8 * self.scale, y + 5 * self.scale, 30 * self.scale, 30 * self.scale, self.marker_icon, 175)
            color = self:GetDefaultFontColor(self.basecolor)
            color.a = 175
        else
            util.DrawFilteredTexturedRect(x + 8 * self.scale, y + 5 * self.scale, 30 * self.scale, 30 * self.scale, self.marker_icon_end, 75)
            color = self:GetDefaultFontColor(self.basecolor)
            color.a = 75
        end

        local amnt_print = tostring(MARKER_DATA:GetMarkedAmount()) .. ' / ' .. tostring(MARKER_DATA:GetNoMarkerPlayerAlive())
        self:AdvancedText(amnt_print, 'PureSkinBar', x + 46 * self.scale, y + 9 * self.scale, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, true, self.scale)
        
        -- draw border and shadow
        self:DrawLines(x, y, w, h, self.basecolor.a)
    end
end