import XMonad
import XMonad.Config.Desktop
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.ResizableTile
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run
import XMonad.Util.Loggers
import XMonad.Util.EZConfig
import Data.Char

-- DefaultTerminal: Set to Termite
myTerminal     = "alacritty"

-- Launcher: Set to Dmenu
myLauncher     = "dmenu_run -p '\xf00e' -x 380 -y 9 -W 620 -i -fn 'Noto Sans UI-10' -nb '#282A36' -nf '#F8F8F2' -sb '#50FA7B' -sf '#282A36'"

-- ModKey: Set to Windows Key
modm           = mod4Mask

-- Border Styling
myBorderWidth  = 1

myNormalBorderColor = "#BFBFBF"

myFocusedBorderColor = "#FF79C6"

-- Xmobar dyn colors
xmobarCurrFG  = "#282A36"

xmobarCurrBG = "#FF79C6"

xmobarHiddenFG = "#747C84"

-- My Workspaces
myWorkspaces = [ "Terminal"
                  ,"Qutebrowser"
                  ,"Code"
                  ,"Firefox"
                  ,"Media"
                  ,"Misc"
                  ,"Alt7"
                  ,"Alt8"
                  ,"Alt9" ]

--myWorkspaces   =  map show $ take 9 [1..] 

-- My Layout Hook
myLayout = avoidStruts $ smartBorders $ smartSpacingWithEdge 8 $ ResizableTall 1 (3/100) (1/2) []

-- myManageHook
myManageHook = composeAll
    [ className =? "Chromium" --> doShift "2  \xf268  "
    , className =? "Spotify"  --> doShift "4  \xf1bc  "
    , className =? "Firefox"  --> doShift "5  \xf269  "
    , manageDocks ]

-- myNewManageHook   = manageHook desktopConfig <+> manageDocks
myNewManageHook   = myManageHook <+> manageHook desktopConfig

tagL l = onLogger $ wrap(l ++ " :: ") ""

main :: IO ()

main = do
    xmproc <- spawnPipe "xmobar > /dev/null 2>&1"
    xmonad $ defaults {
        logHook      = dynamicLogWithPP $ xmobarPP {
            ppOutput    = hPutStrLn xmproc
            , ppCurrent = xmobarColor "" xmobarCurrBG . shorten 4 
            , ppHidden  = xmobarColor "" xmobarHiddenFG . shorten 4 
            , ppSep = "   " 
            , ppWsSep = "   "
            , ppExtras = [fmap (\m -> fmap (\s -> "\xf178  " ++ s) m) $ logCurrent]
            , ppTitle   = (\str -> "")
            , ppLayout  = (\str -> "")
        }
        , manageHook = myNewManageHook
    }

defaults = desktopConfig
    { borderWidth = myBorderWidth 
    , normalBorderColor = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    , modMask     = modm 
    , terminal    = myTerminal 
    , workspaces  = myWorkspaces
    , layoutHook  = myLayout
    } `additionalKeys`
    [ ((modm, xK_p), spawn myLauncher)
    , ((modm, xK_a), sendMessage MirrorShrink)
    , ((modm, xK_z), sendMessage MirrorExpand)
    ] `additionalKeysP`
    [ ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-mute @DEFAULT_SINK@ false ; pactl set-sink-volume @DEFAULT_SINK@ +5%")
    , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-mute @DEFAULT_SINK@ false ; pactl set-sink-volume @DEFAULT_SINK@ -5%")
    , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    , ("<XF86AudioNext>", spawn "playerctl next")
    , ("<XF86AudioPrev>", spawn "playerctl previous")
    , ("<XF86AudioPlay>", spawn "playerctl play-pause")
    , ("<XF86AudioStop>", spawn "playerctl stop")
    ]

