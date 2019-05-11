-- minimal Ubuntu config file: ~/.xmonad/xmonad.hs
import XMonad
-- import XMonad.Hooks.DynamicLog (xmobar)

myConfig = def
  { modMask     = mod4Mask -- set 'Mod' to windows key
  , terminal    = "gnome-terminal" -- for Mod + Shift + Enter
  }

main = do
  -- mobar <- xmobar myConfig
  xmonad myConfig
