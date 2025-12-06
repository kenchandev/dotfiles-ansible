local safe_require = require("utils.module").safe_require

local onedark = safe_require("onedark")

if onedark then
  onedark.setup({
    style = 'darker'
  })

  onedark.load()
end


