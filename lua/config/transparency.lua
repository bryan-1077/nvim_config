local M = {}

local menu_bg = "#655d77"
local menu_fg = "#1c1b22"

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

		highlight.bg = menu_bg
		highlight.fg = highlight.fg or menu_fg
		highlight.cterm = nil
		highlight.ctermbg = nil
		vim.api.nvim_set_hl(0, group, highlight)
	end
end

function M.setup()
	M.apply()

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("TransparentBackground", { clear = true }),
		callback = M.apply,
	})
end

return M
