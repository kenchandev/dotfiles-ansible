local safe_require = require("utils").safe_require

local util = safe_require("formatter.util")
local formatter = safe_require("formatter")
local formatter_filetypes_any = safe_require("formatter.filetypes.any")
local formatter_filetypes_lua = safe_require("formatter.filetypes.lua")
local formatter_filetypes_python = safe_require("formatter.filetypes.python")
local formatter_filetypes_rust = safe_require("formatter.filetypes.rust")

if util and formatter then
  local eslint_d = function()
    return {
      exe = "eslint_d",
      try_node_modules = true,
      cwd = util.get_current_buffer_file_dir(),
      args = {
        "--stdin",
        "--stdin-filename",
        util.escape_path(util.get_current_buffer_file_path()),
        "--fix-to-stdout"
      },
      stdin = true
    }
  end

  local prettier = function()
    return {
      exe = "prettier",
      try_node_modules = true,
      args = {
        "--stdin-filepath",
        util.escape_path(util.get_current_buffer_file_path())
      },
      cwd = util.get_current_buffer_file_dir(),
      stdin = true
    }
  end

  formatter.setup({
    filetype = {
      astro = {
        prettier
      },
      javascript = {
        eslint_d,
        prettier
      },
      javascriptreact = {
        eslint_d,
        prettier
      },
      json = {
        prettier
      },
      lua = {
        formatter_filetypes_lua.stylua
      },
      python = {
        formatter_filetypes_python.black
      },
      rust = {
        formatter_filetypes_rust.rustfmt
      },
      svelte = {
        eslint_d,
        prettier
      },
      typescript = {
        eslint_d,
        prettier
      },
      typescriptreact = {
        eslint_d,
        prettier
      },
      yaml = {
        prettier
      },
      -- Use the special "*" file type for defining formatter configurations on any file type.
      ["*"] = {
        formatter_filetypes_any.remove_trailing_whitespace
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
