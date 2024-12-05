--- Script By Inj3
--- https://steamcommunity.com/id/Inj3/
--- https://github.com/Inj3-GT
local ipr_SpeedWheel = {}
ipr_SpeedWheel.NetBits = ipr_NumberOfBits(ipr_SpeedWheel_Config.MaxRotation)
ipr_SpeedWheel.MaxRotation = ipr_SpeedWheel_Config.MaxRotation 
ipr_SpeedWheel.ReduceSpeed = ipr_SpeedWheel_Config.ReduceSpeed
ipr_SpeedWheel.MinRotation = 0

local function ipr_MClamp(v, n, x)
    return (v < n) and n or (v > x) and x or v
end

local function ipr_MGetWheel(p)
    return p.mwheel or ipr_SpeedWheel.MinRotation
end

local function ipr_BGetWheel(b)
    return (b == MOUSE_WHEEL_DOWN or b == MOUSE_WHEEL_UP)
end

local function ipr_SetWheel(p, b)
    if not p.mwheel then
        p.mwheel = ipr_SpeedWheel.MinRotation
    end
    if (b == MOUSE_WHEEL_DOWN) then
        p.mwheel = p.mwheel - 1
    elseif (b == MOUSE_WHEEL_UP) then
        p.mwheel = p.mwheel + 1
    end

    p.mwheel = ipr_MClamp(p.mwheel, ipr_SpeedWheel.MinRotation, ipr_SpeedWheel.MaxRotation)
end

hook.Add("PlayerButtonDown", "ipr_MouseWheel_Down", function(p, b)
    if not IsValid(p) then
        return
    end
    if not ipr_BGetWheel(b) then
        return
    end
    local ipr_cur = CurTime()
    if (ipr_cur > (p.cwheel or 0)) then
        if not p:Alive() then
            return
        end
        ipr_SetWheel(p, b)

        local ipr_Mouse_Wheel = ipr_MGetWheel(p)
        local ipr_WalkSpeed = p:GetWalkSpeed()
        local ipr_WalkSpeed_Max = p:GetRunSpeed()
        local ipr_WalkSpeed_Slow = p:GetSlowWalkSpeed()

        ipr_WalkSpeed = ipr_WalkSpeed_Slow + ((ipr_WalkSpeed_Max * ipr_SpeedWheel.ReduceSpeed - ipr_WalkSpeed_Slow) / (ipr_SpeedWheel.MaxRotation - ipr_SpeedWheel.MinRotation)) * (ipr_Mouse_Wheel - ipr_SpeedWheel.MinRotation)
        ipr_WalkSpeed = math.Round(ipr_WalkSpeed)
        if (ipr_WalkSpeed == p.nwheel) then
            return
        end
        p:SetWalkSpeed(ipr_WalkSpeed)
        p.nwheel = ipr_WalkSpeed
        p.cwheel = ipr_cur + 0.1

        net.Start("ipr_swheelsync")
        net.WriteUInt(ipr_Mouse_Wheel, ipr_SpeedWheel.NetBits)
        net.Send(p)
    end
end)