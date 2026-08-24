-- bread's neovim config
-- keymaps are in lua/config/mappings.lua
-- install a patched font & ensure your terminal supports glyphs
-- enjoy :D

-- auto install vim-plug and plugins, if not found
local data_dir = vim.fn.stdpath('data')
if vim.fn.empty(vim.fn.glob(data_dir .. '/site/autoload/plug.vim')) == 1 then
	vim.cmd('silent !curl -fLo ' .. data_dir .. '/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
	vim.o.runtimepath = vim.o.runtimepath
	vim.cmd('autocmd VimEnter * PlugInstall --sync | source $MYVIMRC')
end

local vim = vim
local Plug = vim.fn['plug#']

vim.g.start_time = vim.fn.reltime()
vim.loader.enable() --  SPEEEEEEEEEEED 
vim.call('plug#begin')

Plug('nvim-lualine/lualine.nvim') --statusline
Plug('nvim-tree/nvim-web-devicons') --pretty icons
Plug('folke/which-key.nvim') --mappings popup
Plug('romgrk/barbar.nvim') --bufferline
Plug('goolord/alpha-nvim') --pretty startup
Plug('nvim-treesitter/nvim-treesitter') --improved syntax
Plug('mfussenegger/nvim-lint') --async linter
Plug('neovim/nvim-lspconfig') -- LSP config
Plug('hrsh7th/nvim-cmp') -- completion
Plug('hrsh7th/cmp-nvim-lsp') -- lsp source for nvim-cmp
Plug('hrsh7th/cmp-buffer') -- buffer completions
Plug('hrsh7th/cmp-path') -- path completions
Plug('L3MON4D3/LuaSnip') -- snippet engine
Plug('saadparwaiz1/cmp_luasnip') -- luasnip source for nvim-cmp
Plug('nvim-tree/nvim-tree.lua') --file explorer
Plug('windwp/nvim-autopairs') --autopairs 
Plug('kylechui/nvim-surround') --surround editing
Plug('lewis6991/gitsigns.nvim') --git
Plug('numToStr/Comment.nvim') --easier comments
Plug('norcalli/nvim-colorizer.lua') --color highlight
Plug('ibhagwan/fzf-lua') --fuzzy finder and grep
Plug('numToStr/FTerm.nvim') --floating terminal
Plug('ron-rs/ron.vim') --ron syntax highlighting
Plug('MeanderingProgrammer/render-markdown.nvim') --render md inline
Plug('emmanueltouzery/decisive.nvim') --view csv files
Plug('folke/twilight.nvim') --surrounding dim

vim.call('plug#end')

-- move config and plugin config to alternate files
-- require("config.theme")
require("config.mappings")
require("config.options")
require("config.autocmd")
require("config.transparency").setup()
require("config.systemverilog")
pcall(function()
    require("setup_systemverilog").setupFormatter()
end)

require("plugins.alpha")
-- require("plugins.autopairs")
require("plugins.barbar")
require("plugins.colorizer")
-- require("plugins.colorscheme")
require("plugins.comment")
-- require("plugins.fterm")
-- require("plugins.fzf-lua")
require("plugins.gitsigns")
require("plugins.lualine")
require("plugins.nvim-lint")
require("plugins.cmp")
require("plugins.lspconfig")
-- require("plugins.nvim-tree")
require("plugins.render-markdown")
-- require("plugins.treesitter")
-- require("plugins.twilight")
-- require("plugins.which-key")

-- Key rebinds
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half-page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half-page up and center" })
vim.opt.clipboard = "unnamedplus" -- Yanking goes to clipboard

-- Tabs
vim.opt.autoindent = true
-- vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.defer_fn(function()
	require("plugins.autopairs")
	require("plugins.fterm")
	require("plugins.fzf-lua")
	require("plugins.nvim-tree")
	require("plugins.nvim-surround")
	require("plugins.treesitter")
	require("plugins.twilight")
	require("plugins.which-key")

end, 100)

-- Disable Treesitter SV autoindent
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.v", "*.sv", "*.vh", "*.svh" },
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = true

        -- Use Neovim's built-in indentation
        vim.opt_local.autoindent = true
        vim.opt_local.smartindent = true

        -- Prevent Treesitter from controlling indentation
        vim.opt_local.indentexpr = ""
    end,
})
-- load_theme()
