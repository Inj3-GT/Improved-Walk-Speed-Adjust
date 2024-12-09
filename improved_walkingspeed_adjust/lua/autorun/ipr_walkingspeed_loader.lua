--- Script By Inj3
--- https://steamcommunity.com/id/Inj3/
--- https://github.com/Inj3-GT
local Ipr_Cf = file.Find("ipr_walkingspeed_sys/configuration/*", "LUA")
local Ipr_Cl = file.Find("ipr_walkingspeed_sys/walkingspeed_lua/client/*", "LUA")
ipr_WalkSpeed_Config = ipr_WalkSpeed_Config or {}

if (SERVER) then
    for _, f in pairs(Ipr_Cf) do
        include("ipr_walkingspeed_sys/configuration/"..f)
        AddCSLuaFile("ipr_walkingspeed_sys/configuration/"..f)
    end
    local Ipr_Sv = file.Find("ipr_walkingspeed_sys/walkingspeed_lua/server/*", "LUA")
    for _, f in pairs(Ipr_Sv) do
        include("ipr_walkingspeed_sys/walkingspeed_lua/server/"..f)
    end
    for _, f in pairs(Ipr_Cl) do
        AddCSLuaFile("ipr_walkingspeed_sys/walkingspeed_lua/client/"..f)
    end
else
    for _, f in pairs(Ipr_Cf) do
        include("ipr_walkingspeed_sys/configuration/"..f)
    end
    for _, f in pairs(Ipr_Cl) do
        include("ipr_walkingspeed_sys/walkingspeed_lua/client/"..f)
    end
end

print("Improved Walking Speed Adjust By Inj3 - Loaded")
