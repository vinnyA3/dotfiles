import XMonad
import XMonad.Config.Desktop
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Spacing
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig

-- ModKey: Set to Windows Key
modm = mod4Mask
-- TODO: Get these colors from xrdb
backgroundColor   = "#FEFEFE"
middleColor       = "#AEAEAE"
foregroundColor   = "#0E0E0E"

main = do
    xmonad $ desktopConfig
        { borderWidth        = 1
        , focusedBorderColor = foregroundColor
        , focusFollowsMouse  = False
        , layoutHook         = avoidStruts $ spacingWithEdge 8 emptyBSP
        , modMask            = modm 
        , normalBorderColor  = middleColor
        , terminal           = "termite"
        , workspaces         = [ "browse", "code", "read", "chat", "etc" ]
        } `additionalKeys`
        [ ((modm, xK_p), spawn "rofi -show run")
        ] `additionalKeysP`
        [ ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-mute 0 false ; pactl set-sink-volume 0 +5%")
        , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-mute 0 false ; pactl set-sink-volume 0 -5%")
        , ("<XF86AudioMute>", spawn "pactl set-sink-mute 0 toggle")
        , ("<XF86AudioNext>", spawn "playerctl next")
        , ("<XF86AudioPrev>", spawn "playerctl previous")
        , ("<XF86AudioPlay>", spawn "playerctl play-pause")
        ]

