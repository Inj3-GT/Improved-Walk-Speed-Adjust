--- Script By Inj3
--- https://steamcommunity.com/id/Inj3/
--- https://github.com/Inj3-GT
ipr_SpeedWheel_Config = {}
ipr_SpeedWheel_Config.MaxRotation = 10 --- The number of times you have to roll your mouse wheel to reach maximum speed (default:10).
ipr_SpeedWheel_Config.AddKey = {true, --- Disabled mouse wheel with weapon selector but only if you press this key combination !
    key = KEY_CAPSLOCK, --- Add an extra button in combination with the mouse wheel to activate dynamic walk speed.
}

if (SERVER) then
    ipr_SpeedWheel_Config.ReduceRunSpeed = 1 --- Withdraws max running speed (set 1 if you don't want a speed reduction).
    ipr_SpeedWheel_Config.ReduceSlowWalkSpeed = 0.75 --- Withdraws 50% of max slow walk speed (set 1 if you don't want a slow walk reduction).
    ipr_SpeedWheel_Config.SendNotification = {true, --- Send a notification.
        msg = "Use CAPSLOCK + Wheel to change your character's speed.",
    }
else
    ipr_SpeedWheel_Config.DisableMWS = false --- Disable mouse wheel with weapon selector (you can still use the keyboard to navigate the weapon selector), if you also want to use only the wheel with this variable, set ipr_SpeedWheel_Config.AddKey to false !
    ipr_SpeedWheel_Config.HUD = true --- Display hud
end