local safe_require = require("utils.module").safe_require

local comment = safe_require("Comment")

if comment then
  comment.setup()
end