local safe_require = require("utils").safe_require

local mason = safe_require("mason")
local mason_lspconfig = safe_require("mason-lspconfig")
local mason_tool_installer = safe_require("mason-tool-installer")

if mason and mason_lspconfig then
  mason.setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    }
  })

  mason_lspconfig.setup({
    ensure_installed = {
      "cssls",
      "cypher_ls",
      "graphql",
      "html",
      "pyright",
      "sqlls",
      "svelte",
      "tailwindcss",
      "ts_ls",
      "volar"
    },
    automatic_installation = true
  })

  mason_tool_installer.setup({
    auto_update = false,
    run_on_start = true,
    integrations = {
      ['mason-lspconfig'] = true,
      ['mason-null-ls'] = true,
      ['mason-nvim-dap'] = true
    }
  })
end