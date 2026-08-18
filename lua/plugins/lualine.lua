local lualine = require('lualine')

local accent_bg = "#a283eb"
local muted_bg = "#655d77"
local accent_fg = "#1c1b22"
local right_fg = "#ffffff"

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	colored = true,
	update_in_insert = false,
	always_visible = true,
	cond = function()
		return vim.bo.filetype ~= "markdown"
	end,
}

local diff = {
	"diff",
	colored = true,
	symbols = { added = " ", modified = " ", removed = " " },
}

local mode = {
	"mode",
	fmt = function(str)
		return "-- " .. str .. " --"
	end,
}

local branch = {
	"branch",
	icon = "",
}

local progress = function()
	local current_line = vim.fn.line(".")
	local total_lines = vim.fn.line("$")
	local chars = { "", "", "" } --adding more chars will still work
	local line_ratio = current_line / total_lines
	local index = math.ceil(line_ratio * #chars)
	return chars[index] .. " " .. math.floor(line_ratio * 100) .. "%%"
end

local transparent_theme = {}

for _, mode_name in ipairs({ "normal", "insert", "visual", "replace", "command", "inactive" }) do
	transparent_theme[mode_name] = {}

	for _, section_name in ipairs({ "a", "b", "c", "x", "y", "z" }) do
		transparent_theme[mode_name][section_name] = { bg = "NONE" }
	end

	transparent_theme[mode_name].a = { bg = accent_bg, fg = accent_fg, gui = "bold" }
	transparent_theme[mode_name].b = { bg = accent_bg, fg = accent_fg }
	transparent_theme[mode_name].x = { bg = "NONE", fg = right_fg }
	transparent_theme[mode_name].y = { bg = muted_bg, fg = right_fg }
	transparent_theme[mode_name].z = { bg = muted_bg, fg = right_fg }
end

lualine.setup({
options = {
	icons_enabled = true,
	theme = transparent_theme,
	component_separators = { left = "", right = "" },
	section_separators = { left = "", right = "" },
	disabled_filetypes = { "alpha", "dashboard" },
	always_divide_middle = true,
	},

sections = {
	lualine_a = { branch },
	lualine_b = { mode },
	lualine_c = { diagnostics },
	lualine_x = { diff, "fileformat", "filetype" },
	lualine_y = { "location" },
	lualine_z = { progress },
	},
	extensions = { 'nvim-tree' },
})

-- transparency override if using old pywal, shouldn't be needed with 16
-- vim.api.nvim_set_hl(0, "lualine_c_normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "lualine_c_inactive", { bg = "none" })
-- vim.api.nvim_set_hl(0, "lualine_x_normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "lualine_x_inactive", { bg = "none" })
