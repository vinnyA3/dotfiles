local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
local act = wezterm.action;

-- RESETS / MISC
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.automatically_reload_config = false
-- config.window_background_opacity = 0.93
config.window_background_image = "/home/qwerty_asdf/Pictures/wallpaper/mori-onsen.png"
-- config.window_background_image = "/home/qwerty_asdf/Pictures/wallpaper/FauNNNa_November23_v01.png"
config.window_background_image_hsb = {
  brightness = 0.03,
  saturation = 1.0
}
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.warn_about_missing_glyphs = false -- todo: fix w/ fallback font
config.scrollback_lines = 3000

-- FONTS
config.font = wezterm.font 'Dank Mono'
config.font_size = 14
config.line_height = 1.3

-- COLORS
config.color_scheme = 'Catppuccin Mocha'
-- config.color_scheme = 'rose-pine-moon'
config.colors = {
  background = '#000008'
}

config.inactive_pane_hsb = {
  brightness = 0.2,
}

-- KEYS
--config.debug_key_events = true
config.keys = {
  -- splits
  {
    mods = 'LEADER',
    key = '-',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' }
  },
  {
    mods = 'LEADER | SHIFT',
    key = '_',
    action = act.SplitPane {
      direction = 'Down',
      top_level = true,
    },
  },
  {
    mods = 'LEADER',
    key = '\\',
    action = act.SplitPane {
      direction = 'Right',
      top_level = true,
    },
  },
  {
    mods = 'LEADER | SHIFT',
    key = '|',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }
  },
  {
    key = 'h',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'l',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'k',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'j',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Down',
  },
  {
    key = 'z',
    mods = 'LEADER',
    action = act.TogglePaneZoomState,
  },
  {
    key = 'Space',
    mods = 'LEADER',
    action = act.RotatePanes "Clockwise",
  },
  {
    key = 'x',
    mods = 'LEADER',
    action = act.CloseCurrentPane { confirm = true },
  },
  -- tabs
  {
    key = 'n',
    mods = 'LEADER',
    action = act.ActivateTabRelative(1),
  },
  {
    key = 'p',
    mods = 'LEADER',
    action = act.ActivateTabRelative(-1),
  },
  {
    key = 'c',
    mods = 'LEADER',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'X',
    mods = 'LEADER',
    action = act.CloseCurrentTab { confirm = true },
  },
  {
    key = 't',
    mods = 'LEADER',
    action = act.ShowTabNavigator,
  },
  -- activate copy mode or vim mode
  {
    key = '[',
    mods = 'LEADER',
    action = act.ActivateCopyMode
  },
  -- detach active domain
  {
    key = 'd',
    mods = 'LEADER',
    action = act.DetachDomain 'CurrentPaneDomain',
  },
  -- activate custom resize mode
  {
    key = 'R',
    mods = 'LEADER',
    action = act.ActivateKeyTable { name = "resize_pane", one_shot = false },
  },
}

-- Tab Selection by Index
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = act.ActivateTab(i - 1)
  })
end

config.key_tables = {
  resize_pane = {
    { key = "h", action = act.AdjustPaneSize { "Left", 3 } },
    { key = "j", action = act.AdjustPaneSize { "Down", 3 } },
    { key = "k", action = act.AdjustPaneSize { "Up", 3 } },
    { key = "l", action = act.AdjustPaneSize { "Right", 3 } },
    { key = "Escape", action = "PopKeyTable" },
  }
}

return config
