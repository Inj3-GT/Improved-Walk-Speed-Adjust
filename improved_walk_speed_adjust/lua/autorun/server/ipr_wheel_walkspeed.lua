--- Script By Inj3
--- https://steamcommunity.com/id/Inj3/
--- https://github.com/Inj3-GT
local ipr_SpeedWheel = {}
ipr_SpeedWheel.MaxRotation = 10 --- The number of times you have to roll your mouse wheel to reach maximum speed.
ipr_SpeedWheel.ReduceSpeed = 0.95 --- Removes 5% of max running speed (set 1 if you don't want a speed reduction).
ipr_SpeedWheel.MinRotation = 0 -- Do not touch !

local function ipr_BGetWheel(b)
    return (b == MOUSE_WHEEL_DOWN or b == MOUSE_WHEEL_UP)
end

local function ipr_GetMWheel(p)
    return p.ipr_wheel or ipr_SpeedWheel.MinRotation
end

local function ipr_mClamp(v, n, x)
    return (v < n) and n or (v > x) and x or v
end

local function ipr_SetWheel(p, b)
    if not p.ipr_wheel then
        p.ipr_wheel = ipr_SpeedWheel.MinRotation
    end

    if (b == MOUSE_WHEEL_DOWN) then
        p.ipr_wheel = p.ipr_wheel - 1
    elseif (b == MOUSE_WHEEL_UP) then
        p.ipr_wheel = p.ipr_wheel + 1
    end
    p.ipr_wheel = ipr_mClamp(p.ipr_wheel, ipr_SpeedWheel.MinRotation, ipr_SpeedWheel.MaxRotation)
end

hook.Add("PlayerButtonDown", "ipr_MouseWheel_Down", function(p, b)
    if not IsValid(p) then
        return
    end
    if not ipr_BGetWheel(b) or not p:Alive() then
        return
    end
    ipr_SetWheel(p, b)

    local ipr_Mouse_Wheel = ipr_GetMWheel(p)
    local ipr_WalkSpeed = p:GetWalkSpeed()
    local ipr_WalkSpeed_Max = p:GetRunSpeed()
    local ipr_WalkSpeed_Slow = p:GetSlowWalkSpeed()

    ipr_WalkSpeed = ipr_WalkSpeed_Slow + ((ipr_WalkSpeed_Max * ipr_SpeedWheel.ReduceSpeed - ipr_WalkSpeed_Slow) / (ipr_SpeedWheel.MaxRotation - ipr_SpeedWheel.MinRotation)) * (ipr_Mouse_Wheel - ipr_SpeedWheel.MinRotation)
    ipr_WalkSpeed = math.Round(ipr_WalkSpeed)
    if (p.ipr_WSetNoLoop == ipr_WalkSpeed) then
        return
    end

    p:SetWalkSpeed(ipr_WalkSpeed)
    p.ipr_WSetNoLoop = ipr_WalkSpeed
end)
