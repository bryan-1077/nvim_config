require("nvim-tree").setup({
renderer = {
--note on icons:
--in some terminals, some patched fonts cut off glyphs if not given extra space
--either add extra space, disable icons, or change font
		icons = {
			show = {
			file = false,
			folder = false,
			folder_arrow = true,
			git = true,
			},
			glyphs = {
				git = {
					unstaged = "~",
					staged = "✓",
					untracked = "+",
					renamed = ">",
					deleted = "-",
					ignored = "·",
				},
			},
		},
	},
	view = {
		width = 25,
		side = 'left',
	},
	sync_root_with_cwd = true, --fix to open cwd with tree
	respect_buf_cwd = true,
	update_cwd = true,
	update_focused_file = {
		enable = true,
		update_cwd = true,
		update_root = true,
	},
})

local git_icon_highlights = {
	NvimTreeGitDirtyIcon = "#E2C08D",
	NvimTreeGitStagedIcon = "#73C991",
	NvimTreeGitNewIcon = "#73C991",
	NvimTreeGitRenamedIcon = "#73C991",
	NvimTreeGitDeletedIcon = "#C74E39",
	NvimTreeGitIgnoredIcon = "#8C8C8C",
}

for group, fg in pairs(git_icon_highlights) do
	vim.api.nvim_set_hl(0, group, { fg = fg })
end

vim.g.nvim_tree_respect_buf_cwd = 1

-- use g? for bindings help while in tree
