--- Script By Inj3
--- https://steamcommunity.com/id/Inj3/
--- https://github.com/Inj3-GT
--- Work in progress
ipr_SpeedWheel_Config = {}

ipr_SpeedWheel_Config.MaxRotation = 10 ---  Le nombre de rotations avec la molette de votre souris pour atteindre la vitesse maximale (par défaut : 10). | The number of times you have to roll your mouse wheel to reach maximum speed (default:10).
ipr_SpeedWheel_Config.HUD = true --- Affichage du HUD et synchronisation de l'état (server -> cient) (désactivez-le si vous voulez économiser des performances et éviter d'envoyer des messages réseaux). | Displayed HUD and synchronizes status (Disable it if you want to save performance and avoid sending network messages).
ipr_SpeedWheel_Config.AddKey = {true, --- Désactive automatiquement la molette de la souris du sélecteur d'armes lorsque vous appuyez sur la combinaison de touches KEY_CAPSLOCK + Molette (par défaut) ! | Disabled mouse wheel with weapon selector but only if you press this key combination !
    key = KEY_CAPSLOCK --- Ajoute une touche supplémentaire combinée avec la molette de la souris pour activer la vitesse de marche dynamique. | Add an extra button in combination with the mouse wheel to activate dynamic walk speed.
}

if (SERVER) then
    ipr_SpeedWheel_Config.ReduceRunSpeed = 1 --- Réduit la vitesse de course maximale (mettez 1 si vous ne voulez pas de réduction de vitesse). | Withdraws max running speed (set 1 if you don't want a speed reduction).
    ipr_SpeedWheel_Config.ReduceSlowWalkSpeed = 0.75 --- Réduit la vitesse maximale de marche lente (mettre 1 si vous ne voulez pas de réduction de la vitesse de marche lente). | Withdraws max slow walk speed (set 1 if you don't want a slow walk reduction).
    ipr_SpeedWheel_Config.SendNotification = {true, --- Envoyer une notification | Send a notification
        msg = "Utilisez CAPSLOCK + Molette pour modifier la vitesse de votre personnage."
    }
else
    ipr_SpeedWheel_Config.DisableMWS = false --- Désactive totalement la molette de la souris pour le sélecteur d'armes (vous pouvez toujours utiliser le clavier pour naviguer dans le sélecteur d'armes), si vous souhaitez aussi utiliser uniquement la molette avec cette variable, mettez ipr_SpeedWheel_Config.AddKey en false ! | Disable mouse wheel for weapon selector (you can still use the keyboard to navigate the weapon selector), if you also want to use only the wheel with this variable, set ipr_SpeedWheel_Config.AddKey to false !
    ipr_SpeedWheel_Config.DrawBar = true --- Affiche la barre de progression | Show progress bar
    ipr_SpeedWheel_Config.DrawSpeedPercent = true --- Affiche le pourcentage de vitesse | Display speed percentage
    ipr_SpeedWheel_Config.DrawKey = true --- Affiche les touches | Display keys
    ipr_SpeedWheel_Config.Lang = {
        WalkSpeed = "Vitesse :",
        Key1 = "+ Molette",
        Key2 = "Verr. Maj",
    }
end
