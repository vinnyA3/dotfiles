import System.IO
import System.Exit

import XMonad
import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.CycleWS
import XMonad.Actions.FloatKeys
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FloatNext
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Util.NamedScratchpad
import XMonad.Layout
import XMonad.Layout.Accordion
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral
import XMonad.Util.Loggers
import XMonad.Util.Font
import XMonad.Util.Run
import Graphics.X11.ExtraTypes.XF86

import Data.Char
import Data.Bits ((.|.))
import qualified XMonad.StackSet as W
import qualified Data.Map as M
-- import qualified Data.Text as T

-- DefaultTerminal: Set to succless terminal (Alacritty, Termite)
myTerminal = "st -e '/run/current-system/sw/bin/elvish'"
-- myTerminal = "xterm"

-- Launcher: Set to Rofi (x: 380)
myLauncher = "rofi -show drun"

-- ModKey: Set to Windows Key
modm = mod4Mask

-- Border Styling
myBorderWidth = 3

myNormalBorderColor = "#BFBFBF"

myFocusedBorderColor = "#CAA9FA"

xmproc = "xmobar ~/.config/xmobar/xmobarrc.hs"

-- Xmobar dyn colors
xmobarCurrFG = "#282A36"

xmobarCurrBG = "#FF79C6"

xmobarHiddenFG = "#747C84"

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
  [ "Main"
  , "Qutebrowser"
  , "Code"
  , "Firefox"
  , "Chrome"
  , "Media"
  , "Misc7"
  , "Misc8"
  , "Misc9"
  ]

myWorkspaces = wrapWorkspaces workspaceIcons $ workspaceNames
 where
  wrapWorkspaces icons workspaces =
    [ "<fn=1>" ++ i ++ "</fn> " ++ ws | (i, ws) <- zip icons workspaces ]

-- Layout Hook
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
  ]

scratchpads =
  [ NS "htop" "st -t process -e htop" (title =? "process")  defaultFloating
  , NS "chat" "st -t chat -e weechat"    (title =? "chat") defaultFloating
  , NS "cmus" "st -c cmus -e cmus"    (className =? "cmus") defaultFloating
  ]

myNewManageHook = composeAll
  [ myManageHook
  , floatNextHook
  , manageHook desktopConfig
  , namedScratchpadManageHook scratchpads
  ]


myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig { XMonad.modMask = modMask }) =
  M.fromList
    $  [ ((modm .|. shiftMask, xK_Return), spawn myTerminal)
       , ((modm, xK_p)                   , spawn myLauncher)
       , ((modm, xK_Tab)                 , nextWS)
       , ((modm .|. shiftMask, xK_Tab)   , prevWS)
       , ( (modm .|. controlMask .|. shiftMask, xK_t)
         , namedScratchpadAction scratchpads "htop"
         )
       , ( (modm .|. controlMask .|. shiftMask, xK_c)
         , namedScratchpadAction scratchpads "cmus"
         )
       , ((modm .|. controlMask .|. shiftMask, xK_w), namedScratchpadAction scratchpads "chat"
       -- audio keybindings
       , ( (0, xF86XK_AudioRaiseVolume)
         , spawn
           "pactl set-sink-mute @DEFAULT_SINK@ false ; pactl set-sink-volume @DEFAULT_SINK@ +5%"
         )
       , ( (0, xF86XK_AudioLowerVolume)
         , spawn
           "pactl set-sink-mute @DEFAULT_SINK@ false ; pactl set-sink-volume @DEFAULT_SINK@ -5%"
         )
       , ((0, xF86XK_AudioNext), spawn "playerctl next")
       , ((0, xF86XK_AudioPrev), spawn "playerctl previous")
       , ((0, xF86XK_AudioPlay), spawn "playerctl play-pause")
       , ((0, xF86XK_AudioStop), spawn "playerctl stop")
       , ( (0, xF86XK_AudioMute)
         , spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle"
         )
       , ( (modm, xK_j)
         , windows W.focusDown
         ) -- %! Move focus to the next window
       , ((modm, xK_k), windows W.focusUp)
       , ( (modm, xK_comma)
         , sendMessage (IncMasterN 1)
         ) -- %! Increment the number of windows in the master area
       , ( (modm, xK_period)
         , sendMessage (IncMasterN (-1))
         ) -- %! Deincrement the number of windows in the master area
       , ( (modm, xK_space)
         , sendMessage NextLayout
         ) -- %! Rotate through the available layout algorithms
       , ( (modm .|. shiftMask, xK_space)
         , setLayout $ XMonad.layoutHook conf
         ) -- %!  Reset the layouts on the current workspace to default
       , ( (modMask, xK_space)
         , sendMessage NextLayout
         ) -- %! Rotate through the available layout algorithms
       , ( (modMask .|. shiftMask, xK_space)
         , setLayout $ XMonad.layoutHook conf
         ) -- %!  Reset the layouts on the current workspace to default
       , ( (mod4Mask, xK_comma)
         , sendMessage (IncMasterN 1)
         ) -- %! Increment the number of windows in the master area
       , ( (mod4Mask, xK_period)
         , sendMessage (IncMasterN (-1))
         ) -- %! Deincrement the number of windows in the master area
       , ( (mod4Mask, xK_t)
         , withFocused $ windows . W.sink
         ) -- %! Push window back into tiling
       , ( (mod4Mask, xK_h)
         , sendMessage Shrink
         ) -- %! Shrink the master area
       , ( (mod4Mask, xK_l)
         , sendMessage Expand
         ) -- %! Expand the master area
       , ( (mod4Mask, xK_Return)
         , windows W.swapMaster
         ) -- %! Swap the focused window and the master window
       , ( (mod4Mask .|. shiftMask, xK_j)
         , windows W.swapDown
         ) -- %! Swap the focused window with the next window
       , ( (mod4Mask .|. shiftMask, xK_k)
         , windows W.swapUp
         ) -- %! Swap the focused window with the previous window
        -- , ((mod4Mask              , xK_m     ), windows W.focusMaster  ) -- %! Move focus to the master window
       , ( (mod4Mask .|. shiftMask, xK_c)
         , kill
         ) -- %! Close the focused window
                        -- Quit xmonad.
       , ((modMask .|. shiftMask, xK_q), io (exitWith ExitSuccess))
       , ( (mod4Mask, xK_q)
         , broadcastMessage ReleaseResources >> restart "xmonad" True
         ) -- %! Restart xmonad
       , ( (modm .|. shiftMask, xK_x)
         , spawn "kill $(pidof xmobar); xmobar ~/.config/xmobar/xmobarrc.hs"
         ) -- %! Kill & restart xmobar
       , ((modm, xK_z)              , sendMessage MirrorShrink)
       , ((modm, xK_a)              , sendMessage MirrorExpand)
       , ((modm, xK_e)              , toggleFloatNext)
       , ((modm .|. shiftMask, xK_e), toggleFloatAllNew)
       , ( (modm .|. shiftMask, xK_p)
         , spawn "scrot '%Y-%m-%d_$wx$h.png' -c -d 5"
         )
                        -- toggle fullscreen (really just lower status bar
                        --    below everything)
       , ((modm .|. shiftMask, xK_f), sendMessage ToggleStruts)
                      -- floating window keys
       -- , ((modm .|. shiftMask, xK_Up), withFocused (keysMoveWindow (0, -10)))
       -- , ((modm .|. shiftMask, xK_Down), withFocused (keysMoveWindow (0, 10)))
       -- , ((modm .|. shiftMask, xK_Right), withFocused (keysMoveWindow (10, 0)))
       -- , ((modm .|. shiftMask, xK_Left), withFocused (keysMoveWindow (-10, 0)))
       -- , ((modm, xK_d), withFocused (keysResizeWindow (-10, -10) (0, 1)))
       -- , ((modm, xK_s), withFocused (keysResizeWindow (10, 10) (0, 1)))
       ]
    ++ [ ((m .|. modMask, k), windows $ f i) -- mod-[1..9], Switch to workspace N
       | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9] -- mod-shift-[1..9], Move client to workspace N
       , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
       ]

-- my TEXT manipulation functions ... no longer of use, but might
--    come in handy later, so leaving here ....
-- splitH s = T.splitOn (T.pack " ") (T.pack s)
-- splitAndDropFst = tail . splitH
-- splitAndTakeFst = take 1 . splitH
-- splitMapJoin fn s = unwords (fmap T.unpack (fn s))

splitTakeFst = head . words

splitTakeLst = last . words

prependIcon = (++) "<fn=1>\xe194</fn> " . splitTakeLst

prependWSLogger = fmap prependIcon <$> logCurrent

-- getShortenedLayout = fmap splitTakeLst <$> logLayout

myXmobarPP = def { ppCurrent = xmobarColor xmobarCurrBG "" . splitTakeFst
                 , ppHidden  = xmobarColor xmobarHiddenFG "" . splitTakeFst
                 , ppSep     = " "
                 , ppWsSep   = " "
                 , ppExtras  = [prependWSLogger]
                 , ppTitle   = const ""
                 , ppLayout  = const ""
                 }

main :: IO ()
main = do
  spawn xmproc
  xmonad $ defaults { logHook = dynamicLogString myXmobarPP >>= xmonadPropLog }

defaults = docks $ desktopConfig
  { borderWidth        = myBorderWidth
  , normalBorderColor  = myNormalBorderColor
  , focusedBorderColor = myFocusedBorderColor
  , modMask            = modm
  , terminal           = myTerminal
  , workspaces         = myWorkspaces
  , keys               = myKeys
  , manageHook         = myNewManageHook
  , layoutHook = avoidStruts $ smartBorders $ smartSpacingWithEdge 8 $ myLayout
  , startupHook        = spawn
    "feh --bg-scale /home/qwerty/Pictures/wallpaper/geometry-dracula.png"
  }

