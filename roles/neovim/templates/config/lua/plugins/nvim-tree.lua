local safe_require = require("utils.module").safe_require

local nvim_tree = safe_require("nvim-tree")

if nvim_tree then
  vim.g.loaded = 1
  vim.g.loaded_netrwPlugin = 1

  vim.opt.termguicolors = true

  vim.cmd([[ highlight NvimTreeIndentMarker guifg=#C678DD ]])

  nvim_tree.setup({
    renderer = {
      root_folder_label = ":t",
      icons = {
        glyphs = {
          folder = {
            arrow_closed = "",
            arrow_open = "",
          }
        }
      }
    },
    actions = {
      open_file = {
        window_picker = {
          enable = false
        }
      }
    },
    filters = {
      git_ignored = false,
      custom = {
        "^.git$"
      }
    }
  })

  local keymap = vim.keymap

  keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
  keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
  keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
  keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
end