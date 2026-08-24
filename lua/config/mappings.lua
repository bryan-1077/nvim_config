-- mappings, including plugins

local function map(m, k, v)
	vim.keymap.set(m, k, v, { noremap = true, silent = true })
end

-- set leader
map("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- buffers
map("n", "<S-l>", "<Cmd>BufferNext<CR>")
map("n", "<S-h>", "<Cmd>BufferPrevious<CR>")
map("n", "<leader>q", ":BufferClose<CR>")
map("n", "<leader>Q", ":BufferClose!<CR>")
map("n", "<leader>U", "::bufdo bd<CR>") --close all
map('n', '<leader>vs', ':vsplit<CR>:bnext<CR>') --ver split + open next buffer

-- buffer position nav + reorder
map('n', '<AS-h>', '<Cmd>BufferMovePrevious<CR>')
map('n', '<AS-l>', '<Cmd>BufferMoveNext<CR>')
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>')
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>')
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>')
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>')
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>')
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>')
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>')
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>')
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>')
map('n', '<A-0>', '<Cmd>BufferLast<CR>')
map('n', '<A-p>', '<Cmd>BufferPin<CR>')

-- windows - ctrl nav, fn resize
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<F5>", ":resize +2<CR>")
map("n", "<F6>", ":resize -2<CR>")
map("n", "<F7>", ":vertical resize +2<CR>")
map("n", "<F8>", ":vertical resize -2<CR>")

-- fzf and grep
map("n", "<leader>f", ":lua require('fzf-lua').files()<CR>") --search cwd
map("n", "<leader>Fh", ":lua require('fzf-lua').files({ cwd = '~/' })<CR>") --search home
map("n", "<leader>Fc", ":lua require('fzf-lua').files({ cwd = '~/.config' })<CR>") --search .config
map("n", "<leader>Fl", ":lua require('fzf-lua').files({ cwd = '~/.local/src' })<CR>") --search .local/src
map("n", "<leader>Ff", ":lua require('fzf-lua').files({ cwd = '..' })<CR>") --search above
map("n", "<leader>Fr", ":lua require('fzf-lua').resume()<CR>") --last search
map("n", "<leader>g", ":lua require('fzf-lua').grep()<CR>") --grep
map("n", "<leader>G", ":lua require('fzf-lua').grep_cword()<CR>") --grep word under cursor

-- misc
map("n", "<leader>s", ":%s/") --replace all
map("n", "<leader>t", ":NvimTreeToggle<CR>") --open file explorer
map("n", "<leader>P", ":PlugInstall<CR>") --vim-plug
map('n', '<leader>z', ":lua require('FTerm').open()<CR>") --open term
map('t', '<Esc>', '<C-\\><C-n><CMD>lua require("FTerm").close()<CR>') --preserves session
map("n", "<leader>w", ":w<CR>") --write but one less key
map("n", "<leader>d", ":w ") --duplicate to new name
map("n", "<leader>mm", ":mksession! .vim<Left><Left><Left><Left>") --make session
map("n", "<leader>x", "<cmd>!chmod +x %<CR>") --make a file executable
map("n", "<leader>mv", ":!mv % ") --move a file to a new dir
map("n", "<leader>R", ":so %<CR>") --reload neovim config
map("n", "<leader>u", ':silent !xdg-open "<cWORD>" &<CR>') --open a url under cursor
map("v", "<leader>i", "=gv") --auto indent
map("n", "<leader>W", ":set wrap!<CR>") --toggle wrap
map("n", "<leader>l", ":Twilight<CR>") --surrounding dim

local reference_line_ns = vim.api.nvim_create_namespace("reference_line")
vim.api.nvim_set_hl(0, "ReferenceLine", { bg = "#3A3F4B" })

map("n", "<leader>na", function() --add reference line tint
	local bufnr = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_clear_namespace(bufnr, reference_line_ns, 0, -1)
	vim.api.nvim_buf_set_extmark(bufnr, reference_line_ns, vim.fn.line(".") - 1, 0, {
		line_hl_group = "ReferenceLine",
		priority = 250,
	})
end)

map("n", "<leader>ns", function() --clear reference line tint
	vim.api.nvim_buf_clear_namespace(0, reference_line_ns, 0, -1)
end)

-- diagnostics
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "next diagnostic" })

vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "previous diagnostic" })

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {
	desc = "show line diagnostic",
})

vim.keymap.set("n", "<leader>E", function()
	vim.diagnostic.setloclist({ open = true })
end, { desc = "list buffer diagnostics" })

vim.keymap.set("n", "<leader>L", "<Cmd>lclose<CR>", {
	desc = "close diagnostics list",
})

-- Convert SV port declaration to instance port
vim.keymap.set("n", "<leader>p", "g_byiwS.<C-r>0(),<Esc>F(a", {
    desc = "port declare -> instance",
})

local function sv_ports_to_instance()
	local mode = vim.fn.mode()
	local start_line
	local end_line

	if mode == "v" or mode == "V" or mode == "\22" then
		start_line = vim.fn.line("v")
		end_line = vim.fn.line(".")
	else
		start_line = vim.fn.line("'<")
		end_line = vim.fn.line("'>")
	end

	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end

	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
	local converted = {}

	for _, line in ipairs(lines) do
		local indent, rest = line:match("^(%s*)(.-)%s*$")
		rest = rest:gsub("%s*//.*$", "")
		rest = rest:gsub("[%s,;]+$", "")

		local name = rest:match("([%a_][%w_$]*)$")
		local has_direction = rest:match("^input%f[%W]")
			or rest:match("^output%f[%W]")
			or rest:match("^inout%f[%W]")

		if name and has_direction then
			table.insert(converted, string.format("%s.%s(%s),", indent, name, name))
		else
			table.insert(converted, line)
		end
	end

	vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, converted)
end

-- Convert selected SV port declarations to instance ports
vim.keymap.set("x", "<leader>mw", sv_ports_to_instance, {
	desc = "port declarations -> instance ports",
})

-- Instance port -> logic declaration (leader then m then s)
vim.keymap.set("n", "<leader>ms", "0f(l\"ayiwSlogic [:0] <Esc>\"apA;<Esc>0f:i", {
	desc = "instance port -> logic",
})

-- Instance port -> scalar logic declaration (leader then m then d)
vim.keymap.set("n", "<leader>md", "0f(l\"ayiwSlogic <Esc>\"apA;<Esc>", {
	desc = "instance port -> scalar logic",
})

-- decisive csv
map("n", "<leader>csa", ":lua require('decisive').align_csv({})<cr>")
map("n", "<leader>csA", ":lua require('decisive').align_csv_clear({})<cr>")
map("n", "[c", ":lua require('decisive').align_csv_prev_col()<cr>")
map("n", "]c", ":lua require('decisive').align_csv_next_col()<cr>")


map("n", "<leader>H", function() --toggle htop in term
    _G.htop:toggle()
end)


map("n", "<leader>ma", function() --quick make in dir of buffer
	local bufdir = vim.fn.expand("%:p:h")
	vim.cmd("lcd " .. bufdir)
	vim.cmd("!sudo make uninstall && sudo make clean install %")
end)


map("n", "<leader>nn", function() --toggle relative vs absolute line numbers
	if vim.wo.relativenumber then
		vim.wo.relativenumber = false
		vim.wo.number = true
	else
		vim.wo.relativenumber = true
	end
end)
