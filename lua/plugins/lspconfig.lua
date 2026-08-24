local ok, lspconfig = pcall(require, 'lspconfig')
if not ok then
    return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if has_cmp and cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- Call systemverilog setup if available
pcall(function()
    require('setup_systemverilog').setupLsp()
end)

-- Filter out Verible whitespace diagnostics (so only whitespace messages are removed)
do
    local orig_publish = vim.lsp.handlers["textDocument/publishDiagnostics"]
    vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
        if result and result.diagnostics and ctx and ctx.client_id then
            local client = vim.lsp.get_client_by_id(ctx.client_id)
            if client and client.name == "verible" then
                local ok_filter, systemverilog = pcall(require, "setup_systemverilog")
                if ok_filter then
                    result.diagnostics = systemverilog.filterWhitespaceDiagnostics(result.diagnostics)
                end
            end
        end
        orig_publish(err, result, ctx, config)
    end
end
