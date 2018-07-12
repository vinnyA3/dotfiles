import XMonad
import XMonad.Actions.FloatKeys
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FloatNext
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Accordion
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral
import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.Run
import Data.Char
import qualified Data.Text as T

-- DefaultTerminal: Set to succless terminal (Alacritty, Termite)
myTerminal = "st -e '/bin/elvish'"

-- Launcher: Set to Dmenu (x: 380)
myLauncher
  = "dmenu_run -l 6 -p '\xf303' -x 8 -y 34 -w 520 -i -fn 'FuraCode Nerd Font-10' -nb '#282A36' -nf '#F8F8F2' -sb '#50FA7B' -sf '#282A36'"

-- ModKey: Set to Windows Key
modm = mod4Mask

-- Border Styling
myBorderWidth = 2

myNormalBorderColor = "#BFBFBF"

myFocusedBorderColor = "#FF79C6"

-- Xmobar dyn colors
xmobarCurrFG = "#282A36"

xmobarCurrBG = "#FF79C6"

xmobarHiddenFG = "#747C84"

-- xmobarStrip = concatMap doubleLts
--  where
--   doubleLts '<' = "<<"
--   doubleLts x   = [x]

workspaceIcons =
  [ "\xe17e"
  , "\xe17f"
  , "\xe180"
  , "\xe181"
  , "\xe182"
  , "\xe183"
  , "\xe184"
  , "\xe185"
  , "\xe186"
  ]

-- My Workspaces
workspaceNames =
  [ "The Hub"
  , "Qutebrowser"
  , "Code"
  , "Firefox"
  , "Chrome"
  , "Media"
  , "Alt7"
  , "Alt8"
  , "Alt9"
  ]

myWorkspaces =
  wrapWorkspaces workspaceIcons . map xmobarStrip $ workspaceNames
 where
  wrapWorkspaces icons workspaces =
    [ "<fn=1>" ++ i ++ "</fn> " ++ ws | (i, ws) <- zip icons workspaces ]


--myWorkspaces   =  map show $ take 9 [1..] 
-- My Layout Hook
myLayout = sizeTall ||| spir ||| Accordion
 where
  sizeTall = ResizableTall 1 (3 / 100) (1 / 2) []
  spir     = spiral (6 / 7)

-- myManageHook
myManageHook = composeAll
  [ className =? "qutebrowser" --> doShift " Qutebrowser"
  , className =? "Spotify" --> doShift " Media"
  , className =? "Firefox" --> doShift " Firefox"
  , className =? "Chromium" --> doShift " Chrome"
  , manageDocks
  ]

-- myNewManageHook   = manageHook desktopConfig <+> manageDocks
myNewManageHook = myManageHook <+> floatNextHook <+> manageHook desktopConfig

splitH s = T.splitOn (T.pack " ") (T.pack s)

splitAndDropFst = tail . splitH

splitAndTakeFst = take 1 . splitH

splitMapJoin fn s = unwords (fmap T.unpack (fn s))

mapPrepend :: String -> String
mapPrepend s = (++) "<fn=1>\xe194</fn> " $ splitMapJoin splitAndDropFst s

main :: IO ()
main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ defaults
    { logHook    = dynamicLogWithPP $ xmobarPP
      { ppOutput  = hPutStrLn xmproc
      , ppCurrent = xmobarColor xmobarCurrBG "" . splitMapJoin splitAndTakeFst
      , ppHidden  = xmobarColor xmobarHiddenFG "" . splitMapJoin splitAndTakeFst
      , ppSep     = " "
      , ppWsSep   = " "
      , ppExtras  = [fmap (fmap mapPrepend) logCurrent]
      , ppTitle   = const ""
      , ppLayout  = const ""
      }
    , manageHook = myNewManageHook
    }

defaults =
  desktopConfig
      { borderWidth        = myBorderWidth
      , normalBorderColor  = myNormalBorderColor
      , focusedBorderColor = myFocusedBorderColor
      , modMask            = modm
      , terminal           = myTerminal
      , workspaces         = myWorkspaces
      , layoutHook         = avoidStruts $ smartBorders $ smartSpacingWithEdge
        8
        myLayout
      }
    `additionalKeys`  [ ((modm, xK_p), spawn myLauncher)
                      , ((modm, xK_z), sendMessage MirrorShrink)
                      , ((modm, xK_a), sendMessage MirrorExpand)
                      , ( (modm, xK_e)
                        , toggleFloatNext
                        )
    -- workspace-snapshots (bash function)
                      , ( (modm .|. shiftMask, xK_p)
                        , spawn "workspace-snapshot"
                        )
                        -- toggle fullscreen float
                      , ( (modm .|. shiftMask, xK_f)
                        , sendMessage ToggleStruts
                        )
    -- floating window keys
                      , ( (modm, xK_d)
                        , withFocused (keysResizeWindow (-10, -10) (1, 1))
                        )
                      , ( (modm, xK_s)
                        , withFocused (keysResizeWindow (10, 10) (1, 1))
                        )
                      , ( (modm .|. shiftMask, xK_d)
                        , withFocused
                          (keysAbsResizeWindow (-10, -10) (1024, 752))
                        )
                      , ( (modm .|. shiftMask, xK_s)
                        , withFocused (keysAbsResizeWindow (10, 10) (1024, 752))
                        )
    --, ((modm, xK_m), withFocused (keysMoveWindowTo (512,384) (1%2,1%2)))
    -- easier keybindings for media keys
                      ]
    `additionalKeysP` [ ( "<XF86AudioRaiseVolume>"
                        , spawn
                          "pactl set-sink-mute @DEFAULT_SINK@ false ; pactl set-sink-volume @DEFAULT_SINK@ +5%"
                        )
                      , ( "<XF86AudioLowerVolume>"
                        , spawn
                          "pactl set-sink-mute @DEFAULT_SINK@ false ; pactl set-sink-volume @DEFAULT_SINK@ -5%"
                        )
                      , ( "<XF86AudioMute>"
                        , spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle"
                        )
                      , ("<XF86AudioNext>", spawn "playerctl next")
                      , ("<XF86AudioPrev>", spawn "playerctl previous")
                      , ("<XF86AudioPlay>", spawn "playerctl play-pause")
                      , ("<XF86AudioStop>", spawn "playerctl stop")
                      ]
