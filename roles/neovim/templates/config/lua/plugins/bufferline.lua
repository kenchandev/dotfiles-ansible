local safe_require = require("utils").safe_require

local bufferline = safe_require("bufferline")
local palette = safe_require("onedark.palette")

if bufferline and palette then
  bufferline.setup({
    options = {
      offsets = {
        {
          filetype = "NvimTree",
          text = "",
          separator = true,
          highlight = "NvimTreeNormal"
        }
      },
      diagnostics = "nvim_lsp",
      separator_style = "thin",
      modified_icon = "●",
      color_icons = true,
    },
    highlights = {
      buffer_visible = {
        fg = "white",
        bg = palette.darker.bg0
      },
      close_button = {
        fg = palette.darker.grey,
        bg = palette.darker.black
      },
      close_button_visible = {
        fg = "white",
        bg = palette.darker.bg0
      },
      close_button_selected = {
        fg = "white",
        bg = palette.darker.bg0
      },
      separator = {
        fg = palette.darker.bg_d,
        bg = palette.darker.black
      },
      separator_visible = {
        fg = palette.darker.bg_d,
        bg = palette.darker.bg0
      },
      separator_selected = {
        fg = palette.darker.bg_d,
        bg = palette.darker.bg0
      },
      offset_separator = {
        fg = palette.darker.bg3,
        bg = palette.darker.bg0
      },
      buffer_selected = {
        fg = "white",
        bg = palette.darker.bg0,
        bold = true
      },
      modified = {
        fg = palette.darker.dark_yellow,
        bg = palette.darker.black
      },
      modified_visible = {
        fg = palette.darker.yellow,
        bg = palette.darker.bg0
      },
      modified_selected = {
        fg = palette.darker.yellow,
        bg = palette.darker.bg0
      },
      fill = {
        bg = palette.darker.bg_d,
      },
      background = {
        fg = palette.darker.grey,
        bg = palette.darker.black
      }
    }
  })
end