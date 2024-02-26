if CLIENT then
    hook.Add("Initialize", "ttt2_role_marker_init", function()
        STATUS:RegisterStatus("ttt2_role_marker_marked", {
            hud = Material("vgui/ttt/hud_icon_marked.png"),
            type = "bad",
        })
    end)
end
