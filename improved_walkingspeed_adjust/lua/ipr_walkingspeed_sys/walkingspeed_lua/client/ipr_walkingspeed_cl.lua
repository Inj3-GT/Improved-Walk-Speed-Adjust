--- Script By Inj3
--- https://steamcommunity.com/id/Inj3/
--- https://github.com/Inj3-GT
local ipr_CWalkSpeed = {}
ipr_CWalkSpeed.Ckey = ipr_WalkSpeed_Config.AddKey[1]

do
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
            local ipr_CMWSDisable = ipr_WalkSpeed_Config.DisableMWS
            if not ipr_CMWSDisable then
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

ipr_CWalkSpeed.ScrW = ScrW()
ipr_CWalkSpeed.ScrH = ScrH()
ipr_CWalkSpeed.Percent = 100
ipr_CWalkSpeed.MinRotation = 0
ipr_CWalkSpeed.Lerp = ipr_CWalkSpeed.Percent / 2
ipr_CWalkSpeed.ColorBox = {Bar_Bg = Color(0, 0, 0, 190), Bar = Color(52, 73, 94, 255)}
ipr_CWalkSpeed.FontHUD = "DefaultFixedDropShadow"

local function Ipr_SWOnScreen()
    ipr_CWalkSpeed.ScrW, ipr_CWalkSpeed.ScrH = ScrW(), ScrH()
end

local function ipr_Draw_WalkSpeed()
    local ipr_HUD = ipr_WalkSpeed_Config.HUD
    if not ipr_HUD then
        return
    end
    local ipr_MLocal = LocalPlayer()
    if not ipr_MLocal:Alive() then
        return
    end
    local ipr_WalkSpeed = ipr_MLocal:GetWalkSpeed()
    local ipr_WalkSpeed_Max = ipr_MLocal:GetRunSpeed()
    local ipr_ReduceSlowWalkSpeed = ipr_WalkSpeed_Config.ReduceSlowWalkSpeed
    local ipr_WalkSpeed_Slow = ipr_MLocal:GetSlowWalkSpeed() * ipr_ReduceSlowWalkSpeed
    local ipr_MaxRotation = ipr_WalkSpeed_Config.MaxRotation
    local ipr_MinRotation = ipr_CWalkSpeed.MinRotation

    local ipr_RealtimeSpeed = ipr_MinRotation + ((ipr_WalkSpeed - ipr_WalkSpeed_Slow) / (ipr_WalkSpeed_Max - ipr_WalkSpeed_Slow)) * (ipr_MaxRotation - ipr_MinRotation)
    ipr_RealtimeSpeed = (ipr_RealtimeSpeed / ipr_MaxRotation) * ipr_CWalkSpeed.Percent
    ipr_RealtimeSpeed = math.Round(ipr_RealtimeSpeed)

    local ipr_DrawKey = ipr_WalkSpeed_Config.DrawKey
    if (ipr_DrawKey) then
        local ipr_Lang1, ipr_Lang2 = ipr_WalkSpeed_Config.Lang.Key1, ipr_WalkSpeed_Config.Lang.Key2
        local ipr_Wheel = (ipr_CWalkSpeed.Ckey) and ipr_Lang1 or ""
        draw.DrawText(ipr_Lang2.. " " ..ipr_Wheel, ipr_CWalkSpeed.FontHUD, ipr_CWalkSpeed.ScrW / 2, ipr_CWalkSpeed.ScrH - 50, color_white, TEXT_ALIGN_CENTER)
    end
    local ipr_DrawBar = ipr_WalkSpeed_Config.DrawBar
    if (ipr_DrawBar) then
        ipr_PercentWheel_Lerp = (ipr_RealtimeSpeed < 1) and 3 or ipr_RealtimeSpeed
        ipr_CWalkSpeed.Lerp = Lerp(0.05, ipr_CWalkSpeed.Lerp, ipr_PercentWheel_Lerp)

        draw.RoundedBox(4, ipr_CWalkSpeed.ScrW / 2 - 50, ipr_CWalkSpeed.ScrH - 30, ipr_CWalkSpeed.Percent, 10, ipr_CWalkSpeed.ColorBox.Bar_Bg)
        draw.RoundedBox(4, ipr_CWalkSpeed.ScrW / 2 - 50, ipr_CWalkSpeed.ScrH - 30, ipr_CWalkSpeed.Lerp, 10, ipr_CWalkSpeed.ColorBox.Bar)
    end
    local ipr_DrawSpeedPercent = ipr_WalkSpeed_Config.DrawSpeedPercent
    if (ipr_DrawSpeedPercent) then
        local ipr_Lang3 = ipr_WalkSpeed_Config.Lang.WalkSpeed
        ipr_PercentWheel_Perc = (ipr_RealtimeSpeed < 1) and 1 or ipr_RealtimeSpeed
        draw.DrawText(ipr_Lang3.. " " ..ipr_PercentWheel_Perc.. "%", ipr_CWalkSpeed.FontHUD, ipr_CWalkSpeed.ScrW / 2, ipr_CWalkSpeed.ScrH - 15, color_white, TEXT_ALIGN_CENTER)
    end
end

hook.Add("HUDPaint", "ipr_MouseWheel_DrawWalkSpeed", ipr_Draw_WalkSpeed)
hook.Add("OnScreenSizeChanged", "Ipr_SWOnScreen", Ipr_SWOnScreen)
