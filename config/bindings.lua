local wezterm = require("wezterm")
local platform = require("utils.platform")()
local backdrops = require("utils.backdrops")
local act = wezterm.action

local mod = {}

if platform.is_mac then
	mod.SUPER = "SUPER"
	mod.SUPER_REV = "SUPER|CTRL"
elseif platform.is_win or platform.is_linux then
	-- mod.SUPER = "ALT" -- to not conflict with Windows key shortcuts
	mod.SUPER = "CTRL"
	mod.SUPER_REV = "ALT|CTRL"
end

-- stylua: ignore
local keys = {
   -- misc/useful --
   -- { key = 'F1', mods = 'NONE', action = 'ActivateCopyMode' },
   -- { key = 'F2', mods = 'NONE', action = act.ActivateCommandPalette },
   -- { key = 'F3', mods = 'NONE', action = act.ShowLauncher },
   -- { key = 'F4', mods = 'NONE', action = act.ShowLauncherArgs({ flags = 'FUZZY|TABS' }) },
   -- {
   --    key = 'F5',
   --    mods = 'NONE',
   --    action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }),
   -- },
   { key = 'F11', mods = 'NONE',    action = act.ToggleFullScreen },
   -- { key = 'F12', mods = 'NONE',    action = act.ShowDebugOverlay },
   { key = 'f', mods = mod.SUPER_REV, action = act.Search({ CaseInSensitiveString = '' }) }, -- 搜索
   {
      key = 'u',
      mods = mod.SUPER_REV,
      action = wezterm.action.QuickSelectArgs({
         label = 'open url',
         patterns = {
            '\\((https?://\\S+)\\)',
            '\\[(https?://\\S+)\\]',
            '\\{(https?://\\S+)\\}',
            '<(https?://\\S+)>',
            '\\bhttps?://\\S+[)/a-zA-Z0-9-]+'
         },
         action = wezterm.action_callback(function(window, pane)
            local url = window:get_selection_text_for_pane(pane)
            wezterm.log_info('opening: ' .. url)
            wezterm.open_with(url)
         end),
      }),
   },

   -- cursor movement --
   -- { key = 'LeftArrow',  mods = mod.SUPER,     action = act.SendString '\x1bOH' },
   -- { key = 'RightArrow', mods = mod.SUPER,     action = act.SendString '\x1bOF' },
   -- { key = 'Backspace',  mods = mod.SUPER,     action = act.SendString '\x15' },

   -- copy/paste --
   -- { key = 'c',          mods = 'CTRL|SHIFT',  action = act.CopyTo('Clipboard') },
   -- { key = 'v',          mods = 'CTRL|SHIFT',  action = act.PasteFrom('Clipboard') },
   -- { key = 'Insert',     mods = 'SHIFT',       action = act.PasteFrom('PrimarySelection') },

   -- tabs --
   -- tabs: spawn+close
   -- { key = 'Enter',      mods = mod.SUPER,     action = act.SpawnTab('DefaultDomain') },
   { key = 't', mods = mod.SUPER,     action = act.SpawnTab('DefaultDomain') }, -- 打开一个新标签页
   -- { key = 'w', mods = mod.SUPER,     action = act.CloseCurrentTab({ confirm = false }) },

   -- tabs: navigation
   { key = 'h', mods = mod.SUPER,     action = act.ActivateTabRelative(-1) }, -- 切换上一个标签页
   { key = 'l', mods = mod.SUPER,     action = act.ActivateTabRelative(1) }, -- 切换下一个标签页
   -- { key = 'h', mods = mod.SUPER_REV, action = act.MoveTabRelative(-1) },
   -- { key = 'l', mods = mod.SUPER_REV, action = act.MoveTabRelative(1) },

   -- window --
   -- spawn windows
   { key = 'n', mods = 'CTRL|SHIFT',     action = act.SpawnWindow }, -- 打开一个新窗口

   -- background controls --
   {
      key = [[/]],
      mods = mod.SUPER_REV,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:random(window)
      end),
   }, -- 随机切换一张背景
   {
      key = [[,]],
      mods = mod.SUPER_REV,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:cycle_back(window)
      end),
   }, -- 切换上一张背景
   {
      key = [[.]],
      mods = mod.SUPER_REV,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:cycle_forward(window)
      end),
   }, -- 切换下一张背景
   -- {
   --    key = [[/]],
   --    mods = mod.SUPER_REV,
   --    action = act.InputSelector({
   --       title = 'Select Background',
   --       choices = backdrops:choices(),
   --       fuzzy = true,
   --       fuzzy_description = 'Select Background: ',
   --       action = wezterm.action_callback(function(window, _pane, idx)
   --          ---@diagnostic disable-next-line: param-type-mismatch
   --          backdrops:set_img(window, tonumber(idx))
   --       end),
   --    }),
   -- }, -- 选择背景图片

   -- panes --
   -- panes: split panes
   {
      key = [[\]],
      mods = mod.SUPER,
      action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
   }, -- 垂直方向打开一个pane
   {
      key = [[\]],
      mods = mod.SUPER_REV,
      action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
   }, -- 水平方向打开一个pane

   -- panes: zoom+close pane
   { key = 'Enter', mods = mod.SUPER,     action = act.TogglePaneZoomState },                   -- 切换当前pane的大小
   { key = 'w',     mods = mod.SUPER,     action = act.CloseCurrentPane({ confirm = false }) }, -- 关闭当前pane

   -- panes: navigation
   { key = 'k',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Up') },
   { key = 'j',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Down') },
   { key = 'h',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Left') },
   { key = 'l',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Right') },
   {
      key = 'p',
      mods = mod.SUPER_REV,
      action = act.PaneSelect({ alphabet = '1234567890', mode = 'SwapWithActiveKeepFocus' }),
   }, -- 显示pane序号,并通过1234567890切换

   -- scrollback
   { key = 'PageUp',   mods = 'SHIFT',   action = act.ScrollByPage(-0.5) },
   { key = 'PageDown', mods = 'SHIFT',   action = act.ScrollByPage(0.5) },

   -- fonts: resize
   { key = '=',        mods = mod.SUPER, action = act.IncreaseFontSize },
   { key = '-',        mods = mod.SUPER, action = act.DecreaseFontSize },
   { key = '0',        mods = mod.SUPER, action = act.ResetFontSize },

   -- key-tables --
   -- resizes fonts
   {
      key = 'f',
      mods = 'LEADER',
      action = act.ActivateKeyTable({
         name = 'resize_font',
         one_shot = false,
         timemout_miliseconds = 1000,
      }),
   },
   -- resize panes
   {
      key = 'p',
      mods = 'LEADER',
      action = act.ActivateKeyTable({
         name = 'resize_pane',
         one_shot = false,
         timemout_miliseconds = 1000,
      }),
   },
}

-- stylua: ignore
local key_tables = {
   resize_font = {
      { key = 'k',      action = act.IncreaseFontSize },
      { key = 'j',      action = act.DecreaseFontSize },
      { key = 'r',      action = act.ResetFontSize },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q',      action = 'PopKeyTable' },
   },
   resize_pane = {
      { key = 'k',      action = act.AdjustPaneSize({ 'Up', 1 }) },
      { key = 'j',      action = act.AdjustPaneSize({ 'Down', 1 }) },
      { key = 'h',      action = act.AdjustPaneSize({ 'Left', 1 }) },
      { key = 'l',      action = act.AdjustPaneSize({ 'Right', 1 }) },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q',      action = 'PopKeyTable' },
   },
}

local mouse_bindings = {
	-- Ctrl-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
}

return {
	disable_default_key_bindings = true,
	leader = { key = "Space", mods = mod.SUPER_REV },
	keys = keys,
	key_tables = key_tables,
	mouse_bindings = mouse_bindings,
}
