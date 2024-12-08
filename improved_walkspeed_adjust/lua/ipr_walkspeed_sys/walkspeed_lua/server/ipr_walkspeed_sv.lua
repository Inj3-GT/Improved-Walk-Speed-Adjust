--- Script By Inj3
--- https://steamcommunity.com/id/Inj3/
--- https://github.com/Inj3-GT
local ipr_PMouseWheel = {}

local function ipr_CPlayer(p)
    if not ipr_PMouseWheel[p] then
        ipr_PMouseWheel[p] = {}
    end
end

local ipr_SWalkSpeed = {}
ipr_SWalkSpeed.WheelNet = "ipr_swheelsync"
ipr_SWalkSpeed.NetBits = ipr_NumberOfBits(ipr_WalkSpeed_Config.MaxRotation)
ipr_SWalkSpeed.MidRotation = math.Round(ipr_WalkSpeed_Config.MaxRotation / 2)
ipr_SWalkSpeed.MinRotation = 0
ipr_SWalkSpeed.MouseKey = {
    [MOUSE_WHEEL_DOWN] = {k = "d"},
    [MOUSE_WHEEL_UP] = {k = "u"},
}

local function ipr_MGetWheel(p)
    return ipr_PMouseWheel[p].mwheel or ipr_SWalkSpeed.MidRotation
end

local function ipr_MClamp(v, n, x)
    return (v < n) and n or (v > x) and x or v
end

local function ipr_SWheel(p, b)
    if not ipr_PMouseWheel[p].mwheel then
        ipr_PMouseWheel[p].mwheel = ipr_SWalkSpeed.MidRotation
    end
    local ipr_Mkey = (ipr_SWalkSpeed.MouseKey[b].k == "d") and -1 or 1
    ipr_PMouseWheel[p].mwheel = ipr_PMouseWheel[p].mwheel + ipr_Mkey
    local ipr_MConf = ipr_WalkSpeed_Config.MaxRotation
    ipr_PMouseWheel[p].mwheel = ipr_MClamp(ipr_PMouseWheel[p].mwheel, ipr_SWalkSpeed.MinRotation, ipr_MConf)
end

local function ipr_BKeyPress(b, p, k)
    local ipr_MConf = ipr_WalkSpeed_Config.AddKey.key
    if (b == ipr_MConf) then
        ipr_PMouseWheel[p].kpress = k
    end
end

local function ipr_BGetWheel(b, p)
    local ipr_GetKey = ipr_SWalkSpeed.MouseKey[b] and true
    local ipr_MConf = ipr_WalkSpeed_Config.AddKey[1]
    if (ipr_MConf) then
        ipr_CPlayer(p)
        ipr_BKeyPress(b, p, true)
        ipr_GetKey = ipr_PMouseWheel[p].kpress and ipr_GetKey
    end
    return ipr_GetKey
end

local function ipr_SNetWheel(m, p)
    local ipr_MConf = ipr_WalkSpeed_Config.HUD
    if not ipr_MConf then
        return
    end
    net.Start(ipr_SWalkSpeed.WheelNet)
    net.WriteUInt(m, ipr_SWalkSpeed.NetBits)
    net.Send(p)
end

local function ipr_SResetWheel(p)
    if not IsValid(p) then
        return
    end
    ipr_CPlayer(p)
    ipr_PMouseWheel[p].mwheel = ipr_SWalkSpeed.MidRotation
    ipr_SNetWheel(ipr_SWalkSpeed.MidRotation, p)
end

hook.Add("PlayerDisconnected", "ipr_MouseWheel_Logout", function(p)
    if (ipr_PMouseWheel[p]) then
        ipr_PMouseWheel[p] = nil
    end
end)

hook.Add("PlayerInitialSpawn", "ipr_MouseWheel_InitSpawn", function(p)
    local ipr_MConf = ipr_WalkSpeed_Config.SendNotification[1]
    if (ipr_MConf) then
        timer.Simple(7, function()
            if not IsValid(p) then
                return
            end
            local ipr_MPrint = ipr_WalkSpeed_Config.SendNotification.msg
            p:ChatPrint(ipr_MPrint)
        end)
    end
    ipr_SResetWheel(p)
end)

hook.Add("PlayerSpawn", "ipr_MouseWheel_PlayerSpawn", function(p)
    ipr_SResetWheel(p)
end)

hook.Add("PlayerButtonUp", "ipr_MouseWheel_ButtonUp", function(p, b)
    if not IsValid(p) then
        return
    end
    ipr_BKeyPress(b, p, false)
end)

hook.Add("PlayerButtonDown", "ipr_MouseWheel_ButtonDown", function(p, b)
    if not IsValid(p) then
        return
    end
    if not ipr_BGetWheel(b, p) then
        return
    end
    local ipr_WheelCur = CurTime()
    if (ipr_WheelCur > (ipr_PMouseWheel[p].cwheel or 0)) then
        if not p:Alive() then
            return
        end
        ipr_SWheel(p, b)

        local ipr_Mouse_Wheel = ipr_MGetWheel(p)
        local ipr_MConf = ipr_WalkSpeed_Config
        local ipr_WalkSpeed = p:GetWalkSpeed()
        local ipr_WalkSpeed_Max = p:GetRunSpeed()
        local ipr_WalkSpeed_Slow = p:GetSlowWalkSpeed() * ipr_MConf.ReduceSlowWalkSpeed

        ipr_WalkSpeed = ipr_WalkSpeed_Slow + ((ipr_WalkSpeed_Max * ipr_MConf.ReduceRunSpeed - ipr_WalkSpeed_Slow) / (ipr_MConf.MaxRotation - ipr_SWalkSpeed.MinRotation)) * (ipr_Mouse_Wheel - ipr_SWalkSpeed.MinRotation)
        ipr_WalkSpeed = math.Round(ipr_WalkSpeed)
        if (ipr_WalkSpeed == ipr_PMouseWheel[p].nwheel) then
            return
        end
        ipr_PMouseWheel[p].nwheel = ipr_WalkSpeed    
        p:SetWalkSpeed(ipr_WalkSpeed)

        ipr_SNetWheel(ipr_Mouse_Wheel, p)    
        ipr_PMouseWheel[p].cwheel = ipr_WheelCur + 0.3
    end
end)