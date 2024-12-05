ipr_SpeedWheel_Config = {}
ipr_SpeedWheel_Config.MaxRotation = 10 --- The number of times you have to roll your mouse wheel to reach maximum speed.

if (SERVER) then
    ipr_SpeedWheel_Config.ReduceSpeed = 0.95 --- Withdraws 5% of max running speed (set 1 if you don't want a speed reduction).
else
    ipr_SpeedWheel_Config.HUD = true ---Display hud
end