-- SystemVerilog / Verilog syntax highlighting
--
-- Foreground colors only.
-- No background colors are set, preserving terminal transparency.

local highlights = {
	-- ============================================================
	-- Comments
	-- ============================================================

	["@comment.systemverilog"] = {
		fg = "#6a9955",
		italic = true,
	},

	-- ============================================================
	-- Keywords
	-- ============================================================

	["@keyword.systemverilog"] = {
		fg = "#ff9e64",
		bold = true,
	},

	["@keyword.modifier.systemverilog"] = {
		fg = "#ff9e64",
		bold = true,
	},

	["@keyword.conditional.systemverilog"] = {
		fg = "#8bdc9d",
		bold = true,
	},

	-- Preprocessor directives such as `define and `timescale
	["@keyword.directive.define.systemverilog"] = {
		fg = "#c678dd",
		bold = true,
	},

	["@label.systemverilog"] = {
		fg = "#2dd4bf",
		bold = true,
	},

	["@attribute.systemverilog"] = {
		fg = "#e06c75",
	},

	-- ============================================================
	-- Types
	-- ============================================================

	-- Built-in types:
	-- logic, wire, reg, int, integer, bit, byte, etc.
	["@type.builtin.systemverilog"] = {
		fg = "#56b6c2",
	},

	-- User-defined types:
	-- state_t, packet_t, fifo_t, etc.
	["@type.definition.systemverilog"] = {
		fg = "#61afef",
	},

	-- ============================================================
	-- Variables / Signals
	-- ============================================================

	-- Normal signal and variable names
	["@variable.systemverilog"] = {
		fg = "#ff8fb3",
	},

	-- Parameters
	["@variable.parameter.systemverilog"] = {
		fg = "#e5c07b",
	},

	-- Constants
	["@constant.systemverilog"] = {
		fg = "#e5c07b",
	},

	-- ============================================================
	-- Numbers
	-- ============================================================

	-- Examples:
	-- 32
	-- 32'hDEADBEEF
	-- 8'b10101010
	-- 4'd15
	["@number.systemverilog"] = {
		fg = "#e5c07b",
	},

	-- ============================================================
	-- Strings
	-- ============================================================

	["@string.systemverilog"] = {
		fg = "#98c379",
	},

	-- ============================================================
	-- Functions / System Tasks
	-- ============================================================

	-- Examples:
	-- $display
	-- $monitor
	-- $finish
	-- user-defined functions
	["@function.systemverilog"] = {
		fg = "#98c379",
	},

	-- ============================================================
	-- Operators
	-- ============================================================

	["@operator.systemverilog"] = {
		fg = "#c3cad3",
	},

	-- ============================================================
	-- Brackets
	-- ============================================================

	-- (), [], {}
	["@punctuation.bracket.systemverilog"] = {
		fg = "#c792ea",
	},
}

-- Apply all highlight definitions
for group, opts in pairs(highlights) do
	vim.api.nvim_set_hl(0, group, opts)
end
