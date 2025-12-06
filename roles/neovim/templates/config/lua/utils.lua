local utils = {}

local function safe_require(module)
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

local function get_venv_dir_path(dir_path)
  for p in vim.fs.parents(vim.fs.normalize(dir_path) .. "/") do
    local venv_dir_path = p .. "/.venv"

    if vim.fn.isdirectory(venv_dir_path) == 1 then
      return venv_dir_path
    end
  end
end

local function get_venv_bin_dir_path(venv_dir_path)
  if not venv_dir_path then
    return nil
  end

  local venv_bin_dir_path = venv_dir_path .. "/bin"

  if vim.fn.isdirectory(venv_bin_dir_path) ~= 1 then
    return nil
  end

  return venv_bin_dir_path
end

utils.safe_require = safe_require

return utils