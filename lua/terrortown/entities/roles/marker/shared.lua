if SERVER then
    AddCSLuaFile()

    resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_mark")
end

ROLE.Base = "ttt_role_base"

roles.InitCustomTeam(ROLE.name, {
    icon = "vgui/ttt/dynamic/roles/icon_mark",
    color = Color(125, 70, 135, 255),
})

function ROLE:PreInitialize()
    self.color = Color(125, 70, 135, 255)

    self.abbr = "mark"
    self.score.surviveBonusMultiplier = 0
    self.score.timelimitMultiplier = 0
    self.score.killsMultiplier = 0
    self.score.teamKillsMultiplier = 0
    self.score.bodyFoundMuliplier = 0
    self.score.aliveTeammatesBonusMultiplier = 0

    self.preventWin = true

    self.defaultTeam = TEAM_MARKER

    self.conVarData = {
        pct = 0.15,
        maximum = 1,
        minPlayers = 7,
        credits = 0,
        shopFallback = SHOP_DISABLED,
        togglable = true,
        random = 33,
    }
end

if CLIENT then
    function ROLE:AddToSettingsMenu(parent)
        local form = vgui.CreateTTT2Form(parent, "header_roles_additional")

        form:MakeCheckBox({
            serverConvar = "ttt_mark_show_sidebar",
            label = "label_mark_show_sidebar",
        })

        form:MakeCheckBox({
            serverConvar = "ttt_mark_show_messages",
            label = "label_mark_show_messages",
        })

        form:MakeCheckBox({
            serverConvar = "ttt_mark_deal_no_damage",
            label = "label_mark_deal_no_damage",
        })

        form:MakeCheckBox({
            serverConvar = "ttt_mark_take_no_damage",
            label = "label_mark_take_no_damage",
        })

        form:MakeSlider({
            serverConvar = "ttt_mark_min_alive",
            label = "label_mark_min_alive",
            min = 0,
            max = 25,
            decimal = 0,
        })

        form:MakeSlider({
            serverConvar = "ttt_mark_max_to_mark",
            label = "label_mark_max_to_mark",
            min = 0,
            max = 25,
            decimal = 0,
        })

        form:MakeSlider({
            serverConvar = "ttt_mark_pct_marked",
            label = "label_mark_pct_marked",
            min = 0,
            max = 1,
            decimal = 2,
        })

        form:MakeSlider({
            serverConvar = "ttt_mark_fixed_mark_amount",
            label = "label_mark_fixed_mark_amount",
            min = -1,
            max = 25,
            decimal = 0,
        })

        form:MakeSlider({
            serverConvar = "ttt_mark_hurt_marked_factor",
            label = "label_mark_hurt_marked_factor",
            min = 0,
            max = 1,
            decimal = 2,
        })
    end

    hook.Add("TTTBodySearchPopulate", "ttt2_role_marker_add_marked_indicator", function(search, raw)
        if not raw.owner or not raw.owner.was_marked then
            return
        end

        local highest_id = 0
        for _, v in pairs(search) do
            highest_id = math.max(highest_id, v.p)
        end

        search.was_marked = {
            img = "vgui/ttt/player_marked.png",
            text = LANG.GetTranslation("ttt_marker_was_marked"),
            p = highest_id + 1,
        }
    end)

    local TryT = LANG.TryTranslation
    local ParT = LANG.GetParamTranslation

    local materialCorpse = Material("vgui/ttt/tid/tid_big_corpse")

    hook.Add("TTT2RenderMarkerVisionInfo", "HUDDrawMarkerVisionMarkerCorpse", function(mvData)
        local client = LocalPlayer()
        local ent = mvData:GetEntity()
        local mvObject = mvData:GetMarkerVisionObject()

        if not client:IsTerror() or not mvObject:IsObjectFor(ent, "corpse_marker") then
            return
        end

        local distance = math.Round(util.HammerUnitsToMeters(mvData:GetEntityDistance()), 1)

        mvData:EnableText()

        mvData:AddIcon(materialCorpse)
        mvData:SetTitle(ParT("marker_corpse_player", { nick = CORPSE.GetPlayerNick(ent, "---") }))

        mvData:AddDescriptionLine(ParT("marker_vision_distance", { distance = distance }))
        mvData:AddDescriptionLine(TryT(mvObject:GetVisibleForTranslationKey()), COLOR_SLATEGRAY)
    end)
end

if SERVER then
    local function InitRoleMarker(ply)
        ply:GiveEquipmentWeapon("weapon_ttt2_markergun")
        ply:GiveEquipmentWeapon("weapon_ttt2_markerdefi")
        ply:GiveArmor(60)
        ply:GiveEquipmentItem("item_ttt_radar")
    end

    local function DeinitRoleMarker(ply)
        ply:StripWeapon("weapon_ttt2_markergun")
        ply:StripWeapon("weapon_ttt2_markerdefi")
        ply:RemoveArmor(60)
        ply:RemoveEquipmentItem("item_ttt_radar")
    end

    function ROLE:GiveRoleLoadout(ply, isRoleChange)
        InitRoleMarker(ply)
    end

    function ROLE:RemoveRoleLoadout(ply, isRoleChange)
        DeinitRoleMarker(ply)

        -- remove markings when no marker is alive
        MARKER_DATA:MarkerDied()
    end

    hook.Add("TTTOnCorpseCreated", "MarkerAddedDeadBody", function(rag, ply)
        if not IsValid(rag) or not IsValid(ply) then
            return
        end

        local mvObject = rag:AddMarkerVision("corpse_marker")
        mvObject:SetOwner(ROLE_MARKER)
        mvObject:SetVisibleFor(VISIBLE_FOR_ROLE)
        mvObject:SyncToClients()
    end)

    hook.Add("EntityRemoved", "MarkerRemovedDeadBody", function(ent)
        if not IsValid(ent) or ent:GetClass() ~= "prop_ragdoll" then
            return
        end

        ent:RemoveMarkerVision("corpse_marker")
    end)

    hook.Add("TTTCheckForWin", "TTT2MarkerCheckWin", function()
        if not MARKER_DATA:AbleToWin() then
            return
        end

        if MARKER_DATA:GetMarkedAmount() >= MARKER_DATA:AmountToWin() then
            if MARKER_DATA:AmountNoMarkerAlive() == 0 or MARKER_DATA:GetMarkedAmount() == 0 then
                return
            end

            return TEAM_MARKER
        end
    end)

    hook.Add("EntityTakeDamage", "TTT2MarkerDealNoDamage", function(ply, dmginfo)
        if SpecDM and (ply.IsGhost and ply:IsGhost()) then
            return
        end

        if not ply:IsPlayer() then
            return
        end

        if not GetConVar("ttt_mark_deal_no_damage"):GetBool() then
            return
        end

        if not ply or not IsValid(ply) or not ply:IsPlayer() then
            return
        end

        local attacker = dmginfo:GetAttacker()

        if not attacker or not IsValid(attacker) or not attacker:IsPlayer() then
            return
        end

        if attacker:GetTeam() ~= TEAM_MARKER or attacker == ply then
            return
        end

        local dmg_scale = GetConVar("ttt_mark_hurt_marked_factor"):GetFloat()

        if dmg_scale > 0 then
            dmginfo:ScaleDamage(dmg_scale)
        else
            dmginfo:ScaleDamage(0)
            dmginfo:SetDamage(0)
        end
    end)

    hook.Add("EntityTakeDamage", "TTT2MarkerTakeNoDamage", function(ply, dmginfo)
        if not ply:IsPlayer() then
            return
        end

        if not GetConVar("ttt_mark_take_no_damage"):GetBool() then
            return
        end

        if not ply or not IsValid(ply) or not ply:IsPlayer() then
            return
        end

        local attacker = dmginfo:GetAttacker()

        if not attacker or not IsValid(attacker) or not attacker:IsPlayer() then
            return
        end

        if ply:GetTeam() == TEAM_MARKER and attacker ~= ply and MARKER_DATA:IsMarked(attacker) then
            dmginfo:ScaleDamage(0)
            dmginfo:SetDamage(0)
        end
    end)

    hook.Add(
        "TTT2PharaohPreventDamageToAnkh",
        "TTT2PharaohPreventDamageToAnkhMarker",
        function(attacker)
            if
                attacker:GetTeam() == TEAM_MARKER
                and GetConVar("ttt_mark_deal_no_damage"):GetBool()
            then
                return true
            end
        end
    )
end
