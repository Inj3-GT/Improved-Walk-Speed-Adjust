--- Script By Inj3
--- https://steamcommunity.com/id/Inj3/
--- https://github.com/Inj3-GT
local ipr_CWalkSpeed = {}
ipr_CWalkSpeed.NetBits = ipr_NumberOfBits(ipr_WalkSpeed_Config.MaxRotation)
ipr_CWalkSpeed.Ckey = ipr_WalkSpeed_Config.AddKey[1]

do
    ipr_CWalkSpeed.CMWSDisable = ipr_WalkSpeed_Config.DisableMWS
    ipr_CWalkSpeed.AKey = ipr_WalkSpeed_Config.AddKey.key
    ipr_CWalkSpeed.KeyPress = false
    ipr_CWalkSpeed.Bind = {
        ["invprev"] = true,
        ["invnext"] = true,
    }

    local function ipr_SWheelKey()
        if not ipr_CWalkSpeed.Ckey then
            return
        end
        local ipr_Key = input.IsKeyDown(ipr_CWalkSpeed.AKey)
        ipr_CWalkSpeed.KeyPress = ipr_Key
    end

    local function ipr_SWheelWeap(p, b)
        if (ipr_CWalkSpeed.Bind[b]) then
            if not ipr_CWalkSpeed.CMWSDisable then
                if not ipr_CWalkSpeed.Ckey then
                    return false
                end
                return ipr_CWalkSpeed.KeyPress
            end
            return true
        end
    end
    hook.Add("StartCommand", "ipr_MouseWheel_KeyPress", ipr_SWheelKey)
    hook.Add("PlayerBindPress", "ipr_MouseWheel_WeapSelector", ipr_SWheelWeap)
end
if not ipr_WalkSpeed_Config.HUD then
    return
end

local ipr_SpeedWheel_Rotation = 0
local function ipr_SWheelSync()
    ipr_SpeedWheel_Rotation = net.ReadUInt(ipr_CWalkSpeed.NetBits)
end

ipr_CWalkSpeed.ScrW = ScrW()
ipr_CWalkSpeed.ScrH = ScrH()
ipr_CWalkSpeed.Percent = 100
ipr_CWalkSpeed.Lerp = ipr_CWalkSpeed.Percent / 2
ipr_CWalkSpeed.ColorBox = {Bar_Bg = Color(0, 0, 0, 190), Bar = Color(52, 73, 94, 255)}
ipr_CWalkSpeed.FontHUD = "DefaultFixedDropShadow"

local function Ipr_SWOnScreen()
    ipr_CWalkSpeed.ScrW, ipr_CWalkSpeed.ScrH = ScrW(), ScrH()
end

local function ipr_Draw_WalkSpeed()
    local ipr_SConfWheel = ipr_WalkSpeed_Config
    if not ipr_SConfWheel.HUD then
        return
    end
    local ipr_MLocal = LocalPlayer()
    if not ipr_MLocal:Alive() then
        return
    end
    local ipr_PercentWheel = (ipr_SpeedWheel_Rotation / ipr_SConfWheel.MaxRotation) * ipr_CWalkSpeed.Percent
    ipr_PercentWheel = math.Round(ipr_PercentWheel)

    if (ipr_SConfWheel.DrawKey) then
        local ipr_Wheel = (ipr_CWalkSpeed.Ckey) and ipr_SConfWheel.Lang.Key1 or ""
        draw.DrawText(ipr_SConfWheel.Lang.Key2.. " " ..ipr_Wheel, ipr_CWalkSpeed.FontHUD, ipr_CWalkSpeed.ScrW / 2, ipr_CWalkSpeed.ScrH - 50, color_white, TEXT_ALIGN_CENTER)
    end
    if (ipr_SConfWheel.DrawBar) then
        ipr_PercentWheel_Lerp = (ipr_PercentWheel < 1) and 3 or ipr_PercentWheel
        ipr_CWalkSpeed.Lerp = Lerp(0.05, ipr_CWalkSpeed.Lerp, ipr_PercentWheel_Lerp)

        draw.RoundedBox(4, ipr_CWalkSpeed.ScrW / 2 - 50, ipr_CWalkSpeed.ScrH - 30, ipr_CWalkSpeed.Percent, 10, ipr_CWalkSpeed.ColorBox.Bar_Bg)
        draw.RoundedBox(4, ipr_CWalkSpeed.ScrW / 2 - 50, ipr_CWalkSpeed.ScrH - 30, ipr_CWalkSpeed.Lerp, 10, ipr_CWalkSpeed.ColorBox.Bar)
    end
    if (ipr_SConfWheel.DrawSpeedPercent) then
        ipr_PercentWheel_Perc = (ipr_PercentWheel < 1) and 1 or ipr_PercentWheel
        draw.DrawText(ipr_SConfWheel.Lang.WalkSpeed.. " " ..ipr_PercentWheel_Perc.. "%", ipr_CWalkSpeed.FontHUD, ipr_CWalkSpeed.ScrW / 2, ipr_CWalkSpeed.ScrH - 15, color_white, TEXT_ALIGN_CENTER)
    end
end

net.Receive("ipr_swheelsync", ipr_SWheelSync)
hook.Add("HUDPaint", "ipr_MouseWheel_DrawWalkSpeed", ipr_Draw_WalkSpeed)
hook.Add("OnScreenSizeChanged", "Ipr_SWOnScreen", Ipr_SWOnScreen)
