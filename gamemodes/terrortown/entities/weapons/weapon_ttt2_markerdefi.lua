if SERVER then
    AddCSLuaFile()
end

local flags = { FCVAR_NOTIFY, FCVAR_ARCHIVE, FCVAR_REPLICATED }

DEFINE_BASECLASS("weapon_ttt_defibrillator")

SWEP.Base = "weapon_ttt_defibrillator"

if CLIENT then
    SWEP.EquipMenuData = {
        type = "item_weapon",
        name = "weapon_markerdefi_name",
        desc = "weapon_markerdefi_desc",
    }

    SWEP.Icon = "vgui/ttt/icon_defi_marker"
end

SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = nil
SWEP.notBuyable = true

SWEP.EnableConfigurableClip = true
SWEP.ConfigurableClip = 3

SWEP.AllowDrop = false

SWEP.cvars = {
    reviveBraindead = CreateConVar("ttt_marker_defibrillator_revive_braindead", "1", flags),
    playSound = CreateConVar("ttt_marker_defibrillator_play_sounds", "1", flags),
    reviveTime = CreateConVar("ttt_marker_defibrillator_revive_time", "2.0", flags),
    errorTime = CreateConVar("ttt_marker_defibrillator_error_time", "1.0", flags),
    successChance = CreateConVar("ttt_marker_defibrillator_success_chance", "100", flags),
    resetConfirmation = CreateConVar("ttt_marker_defibrillator_reset_confirm", "0", flags),
    revivalHealth = CreateConVar("ttt_marker_defibrillator_revival_health", "50", flags),
    revivalMaxHealth = CreateConVar("ttt_marker_defibrillator_revival_max_health", "100", flags),
}

SWEP.revivalReason = "revived_by_marker"

if SERVER then
    function SWEP:OnDrop()
        self:Remove()
    end

    function SWEP:OnRevive(ply, owner)
        -- mark revived player
        timer.Simple(0.1, function()
            MARKER_DATA:SetMarkedPlayer(owner, ply, true)
        end)
    end
end
