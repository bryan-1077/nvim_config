-- This file contains a table with functions that configure the
-- LSP, linter, and treesitter plugins for use with SystemVerilog.
-- It is called from within the plugin spec themselves.
-- For example, you will find require'setup_systemverilog'.setupLsp() within
-- lua\setup_nvim_lspconfig.lua.

local setup_systemverilog = {}

local verilator_filelists = {
    'verilator.f',
    'files.f',
    'filelist.f',
    'rtl.f',
    'sources.f',
}

local function first_support_filelist(start)
    local support_dirs = vim.fs.find('support', { path = start, upward = true, stop = vim.env.HOME })

    for _, support_dir in ipairs(support_dirs) do
        if vim.fn.isdirectory(support_dir) == 1 then
            local filelists = vim.fn.globpath(support_dir, '*.f', false, true)
            table.sort(filelists)

            if filelists[1] then
                return filelists[1], vim.fs.dirname(support_dir)
            end
        end
    end
end

local function find_verilator_filelist(start)
    local filelist = vim.fs.find(verilator_filelists, { path = start, upward = true, stop = vim.env.HOME })[1]

    if filelist then
        return filelist, vim.fs.dirname(filelist)
    end

    return first_support_filelist(start)
end

local function is_whitespace_diagnostic(diagnostic)
    local message = string.lower(diagnostic.message or "")
    local code = string.lower(tostring(diagnostic.code or vim.tbl_get(diagnostic, "user_data", "lsp", "code") or ""))

    return message:match("whitespace")
        or message:match("trailing%s+spaces?")
        or message:match("trailing%s+whitespace")
        or code:match("whitespace")
end

local function filter_whitespace_diagnostics(diagnostics)
    return vim.tbl_filter(function(diagnostic)
        return not is_whitespace_diagnostic(diagnostic)
    end, diagnostics)
end

function setup_systemverilog.filterWhitespaceDiagnostics(diagnostics)
    return filter_whitespace_diagnostics(diagnostics)
end

local format_args = {
    'verible-verilog-format',
    '--indentation_spaces=4',
    '--alignment_group_boundary=blank-lines-and-separator-comments',
    '--module_net_variable_alignment=align',
    '--port_declarations_alignment=align',
    '-',
}

function setup_systemverilog.formatBuffer(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    if vim.fn.executable('verible-verilog-format') ~= 1 then
        vim.notify('verible-verilog-format not found on PATH', vim.log.levels.WARN)
        return
    end

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local input = table.concat(lines, '\n')
    if vim.bo[bufnr].endofline then
        input = input .. '\n'
    end

    local result = vim.system(format_args, { text = true, stdin = input }):wait()
    if result.code ~= 0 then
        local message = (result.stderr or '') ~= '' and result.stderr or result.stdout
        vim.notify(message, vim.log.levels.ERROR)
        return
    end

    local formatted = result.stdout or ''
    if formatted:sub(-1) == '\n' then
        formatted = formatted:sub(1, -2)
    end

    local output = formatted == '' and {} or vim.split(formatted, '\n', { plain = true })
    if vim.deep_equal(lines, output) then
        vim.notify('SystemVerilog already formatted', vim.log.levels.INFO)
        return
    end

    local view = vim.fn.winsaveview()
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, output)
    vim.fn.winrestview(view)
end

function setup_systemverilog.setupFormatter()
    vim.api.nvim_create_user_command('SVFormat', function()
        setup_systemverilog.formatBuffer(0)
    end, {
        desc = 'Format current Verilog/SystemVerilog buffer with verible-verilog-format',
    })

    local group = vim.api.nvim_create_augroup('systemverilog_format', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = { 'verilog', 'systemverilog' },
        callback = function(args)
            vim.keymap.set('n', '<leader>mf', function()
                setup_systemverilog.formatBuffer(args.buf)
            end, {
                buffer = args.buf,
                desc = 'format Verilog/SystemVerilog',
                silent = true,
            })
        end,
    })
end

function setup_systemverilog.setupLsp()
    if vim.fn.executable('verible-verilog-ls') ~= 1 then
        return
    end

    vim.lsp.config('verible', {
        cmd = {
            'verible-verilog-ls',
            '--rules=-no-trailing-spaces',
            '--rules_config_search',
        },
        filetypes = { 'systemverilog', 'verilog' },
        root_dir = function(bufnr, on_dir)
            local file = vim.api.nvim_buf_get_name(bufnr)
            local root = vim.fs.root(file, { 'verible.filelist' })

            on_dir(root or vim.fs.dirname(file))
        end,
    })
    vim.lsp.enable('verible')
end

function setup_systemverilog.setupLinter(lint)

    lint.linters_by_ft.systemverilog = { 'verilator' }
    lint.linters_by_ft.verilog = { 'verilator' }

    local default_verilator = lint.linters.verilator

    -- Add/change arguments for Verilator here.
    -- You can also use or re-use a .f filelist such as verilator.f, files.f,
    -- filelist.f, rtl.f, or sources.f. A project support/*.f filelist is also
    -- picked up when editing files below that project.

    -- The arguments below are the default provided by nvim-lint
    -- (https://github.com/mfussenegger/nvim-lint/blob/master/lua/lint/linters/verilator.lua)
    -- with the exception of the '-f' and corresponding path to the filelist.
    lint.linters.verilator = function()
        local verilator = vim.deepcopy(default_verilator)
        local file = vim.api.nvim_buf_get_name(0)
        local start = file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()
        local filelist, filelist_cwd = find_verilator_filelist(start)

        verilator.cwd = filelist_cwd or start
        verilator.append_fname = filelist == nil

        verilator.args = {
            "-sv",
            "-Wall",
            "--relative-includes",
            "-I" .. start,
            "--bbox-sys",
            "--bbox-unsup",
            "--lint-only",
        }

        if filelist then
            vim.list_extend(verilator.args, { '-f', filelist })
        end

        local parser = verilator.parser
        verilator.parser = function(output, bufnr, linter_cwd)
            return filter_whitespace_diagnostics(parser(output, bufnr, linter_cwd))
        end

        return verilator
    end
end

function setup_systemverilog.setupTreesitter(opts)
    table.insert(opts.ensure_installed, 'verilog')

    -- Uncomment below to disable highlighting via Treesitter
    -- Sometimes the highlighting provided via treesitter isnt great, so ymmv.
    --table.insert(opts.highlight.disable, {'verilog', 'systemverilog'})
end


return setup_systemverilog
