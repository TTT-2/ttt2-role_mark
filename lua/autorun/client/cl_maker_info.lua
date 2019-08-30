if CLIENT then
    
    function DrawMarkerInfo()
        local client = LocalPlayer()

        if client:GetTeam() ~= TEAM_MARKER then return end
        
        local tracedata = {}
        tracedata.start = client:GetShootPos()
        tracedata.endpos = tracedata.start + (client:GetEyeTrace().HitPos - tracedata.start) *2 -- make sure the trace is long enough
        tracedata.filter = client
        local trace = util.TraceLine(tracedata)

        if trace.HitNonWorld and IsValid(trace.Entity) and trace.Entity:IsPlayer() then
            if not MARKER_DATA:IsMarked(trace.Entity) then return end
            
            local x = ScrW() / 2.0
            local y = ScrH() / 1.5            
            draw.SimpleText("(PLAYER IS MARKED)", "TabLarge", x, y - 50, client:GetRoleColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
        end
    end
    hook.Add('HUDPaint', 'ttt2_role_mark_hud_info', DrawMarkerInfo)
end