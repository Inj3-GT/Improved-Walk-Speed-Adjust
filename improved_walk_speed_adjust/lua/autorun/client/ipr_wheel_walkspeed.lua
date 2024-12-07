--- Script By Inj3
--- https://steamcommunity.com/id/Inj3/
--- https://github.com/Inj3-GT

local ipr_SpeedWheel = {}
ipr_SpeedWheel.NetBits = ipr_NumberOfBits(ipr_SpeedWheel_Config.MaxRotation)
ipr_SpeedWheel.FontHUD = "CreditsText"
ipr_SpeedWheel.Key = input.GetKeyName(ipr_SpeedWheel_Config.AddKey.key)
ipr_SpeedWheel.KeyPress = false
ipr_SpeedWheel.Rotation = 0
ipr_SpeedWheel.ScrW = ScrW()
ipr_SpeedWheel.ScrH = ScrH()
ipr_SpeedWheel.Bind = {
    ["invprev"] = true,
    ["invnext"] = true,
}

net.Receive("ipr_swheelsync", function()
    ipr_SpeedWheel.Rotation = net.ReadUInt(ipr_SpeedWheel.NetBits)
end)

hook.Add("StartCommand", "ipr_MouseWheel_KeyPress", function(ply, cmd)
    if not ipr_SpeedWheel_Config.AddKey[1] then
        return
    end
    ipr_SpeedWheel.KeyPress = input.IsKeyDown(ipr_SpeedWheel_Config.AddKey.key)
end)

local function ipr_WeapSelector(ply, bind, pressed)
    if (ipr_SpeedWheel.Bind[bind]) then
        if not ipr_SpeedWheel_Config.DisableMWS then
            if not ipr_SpeedWheel_Config.AddKey[1] then
                return false
            end
            return ipr_SpeedWheel.KeyPress
        end
        return true
    end
end

local function ipr_Draw_WalkSpeed()
    if not ipr_SpeedWheel_Config.HUD then
        return
    end
    local ipr_PercentWheel = (ipr_SpeedWheel.Rotation / ipr_SpeedWheel_Config.MaxRotation) * 100
    ipr_PercentWheel = math.Round(ipr_PercentWheel)

    local ipr_Wheel = (ipr_SpeedWheel_Config.AddKey[1]) and "+ Molette" or ""
    draw.DrawText(ipr_SpeedWheel.Key.. " " ..ipr_Wheel, ipr_SpeedWheel.FontHUD, ipr_SpeedWheel.ScrW / 2, ipr_SpeedWheel.ScrH - 45, color_white, TEXT_ALIGN_CENTER)
    draw.DrawText("Vitesse de marche : " ..ipr_PercentWheel.. "%", ipr_SpeedWheel.FontHUD, ipr_SpeedWheel.ScrW / 2, ipr_SpeedWheel.ScrH - 25, color_white, TEXT_ALIGN_CENTER)
end

hook.Add("PlayerBindPress", "ipr_MouseWheel_WeapSelector", ipr_WeapSelector)
hook.Add("HUDPaint", "ipr_MouseWheel_DrawWalkSpeed", ipr_Draw_WalkSpeed)
