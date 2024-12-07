--- Script By Inj3
--- https://steamcommunity.com/id/Inj3/
--- https://github.com/Inj3-GT
local ipr_SpeedWheel, ipr_SpWheel = {}, {}
ipr_SpeedWheel.NetBits = ipr_NumberOfBits(ipr_SpeedWheel_Config.MaxRotation)
ipr_SpeedWheel.MaxRotation = ipr_SpeedWheel_Config.MaxRotation 
ipr_SpeedWheel.ReduceRunSpeed = ipr_SpeedWheel_Config.ReduceRunSpeed
ipr_SpeedWheel.MidRotation = math.Round(ipr_SpeedWheel_Config.MaxRotation / 2)
ipr_SpeedWheel.MinRotation = 0
ipr_SpeedWheel.WheelNet = "ipr_swheelsync"
ipr_SpeedWheel.MouseKey = {
    [MOUSE_WHEEL_DOWN] = {k = "d"},
    [MOUSE_WHEEL_UP] = {k = "u"},
}

local function ipr_CPlayer(p)
    if not ipr_SpWheel[p] then
        ipr_SpWheel[p] = {}
    end
end

local function ipr_MGetWheel(p)
    return ipr_SpWheel[p].mwheel or ipr_SpeedWheel.MidRotation
end

local function ipr_MClamp(v, n, x)
    return (v < n) and n or (v > x) and x or v
end

local function ipr_SWheel(p, b)
    if not ipr_SpWheel[p].mwheel then
        ipr_SpWheel[p].mwheel = ipr_SpeedWheel.MidRotation
    end
    local ipr_Mkey = (ipr_SpeedWheel.MouseKey[b].k == "d") and -1 or 1
    ipr_SpWheel[p].mwheel = ipr_SpWheel[p].mwheel + ipr_Mkey
    ipr_SpWheel[p].mwheel = ipr_MClamp(ipr_SpWheel[p].mwheel, ipr_SpeedWheel.MinRotation, ipr_SpeedWheel.MaxRotation)
end

local function ipr_BKeyPress(b, p, k)
    local ipr_MKey = ipr_SpeedWheel_Config.AddKey.key
    if (b == ipr_MKey) then
        ipr_SpWheel[p].kpress = k
    end
end

local function ipr_BGetWheel(b, p)
    local ipr_GetKey = ipr_SpeedWheel.MouseKey[b] and true
    local ipr_MKey = ipr_SpeedWheel_Config.AddKey[1]
    if (ipr_MKey) then
        ipr_CPlayer(p)
        ipr_BKeyPress(b, p, true)
        ipr_GetKey = ipr_SpWheel[p].kpress and ipr_GetKey
    end
    return ipr_GetKey
end

local function ipr_SNetWheel(m, p)
    net.Start(ipr_SpeedWheel.WheelNet)
    net.WriteUInt(m, ipr_SpeedWheel.NetBits)
    net.Send(p)
end

local function ipr_SResetWheel(p)
    if not IsValid(p) then
        return
    end
    ipr_CPlayer(p)
    ipr_SpWheel[p].mwheel = ipr_SpeedWheel.MidRotation
    ipr_SNetWheel(ipr_SpeedWheel.MidRotation, p)
end

hook.Add("PlayerDisconnected", "ipr_MouseWheel_Logout", function(p)
    if (ipr_SpWheel[p]) then
        ipr_SpWheel[p] = nil
    end
end)

hook.Add("PlayerInitialSpawn", "ipr_MouseWheel_InitSpawn", function(p)
    local ipr_MNotif = ipr_SpeedWheel_Config.SendNotification[1]
    if (ipr_MNotif) then
        timer.Simple(7, function()
            if not IsValid(p) then
                return
            end
            local ipr_MPrint = ipr_SpeedWheel_Config.SendNotification.msg
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

local ipr_MSpeed = ipr_SpeedWheel_Config.ReduceSlowWalkSpeed
hook.Add("PlayerButtonDown", "ipr_MouseWheel_ButtonDown", function(p, b)
    if not IsValid(p) then
        return
    end
    if not ipr_BGetWheel(b, p) then
        return
    end
    local ipr_WheelCur = CurTime()
    if (ipr_WheelCur > (ipr_SpWheel[p].cwheel or 0)) then
        if not p:Alive() then
            return
        end
        ipr_SWheel(p, b)

        local ipr_Mouse_Wheel = ipr_MGetWheel(p)
        local ipr_WalkSpeed = p:GetWalkSpeed()
        local ipr_WalkSpeed_Max = p:GetRunSpeed()
        local ipr_WalkSpeed_Slow = p:GetSlowWalkSpeed() * ipr_MSpeed

        ipr_WalkSpeed = ipr_WalkSpeed_Slow + ((ipr_WalkSpeed_Max * ipr_SpeedWheel.ReduceRunSpeed - ipr_WalkSpeed_Slow) / (ipr_SpeedWheel.MaxRotation - ipr_SpeedWheel.MinRotation)) * (ipr_Mouse_Wheel - ipr_SpeedWheel.MinRotation)
        ipr_WalkSpeed = math.Round(ipr_WalkSpeed)
        if (ipr_WalkSpeed == ipr_SpWheel[p].nwheel) then
            return
        end
        ipr_SpWheel[p].nwheel = ipr_WalkSpeed
        ipr_SpWheel[p].cwheel = ipr_WheelCur + 0.3
        
        p:SetWalkSpeed(ipr_WalkSpeed)
        ipr_SNetWheel(ipr_Mouse_Wheel, p)
    end
end)