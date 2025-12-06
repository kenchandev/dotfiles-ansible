local M = {}

M.safe_require = function(module)
  local status, result = pcall(require, module)

  if not status then
    vim.notify(
      string.format("Error loading module \"%s\": %s", module, result),
      vim.log.levels.ERROR
    )

    return nil
  end

  return result
end

return M