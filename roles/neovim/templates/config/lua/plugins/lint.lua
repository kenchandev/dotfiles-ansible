local safe_require = require("utils.module").safe_require

local lint = safe_require("lint")

if lint then
  lint.linters_by_ft = {
    python = {
      "flake8",
      "pylint"
    },
    rust = {
      "clippy"
    },
    lua = {
      "luacheck"
    },
    yaml = {
      "yamllint"
    }
  }
end