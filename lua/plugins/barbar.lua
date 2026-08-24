vim.g.barbar_auto_setup = false -- disable auto-setup

require("barbar").setup({
  animation = false,

  -- Enable/disable current/total tabpages indicator (top right corner)
  tabpages = true,

  -- A buffer to this direction will be focused (if it exists) when closing the current buffer.
  -- Valid options are 'left' (the default), 'previous', and 'right'
  focus_on_close = 'left',

  -- Hide inactive buffers and file extensions. Other options are `alternate`, `current`, and `visible`.
  hide = {extensions = false, inactive = false},

  icons = {
    buffer_index = false,
    buffer_number = false,
    button = '',
    diagnostics = {
      [vim.diagnostic.severity.ERROR] = {enabled = true, icon = ' '},
    },
    gitsigns = {
      added = {enabled = true, icon = ' '},
      changed = {enabled = true, icon = ' '},
      deleted = {enabled = true, icon = ' '},
    },
	    separator = {left = '│', right = ''},

    -- If true, add an additional separator at the end of the buffer list
    separator_at_end = true,

    -- Configure the icons on the bufferline when modified or pinned.
    -- Supports all the base icon options.
    modified = {button = '●'},
    pinned = {button = '', filename = true},

    -- Configure the icons on the bufferline based on the visibility of a buffer.
    -- Supports all the base icon options, plus `modified` and `pinned`.
	    alternate = { filetype = { enabled = false }, separator = { left = '│', right = '' } },
	    current = { buffer_index = true, separator = { left = '│', right = '' } },
	    inactive = { button = '×', separator = { left = '│', right = '' } },
	    visible = { modified = { buffer_number = false }, separator = { left = '│', right = '' } },
  },

  sidebar_filetypes = {   -- Set the filetypes which barbar will offset itself for
    -- Use the default values: {event = 'BufWinLeave', text = '', align = 'left'}
    NvimTree = true,

    -- Or, specify the text used for the offset:
    undotree = {
      text = 'undotree',
      align = 'left',
    },

    -- Or, specify the event which the sidebar executes when leaving:
    ['neo-tree'] = {event = 'BufWipeout'},

    -- Or, specify all three:
    Outline = {
      event = 'BufWinLeave',
      text = 'symbols-outline',
      align = 'right',
    },
  },

  maximum_length = 25, -- Sets the maximum buffer name length.
})


-- Active buffer/tab
-- Background: #655d77
-- Text/icons: bold white
local active_bg = "#655d77"
local active_fg = "#ffffff"

local active_groups = {
  "BufferCurrent",
  "BufferCurrentERROR",
  "BufferCurrentHINT",
  "BufferCurrentINFO",
  "BufferCurrentWARN",
  "BufferCurrentBtn",
  "BufferCurrentButton",
  "BufferCurrentDevIcon",
  "BufferCurrentIcon",
  "BufferCurrentIconInactive",
  "BufferCurrentIndex",
  "BufferCurrentMod",
  "BufferCurrentModBtn",
  "BufferCurrentNumber",
  "BufferCurrentPin",
  "BufferCurrentPinBtn",
  "BufferCurrentSign",
  "BufferCurrentSignRight",
  "BufferCurrentTarget",
}

for _, group in ipairs(active_groups) do
  vim.api.nvim_set_hl(0, group, {
    bg = active_bg,
    fg = active_fg,
    bold = true,
  })
end

local active_git_groups = {
  BufferCurrentADDED = "#59ff5a",
  BufferCurrentCHANGED = "#599eff",
  BufferCurrentDELETED = "#ff4d4d",
}

for group, fg in pairs(active_git_groups) do
  vim.api.nvim_set_hl(0, group, {
    bg = active_bg,
    fg = fg,
  })
end

for _, group in ipairs({
  "BufferCurrentSign",
  "BufferCurrentSignRight",
  "BufferVisibleSign",
  "BufferVisibleSignRight",
  "BufferInactiveSign",
  "BufferInactiveSignRight",
  "BufferAlternateSign",
  "BufferAlternateSignRight",
}) do
  vim.api.nvim_set_hl(0, group, { link = "WinSeparator" })
end
