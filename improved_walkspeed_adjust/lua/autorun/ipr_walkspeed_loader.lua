--- Script By Inj3 
--- Script By Inj3 
--- Script By Inj3 
local Ipr_Cf = file.Find("ipr_walkspeed_sys/configuration/*", "LUA")
local Ipr_Cl = file.Find("ipr_walkspeed_sys/walkspeed_lua/client/*", "LUA")
local Ipr_Sh = file.Find("ipr_walkspeed_sys/walkspeed_lua/shared/*", "LUA")
ipr_WalkSpeed_Config = ipr_WalkSpeed_Config or {}

if (SERVER) then
     for _, f in pairs(Ipr_Sh) do
        include("ipr_walkspeed_sys/walkspeed_lua/shared/"..f)
        AddCSLuaFile("ipr_walkspeed_sys/walkspeed_lua/shared/"..f)
     end
     for _, f in pairs(Ipr_Cf) do
         include("ipr_walkspeed_sys/configuration/"..f)
         AddCSLuaFile("ipr_walkspeed_sys/configuration/"..f)
     end

     local Ipr_Sv = file.Find("ipr_walkspeed_sys/walkspeed_lua/server/*", "LUA")
     for _, f in pairs(Ipr_Sv) do
         include("ipr_walkspeed_sys/walkspeed_lua/server/"..f)
     end
     for _, f in pairs(Ipr_Cl) do
         AddCSLuaFile("ipr_walkspeed_sys/walkspeed_lua/client/"..f)
     end
     print("Improved Join/Leave System By Inj3 - Loaded")
 else
     for _, f in pairs(Ipr_Sh) do
        include("ipr_walkspeed_sys/walkspeed_lua/shared/"..f)
     end
     for _, f in pairs(Ipr_Cf) do
         include("ipr_walkspeed_sys/configuration/"..f)
     end
     for _, f in pairs(Ipr_Cl) do
         include("ipr_walkspeed_sys/walkspeed_lua/client/"..f)
     end
end