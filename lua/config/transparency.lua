local M = {}

-- Palette provided by user
local menu_bg = "#1b1625"         -- very dark plum / charcoal
local menu_fg = "#ddd7e8"         -- main text (soft lavender-white)
local menu_sel_bg = "#3a2f52"     -- muted violet (selected item)
local menu_sel_fg = "#ddd7e8"
local menu_secondary = "#8f859e"  -- secondary text / annotations
local border_fg = "#57486f"       -- border subdued purple
local func_icon = "#9d8cff"       -- function/method icons
local var_field = "#8bd5ca"       -- variables / fields
local keyword_fg = "#d99bc5"      -- keywords / classes

local transparent_groups = {
	-- Neovim
	"Normal",
	"NormalNC",
	"NormalFloat",
	"FloatBorder",
	"FloatTitle",
	"SignColumn",
	"FoldColumn",
	"Folded",
	"LineNr",
	"CursorLineNr",
	"CursorLine",
	"ColorColumn",
	"EndOfBuffer",
	"NonText",
	"WinSeparator",

	-- Statusline/tabline base
	"StatusLine",
	"StatusLineNC",
	"TabLine",
	"TabLineFill",
	"TabLineSel",

	-- Common plugin surfaces
	"NvimTreeNormal",
	"NvimTreeNormalNC",
	"NvimTreeEndOfBuffer",
	"NvimTreeWinSeparator",
}

local menu_groups = {
	"Pmenu",
	"PmenuSel",
	"PmenuKind",
	"PmenuKindSel",
	"PmenuExtra",
	"PmenuExtraSel",
	"PmenuMatch",
	"PmenuMatchSel",
	"PmenuSbar",
	"PmenuThumb",
}

function M.apply()
	for _, group in ipairs(transparent_groups) do
		local ok, highlight = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })

		if not ok then
			highlight = {}
		end

		highlight.bg = nil
		highlight.ctermbg = nil
		vim.api.nvim_set_hl(0, group, highlight)
	end

	for _, group in ipairs(menu_groups) do
		local ok, highlight = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })

		if not ok then
			highlight = {}
		end

			if group:match("Sel$") then
				highlight.bg = menu_sel_bg
				highlight.fg = highlight.fg or menu_sel_fg
			else
				highlight.bg = menu_bg
				highlight.fg = highlight.fg or menu_fg
			end
		highlight.cterm = nil
		highlight.ctermbg = nil
		vim.api.nvim_set_hl(0, group, highlight)
	end

	-- Explicitly set related highlight groups for completion, floating borders, and symbol kinds
	vim.api.nvim_set_hl(0, 'Pmenu', { bg = menu_bg, fg = menu_fg })
	vim.api.nvim_set_hl(0, 'PmenuSel', { bg = menu_sel_bg, fg = menu_sel_fg })
	vim.api.nvim_set_hl(0, 'PmenuExtra', { bg = menu_bg, fg = menu_secondary })
	vim.api.nvim_set_hl(0, 'PmenuKind', { bg = menu_bg, fg = menu_secondary })
	vim.api.nvim_set_hl(0, 'PmenuMatch', { bg = menu_bg, fg = menu_secondary })
	vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = menu_bg })
	vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = menu_sel_bg })

	vim.api.nvim_set_hl(0, 'FloatBorder', { fg = border_fg })
	vim.api.nvim_set_hl(0, 'FloatTitle', { fg = border_fg })

	-- Completion / lsp kind icons
	vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { fg = func_icon })
	vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { fg = func_icon })
	vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { fg = var_field })
	vim.api.nvim_set_hl(0, 'CmpItemKindField', { fg = var_field })

	-- Language groups
	vim.api.nvim_set_hl(0, 'Function', { fg = func_icon })
	vim.api.nvim_set_hl(0, 'Identifier', { fg = var_field })
	vim.api.nvim_set_hl(0, 'Keyword', { fg = keyword_fg })
	vim.api.nvim_set_hl(0, 'Type', { fg = keyword_fg })
end

function M.setup()
	M.apply()

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("TransparentBackground", { clear = true }),
		callback = M.apply,
	})
end

return M
