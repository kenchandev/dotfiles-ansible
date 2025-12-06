local safe_require = require("utils.module").safe_require

local lualine = safe_require("lualine")

if lualine then
  local colors = {
    blue = "#4aa5f0",
    green = "#8cc265",
    purple = "#c162de",
    cyan = "#42b3c2",
    red1 = "#e05561",
    red2 = "#ff616e",
    yellow = "#d18f52",
    fg = "#abb2bf",
    bg = "#16191d",
    gray1 = "#9da5b4",
    gray2 = "#23272e",
    gray3 = "#3e4452"
  }

  local onedark_theme = {
    normal = {
      a = {
        fg = colors.bg,
        bg = colors.green,
        gui = "bold"
      },
      b = {
        fg = colors.fg,
        bg = colors.gray3
      },
      c = {
        fg = colors.fg,
        bg = colors.gray2
      },
    },
    command = {
      a = {
        fg = colors.bg,
        bg = colors.yellow,
        gui = "bold"
      }
    },
    insert = {
      a = {
        fg = colors.bg,
        bg = colors.blue,
        gui = "bold"
      }
    },
    visual = {
      a = {
        fg = colors.bg,
        bg = colors.purple,
        gui = "bold"
      }
    },
    terminal = {
      a = {
        fg = colors.bg,
        bg = colors.cyan,
        gui = "bold"
      }
    },
    replace = {
      a = {
        fg = colors.bg,
        bg = colors.red1,
        gui = "bold"
      }
    },
    inactive = {
      a = {
        fg = colors.gray1,
        bg = colors.bg,
        gui = "bold"
      },
      b = {
        fg = colors.gray1,
        bg = colors.bg
      },
      c = {
        fg = colors.gray1,
        bg = colors.gray2
      }
    }
  }

  lualine.setup({
    options = {
      theme = onedark_theme
    }
  })
end