--- Script By Inj3
--- https://steamcommunity.com/id/Inj3/
--- https://github.com/Inj3-GT
local ipr_PMouseWheel, ipr_SWalkSpeed = {}, {}
ipr_SWalkSpeed.MidRotation = math.Round(ipr_WalkSpeed_Config.MaxRotation / 2)
ipr_SWalkSpeed.MinRotation = 0
ipr_SWalkSpeed.MouseKey = {
    [MOUSE_WHEEL_DOWN] = {k = "d"},
    [MOUSE_WHEEL_UP] = {k = "u"},
}

local function ipr_GetPrimaryKey(b)
    return ipr_SWalkSpeed.MouseKey[b] and true
end

local function ipr_GetSecondaryKey(p)
    return ipr_PMouseWheel[p].MouseKeySecond
end

local function ipr_GetWheelRotate(p)
    return ipr_PMouseWheel[p].MsWheel or ipr_SWalkSpeed.MidRotation
end

local function ipr_SetSecondaryKey(k, b, p)
    if (b == ipr_WalkSpeed_Config.AddKey.key) and (k ~= ipr_PMouseWheel[p].MouseKeySecond) then
        ipr_PMouseWheel[p].MouseKeySecond = k
    end
end

local function ipr_SetClamp(v, n, x)
    return (v < n) and n or (v > x) and x or v
end

local function ipr_SetWheelRotate(p, b)
    if not ipr_PMouseWheel[p].MsWheel then
        ipr_PMouseWheel[p].MsWheel = ipr_SWalkSpeed.MidRotation
    end
    
    local ipr_MouseWheel = (ipr_SWalkSpeed.MouseKey[b].k == "d") and -1 or 1
    ipr_PMouseWheel[p].MsWheel = ipr_PMouseWheel[p].MsWheel + ipr_MouseWheel
    local ipr_MaxRotate = ipr_WalkSpeed_Config.MaxRotation
    ipr_PMouseWheel[p].MsWheel = ipr_SetClamp(ipr_PMouseWheel[p].MsWheel, ipr_SWalkSpeed.MinRotation, ipr_MaxRotate)
end

local function ipr_PressedKeys(p, b)
    local ipr_CombineKeys = ipr_WalkSpeed_Config.AddKey[1]
    if (ipr_CombineKeys) then
        return ipr_GetSecondaryKey(p) and ipr_GetPrimaryKey(b)
    end
    return ipr_GetPrimaryKey(b)
end

hook.Add("PlayerDisconnected", "ipr_MouseWheel_Logout", function(p)
    if (ipr_PMouseWheel[p]) then
        ipr_PMouseWheel[p] = nil
    end
end)

hook.Add("PlayerInitialSpawn", "ipr_MouseWheel_InitSpawn", function(p)
    local ipr_MSend = ipr_WalkSpeed_Config.SendNotification[1]
    if (ipr_MSend) then
        timer.Simple(7, function()
            if not IsValid(p) then
                return
            end
            local ipr_MPrint = ipr_WalkSpeed_Config.SendNotification.msg
            p:ChatPrint(ipr_MPrint)
        end)
    end
end)

hook.Add("PlayerButtonUp", "ipr_MouseWheel_ButtonUp", function(p, b)
    if not IsValid(p) then
        return
    end
        
    if (ipr_GetSecondaryKey(p)) then
        ipr_SetSecondaryKey(false, b, p)
    end
end)

hook.Add("PlayerButtonDown", "ipr_MouseWheel_ButtonDown", function(p, b)
    if not IsValid(p) then
        return
    end
    if not ipr_PMouseWheel[p] then
        ipr_PMouseWheel[p] = {}
    end

    local ipr_CurTime = CurTime()
    if (ipr_CurTime > (ipr_PMouseWheel[p].WheelCur or 0)) then
        if not p:Alive() then
            return
        end
        if not ipr_GetSecondaryKey(p) then
            ipr_SetSecondaryKey(true, b, p)
        end
        if not ipr_PressedKeys(p, b) then
            return
        end
        ipr_SetWheelRotate(p, b)

        local ipr_Mouse_Wheel = ipr_GetWheelRotate(p)
        local ipr_SetWalkSpeed = p:GetWalkSpeed()
        local ipr_WalkSpeed_Max = p:GetRunSpeed()
        local ipr_ReduceSlowWalkSpeed = ipr_WalkSpeed_Config.ReduceSlowWalkSpeed
        local ipr_WalkSpeed_Slow = p:GetSlowWalkSpeed() * ipr_ReduceSlowWalkSpeed
        local ipr_ReduceRunSpeed = ipr_WalkSpeed_Config.ReduceRunSpeed
        local ipr_MaxRotation = ipr_WalkSpeed_Config.MaxRotation

        ipr_SetWalkSpeed = ipr_WalkSpeed_Slow + ((ipr_WalkSpeed_Max * ipr_ReduceRunSpeed - ipr_WalkSpeed_Slow) / (ipr_MaxRotation - ipr_SWalkSpeed.MinRotation)) * (ipr_Mouse_Wheel - ipr_SWalkSpeed.MinRotation)
        ipr_SetWalkSpeed = math.Round(ipr_SetWalkSpeed)
        if (ipr_SetWalkSpeed == ipr_PMouseWheel[p].OldWalk) then
            return
        end
        p:SetWalkSpeed(ipr_SetWalkSpeed)

        ipr_PMouseWheel[p].OldWalk = ipr_SetWalkSpeed
        ipr_PMouseWheel[p].WheelCur = ipr_CurTime + 0.4
    end
end)
