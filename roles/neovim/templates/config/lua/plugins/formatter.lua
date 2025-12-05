local safe_require = require("utils").safe_require

local formatter = safe_require("formatter")
local defaults = safe_require("formatter.defaults")
local any = safe_require("formatter.filetypes.any")
local lua = safe_require("formatter.filetypes.lua")
local python = safe_require("formatter.filetypes.python")
local rust = safe_require("formatter.filetypes.rust")

if formatter then
  formatter.setup({
    filetype = {
      astro = {
        defaults.eslint_d,
        defaults.prettier
      },
      javascript = {
        defaults.biome,
        defaults.eslint_d,
        defaults.prettier
      },
      javascriptreact = {
        defaults.biome,
        defaults.eslint_d,
        defaults.prettier
      },
      json = {
        defaults.biome,
        defaults.prettier
      },
      jsonc = {
        defaults.biome,
        defaults.prettier
      },
      lua = {
        lua.stylua
      },
      python = {
        python.black,
        python.ruff
      },
      rust = {
        rust.rustfmt
      },
      svelte = {
        defaults.eslint_d,
        defaults.prettier
      },
      typescript = {
        defaults.biome,
        defaults.eslint_d,
        defaults.prettier
      },
      typescriptreact = {
        defaults.biome,
        defaults.eslint_d,
        defaults.prettier
      },
      yaml = {
        defaults.prettier
      },
      -- Use the special "*" file type for defining formatter configurations on any file type.
      ["*"] = {
        any.remove_trailing_whitespace
      },
    }
  })

  local augroup = vim.api.nvim_create_augroup
  local autocmd = vim.api.nvim_create_autocmd

  augroup("__formatter__", {
    clear = true
  })
  autocmd("BufWritePost", {
    group = "__formatter__",
    command = ":FormatWrite",
  })
end
