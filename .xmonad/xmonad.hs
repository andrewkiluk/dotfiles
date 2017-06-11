import XMonad

import XMonad.Actions.CycleWS (prevWS, nextWS, shiftToNext, shiftToPrev)

import XMonad.Config.Desktop (desktopConfig)

import XMonad.Hooks.ManageDocks(avoidStruts, docksEventHook)
import XMonad.Hooks.DynamicLog 
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhDesktopsEventHook)

import XMonad.Layout.Tabbed
import XMonad.Layout.Circle
import XMonad.Layout.Spacing (smartSpacing)
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.Fullscreen (fullscreenSupport)
import XMonad.Layout.Gaps (gaps)
import XMonad.Layout.SubLayouts 
import XMonad.Layout.WindowNavigation
import XMonad.Layout.Simplest
import XMonad.Layout.Accordion
import XMonad.Layout.ResizableTile
import XMonad.Layout.ThreeColumns
import XMonad.Layout.PerScreen (ifWider)
import XMonad.Layout.BoringWindows (focusUp, focusDown, focusMaster, boringWindows)
import XMonad.Layout.MultiToggle 
import XMonad.Layout.MultiToggle.Instances

-- import qualified XMonad.StackSet as W (focusUp, focusDown)

import XMonad.Util.EZConfig ( additionalKeys )
import XMonad.Util.Run(spawnPipe)

import System.IO(hPutStrLn)

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8

main = do
    dbus <- D.connectSession
    -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log") [ D.nameAllowReplacement
                                                     , D.nameReplaceExisting
                                                     , D.nameDoNotQueue
                                                     ]
    xmonad . ewmh . fullscreenSupport $ desktopConfig
            { borderWidth        = border
            , focusFollowsMouse  = False
            , clickJustFocuses   = False
            , handleEventHook    = docksEventHook <+> ewmhDesktopsEventHook
            , normalBorderColor  = myNormalBorderColor
            , focusedBorderColor = myFocusedBorderColor
            , modMask            = myModMask
            , terminal           = "urxvt"
            , layoutHook         = myLayout
            , workspaces         = myWorkspaces
            , logHook            = dynamicLogWithPP $ myDbusHook dbus
            , startupHook        = spawn "polybar-restart"
            } `additionalKeys` myKeys

myModMask = mod4Mask

myWorkspaces = map show [1..9]


-- ------------
--  Layouts
-- ------------

fullScreenToggle    = mkToggle (single FULL)

myLayout = boringWindows $ 
           fullScreenToggle $ 
                tiled ||| flex
    where
        -- default tiling algorithm partitions the screen into two panes
        tiled   = smartBorders 
                   . addTopBar 
                   . avoidStruts 
                   . smartSpacing gap 
                   $ Tall nmaster delta ratio

        -- The default number of windows in the master pane
        nmaster = 1

        -- Default proportion of screen occupied by master pane
        ratio   = 1/2

        -- Percent of screen to increment by when resizing panes
        delta   = 2/100

        smallMonResWidth    = 1920

        flex = avoidStruts
              -- don't forget: even though we are using X.A.Navigation2D
              -- we need windowNavigation for merging to sublayouts
              $ windowNavigation
              $ addTopBar
              $ addTabs shrinkText myTabTheme
              $ subLayout [] (Simplest ||| Accordion)
              $ ifWider smallMonResWidth wideLayouts standardLayouts
              where
                  wideLayouts = smartSpacing gap $ (ThreeColMid 1 (1/20) (1/2))
                  standardLayouts = smartSpacing gap $ (ResizableTall 1 (1/20) (1/2) [])


        addTopBar = noFrillsDeco shrinkText topBarTheme

myKeys = 
    [
    -- Swap the focused window with the next window
      ((myModMask .|. shiftMask, xK_m             ), windows W.swapMaster  )
    -- Close with Super + W
    , ((myModMask              , xK_w             ), kill  )
    -- Go left a workspace
    , ((myModMask,               xK_bracketleft   ), prevWS)
    -- Go right a workspace
    , ((myModMask,               xK_bracketright  ), nextWS)
    -- Move window left a workspace
    , ((myModMask .|. shiftMask, xK_bracketleft   ), sequence_ [shiftToPrev, prevWS])
    -- Move window right a workspace
    , ((myModMask .|. shiftMask, xK_bracketright  ), sequence_ [shiftToNext, nextWS])
    -- Merge / unmerge tabs
    , ((myModMask .|. controlMask, xK_j           ), sendMessage $ pullGroup D )
    , ((myModMask .|. controlMask, xK_k           ), sendMessage $ pullGroup U )
    , ((myModMask .|. controlMask, xK_g           ), withFocused $ sendMessage . UnMerge )
    -- Switch tabs in sublayout
    , ((controlMask, xK_bracketleft               ), onGroup W.focusUp')
    , ((controlMask, xK_bracketright              ), onGroup W.focusDown')
    , ((myModMask .|. controlMask, xK_Tab         ), toSubl NextLayout)
    -- Tabbed-friendly versions of focusing operations that work with boringWindows
    , ((myModMask, xK_j), focusDown)
    , ((myModMask, xK_k), focusUp)
    , ((myModMask, xK_m), focusMaster)
    , ((myModMask, xK_f), sequence_ [ (withFocused $ windows . W.sink), sendMessage $ Toggle FULL])
    ]

myDbusHook :: D.Client -> PP
myDbusHook dbus = def
    { ppOutput = dbusOutput dbus
    , ppCurrent = wrap ("%{u" ++ green ++ " B" ++ bg ++ " +u}  ") "  %{B- u- -u}"
    , ppVisible = wrap ("%{u" ++ yellow ++ " +u}  ") "  %{u- -u}"
    , ppUrgent = wrap ("%{u" ++ red ++ " +u}  ") "  %{u- -u}"
    , ppHidden = wrap "  " "  "
    , ppWsSep = ""
    , ppSep = " : "
    , ppTitle = shorten 50
    , ppOrder   = (\(ws:_:_:_) -> [ws])
    }

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal = (D.signal objectPath interfaceName memberName) {
            D.signalBody = [D.toVariant $ UTF8.decodeString str]
        }
    D.emit dbus signal
  where
    objectPath = D.objectPath_ "/org/xmonad/Log"
    interfaceName = D.interfaceName_ "org.xmonad.Log"
    memberName = D.memberName_ "Update"

------------------------------------------------------------------------}}}
-- Theme                                                                {{{
---------------------------------------------------------------------------

base03  = "#002b36"
base02  = "#073642"
base01  = "#586e75"
base00  = "#657b83"
base0   = "#839496"
base1   = "#93a1a1"
base2   = "#eee8d5"
base3   = "#fdf6e3"
yellow  = "#b58900"
orange  = "#cb4b16"
red     = "#dc322f"
magenta = "#d33682"
violet  = "#6c71c4"
blue    = "#268bd2"
cyan    = "#2aa198"
green   = "#859900"
bg      = "#33666666"

-- sizes
gap         = 10
topbar      = 10
border      = 0
prompt      = 20
status      = 20

myNormalBorderColor     = "#000000"
myFocusedBorderColor    = active

active      = blue
activeWarn  = red
inactive    = base02
focusColor  = blue
unfocusColor = base02

myFont      = "-*-terminus-medium-*-*-*-*-160-*-*-*-*-*-*"
myBigFont   = "-*-terminus-medium-*-*-*-*-240-*-*-*-*-*-*"
myWideFont  = "xft:Eurostar Black Extended:"
            ++ "style=Regular:pixelsize=180:hinting=true"

-- this is a "fake title" used as a highlight bar in lieu of full borders
-- (I find this a cleaner and less visually intrusive solution)
topBarTheme = def
    { fontName              = myFont
    , inactiveBorderColor   = base03
    , inactiveColor         = base03
    , inactiveTextColor     = base03
    , activeBorderColor     = active
    , activeColor           = active
    , activeTextColor       = active
    , urgentBorderColor     = red
    , urgentTextColor       = yellow
    , decoHeight            = topbar
    }

myTabTheme = def
    { fontName              = myFont
    , activeColor           = active
    , inactiveColor         = base02
    , activeBorderColor     = active
    , inactiveBorderColor   = base02
    , activeTextColor       = base03
    , inactiveTextColor     = base00
    }

-- myPromptTheme = def
--     { font                  = myFont
--     , bgColor               = base03
--     , fgColor               = active
--     , fgHLight              = base03
--     , bgHLight              = active
--     , borderColor           = base03
--     , promptBorderWidth     = 0
--     , height                = prompt
--     , position              = Top
--     }

-- warmPromptTheme = myPromptTheme
--     { bgColor               = yellow
--     , fgColor               = base03
--     , position              = Top
--     }

-- hotPromptTheme = myPromptTheme
--     { bgColor               = red
--     , fgColor               = base3
--     , position              = Top
--     }

-- myShowWNameTheme = def
--     { swn_font              = myWideFont
--     , swn_fade              = 0.5
--     , swn_bgcolor           = "#000000"
--     , swn_color             = "#FFFFFF"
--     }
