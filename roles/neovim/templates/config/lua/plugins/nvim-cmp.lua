local safe_require = require("utils.module").safe_require

local cmp = safe_require("cmp")
local lspkind = safe_require("lspkind")
local luasnip = safe_require("luasnip")
local luasnip_loaders_from_vscode = safe_require("luasnip.loaders.from_vscode")

if cmp and lspkind and luasnip and luasnip_loaders_from_vscode then
  luasnip_loaders_from_vscode.lazy_load()

  cmp.setup({
    completion = {
      completeopt = "menu,menuone,preview,noselect"
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({
        select = false
      })
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" }
    }),
    formatting = {
      format = lspkind.cmp_format({
        maxwidth = 50,
        ellipsis_char = "..."
      })
    }
  })
end