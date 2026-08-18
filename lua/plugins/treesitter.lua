local treesitter = require("nvim-treesitter")

vim.list = vim.list or {}
vim.list.unique = vim.list.unique or function(list)
	local seen = {}
	local unique = {}

	for _, item in ipairs(list) do
		if not seen[item] then
			seen[item] = true
			unique[#unique + 1] = item
		end
	end

	return unique
end

local languages = {
	"bash",
	"c",
	"css",
	"cpp",
	"go",
	"html",
	"java",
	"javascript",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"python",
	"rust",
	"systemverilog",
	"tsx",
	"typescript",
	"verilog",
}

treesitter.setup()

vim.treesitter.language.register("systemverilog", { "verilog" })

local function start_treesitter()
	local ok = pcall(vim.treesitter.start)

	if ok then
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = languages,
	callback = start_treesitter,
})

if vim.tbl_contains(languages, vim.bo.filetype) then
	start_treesitter()
end

-- SystemVerilog / Verilog highlighting
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "verilog", "systemverilog" },
	callback = function()
		local highlights = {
			["@keyword.module.verilog"] = { bold = true },
			["@keyword.function.verilog"] = { bold = true },
			["@keyword.return.verilog"] = { bold = true },

			["@type.verilog"] = {},
			["@type.builtin.verilog"] = {},

			["@constant.verilog"] = {},
			["@number.verilog"] = {},

			["@function.call.verilog"] = {},
			["@function.definition.verilog"] = {},

			["@comment.verilog"] = { italic = true },
		}

		for group, opts in pairs(highlights) do
			vim.api.nvim_set_hl(0, group, opts)
		end
	end,
})
