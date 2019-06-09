if CLIENT then
    hook.Add('Initialize', 'ttt2_role_marker_init', function() 
        STATUS:RegisterStatus('ttt2_role_marker_marked', {
            hud = Material('vgui/ttt/hud_icon_marked.png'),
            type = 'bad'
        })

    end)
end

if SERVER then
    resource.AddFile('materials/vgui/ttt/dynamic/roles/icon_mark.vmt')
    resource.AddFile('materials/vgui/ttt/hud_icon_marked.png')
    resource.AddFile('materials/vgui/ttt/hud_icon_marked_end.png')
end