local ipr_SpeedWheel = {}
ipr_SpeedWheel.NetBits = ipr_NumberOfBits(ipr_SpeedWheel_Config.MaxRotation)
ipr_SpeedWheel.Rotation = 0

net.Receive("ipr_swheelsync", function()
    ipr_SpeedWheel.Rotation = net.ReadUInt(ipr_SpeedWheel.NetBits)
end)

ipr_SpeedWheel.FontHUD = "HudSelectionText"
ipr_SpeedWheel.ScrW = ScrW()
ipr_SpeedWheel.ScrH = ScrH()

local function ipr_Draw_WalkSpeed()
    if not ipr_SpeedWheel_Config.HUD then
        return
    end
    draw.SimpleTextOutlined("Vitesse de marche : " ..ipr_SpeedWheel.Rotation.. "/" ..ipr_SpeedWheel_Config.MaxRotation, ipr_SpeedWheel.FontHUD, ipr_SpeedWheel.ScrW / 2, ipr_SpeedWheel.ScrH - 15, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_white)
end
hook.Add("HUDPaint", "ipr_Draw_WalkSpeed", ipr_Draw_WalkSpeed)