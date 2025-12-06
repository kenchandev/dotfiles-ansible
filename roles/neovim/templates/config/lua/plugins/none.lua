local safe_require = require("utils.module").safe_require

local mason_null_ls = safe_require("mason-null-ls")
local null_ls = safe_require("null-ls")
local null_ls_utils = safe_require("null-ls.utils")

if mason_null_ls and null_ls and null_ls_utils then
  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

  mason_null_ls.setup()

  null_ls.setup({
    root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
    sources = {
      formatting.prettier,
      formatting.biome,
      formatting.stylua,
      formatting.isort,
      formatting.black,
    },
    on_attach = function(current_client, bufnr)
      if current_client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({
          group = augroup,
          buffer = bufnr
        })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({
              filter = function(client)
                return client.name == "null-ls"
              end,
              bufnr = bufnr
            })
          end
        })
      end
    end
  })
end
