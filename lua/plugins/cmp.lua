local ok, cmp = pcall(require, 'cmp')
if not ok then
    return
end

local luasnip_ok, luasnip = pcall(require, 'luasnip')
if not luasnip_ok then
    luasnip = nil
end

local lspkind_ok, lspkind = pcall(require, 'lspkind')

cmp.setup({
    snippet = {
        expand = function(args)
            if luasnip then
                require('luasnip').lsp_expand(args.body)
            end
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    }),
})
