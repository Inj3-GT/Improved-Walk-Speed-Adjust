--- Script By Inj3
--- https://steamcommunity.com/id/Inj3/
--- https://github.com/Inj3-GT
local ipr_SpeedWheel = {}
ipr_SpeedWheel.NetBits = ipr_NumberOfBits(ipr_WalkSpeed_Config.MaxRotation)
ipr_SpeedWheel.Ckey = ipr_WalkSpeed_Config.AddKey[1]

do
    ipr_SpeedWheel.CMWSDisable = ipr_WalkSpeed_Config.DisableMWS
    ipr_SpeedWheel.AKey = ipr_WalkSpeed_Config.AddKey.key
    ipr_SpeedWheel.KeyPress = false
    ipr_SpeedWheel.Bind = {
        ["invprev"] = true,
        ["invnext"] = true,
    }

    local function ipr_SWheelKey()
        if not ipr_SpeedWheel.Ckey then
            return
        end
        local ipr_Key = input.IsKeyDown(ipr_SpeedWheel.AKey)
        ipr_SpeedWheel.KeyPress = ipr_Key
    end

    local function ipr_SWheelWeap(p, b)
        if (ipr_SpeedWheel.Bind[b]) then
            if not ipr_SpeedWheel.CMWSDisable then
                if not ipr_SpeedWheel.Ckey then
                    return false
                end
                return ipr_SpeedWheel.KeyPress
            end
            return true
        end
    end
    hook.Add("StartCommand", "ipr_MouseWheel_KeyPress", ipr_SWheelKey)
    hook.Add("PlayerBindPress", "ipr_MouseWheel_WeapSelector", ipr_SWheelWeap)
end

local ipr_SpeedWheel_Rotation = 0
local function ipr_SWheelSync()
    ipr_SpeedWheel_Rotation = net.ReadUInt(ipr_SpeedWheel.NetBits)
end
net.Receive("ipr_swheelsync", ipr_SWheelSync)
if not ipr_WalkSpeed_Config.HUD then
    return
end

ipr_SpeedWheel.ScrW = ScrW()
ipr_SpeedWheel.ScrH = ScrH()
ipr_SpeedWheel.Percent = 100
ipr_SpeedWheel.Lerp = ipr_SpeedWheel.Percent / 2
ipr_SpeedWheel.ColorBox = {Bar_Bg = Color(0, 0, 0, 190), Bar = Color(52, 73, 94, 255)}
ipr_SpeedWheel.FontHUD = "DefaultFixedDropShadow"

local function Ipr_SWOnScreen()
    ipr_SpeedWheel.ScrW, ipr_SpeedWheel.ScrH = ScrW(), ScrH()
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
    local ipr_PercentWheel = (ipr_SpeedWheel_Rotation / ipr_SConfWheel.MaxRotation) * ipr_SpeedWheel.Percent
    ipr_PercentWheel = math.Round(ipr_PercentWheel)

    if (ipr_SConfWheel.DrawKey) then
        local ipr_Wheel = (ipr_SpeedWheel.Ckey) and ipr_SConfWheel.Lang.Key1 or ""
        draw.DrawText(ipr_SConfWheel.Lang.Key2.. " " ..ipr_Wheel, ipr_SpeedWheel.FontHUD, ipr_SpeedWheel.ScrW / 2, ipr_SpeedWheel.ScrH - 50, color_white, TEXT_ALIGN_CENTER)
    end
    if (ipr_SConfWheel.DrawBar) then
        ipr_PercentWheel_Lerp = (ipr_PercentWheel < 1) and 3 or ipr_PercentWheel
        ipr_SpeedWheel.Lerp = Lerp(0.05, ipr_SpeedWheel.Lerp, ipr_PercentWheel_Lerp)

        draw.RoundedBox(4, ipr_SpeedWheel.ScrW / 2 - 50, ipr_SpeedWheel.ScrH - 30, ipr_SpeedWheel.Percent, 10, ipr_SpeedWheel.ColorBox.Bar_Bg)
        draw.RoundedBox(4, ipr_SpeedWheel.ScrW / 2 - 50, ipr_SpeedWheel.ScrH - 30, ipr_SpeedWheel.Lerp, 10, ipr_SpeedWheel.ColorBox.Bar)
    end
    if (ipr_SConfWheel.DrawSpeedPercent) then
        ipr_PercentWheel_Perc = (ipr_PercentWheel < 1) and 1 or ipr_PercentWheel
        draw.DrawText(ipr_SConfWheel.Lang.WalkSpeed.. " " ..ipr_PercentWheel_Perc.. "%", ipr_SpeedWheel.FontHUD, ipr_SpeedWheel.ScrW / 2, ipr_SpeedWheel.ScrH - 15, color_white, TEXT_ALIGN_CENTER)
    end
end

hook.Add("HUDPaint", "ipr_MouseWheel_DrawWalkSpeed", ipr_Draw_WalkSpeed)
hook.Add("OnScreenSizeChanged", "Ipr_SWOnScreen", Ipr_SWOnScreen)