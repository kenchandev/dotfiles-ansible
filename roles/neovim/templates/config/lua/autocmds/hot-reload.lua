local M = {}

local uv = vim.uv
local watcher = nil
local debounce_timer = nil
local watched_path = nil

local function should_check()
  local mode = vim.api.nvim_get_mode().mode
  return not (
    mode:match "[cR!s]"
    or vim.fn.getcmdwintype() ~= ""
  )
end

local function should_reload_buffer(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
  local modified = vim.api.nvim_get_option_value("modified", { buf = buf })
  local is_real_file = name ~= "" and not name:match "^%w+://" -- Skip URIs

  return is_real_file and buftype == "" and not modified
end

local function get_visible_buffers()
  local visible = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    visible[vim.api.nvim_win_get_buf(win)] = true
  end
  return visible
end

local function find_buffer_by_filepath(filepath)
  local visible_buffers = get_visible_buffers()
  for buf, _ in pairs(visible_buffers) do
    if vim.api.nvim_buf_get_name(buf) == filepath then
      return buf
    end
  end
  return nil
end

local function join_path(...)
  if vim.fs and vim.fs.joinpath then
    return vim.fs.joinpath(...)
  else
    local parts = { ... }
    local sep = package.config:sub(1, 1)
    return table.concat(parts, sep)
  end
end

local function debounce(fn, delay)
  return function(...)
    local args = { ... }
    if debounce_timer then
      debounce_timer:close()
      debounce_timer = nil
    end
    debounce_timer = vim.defer_fn(function()
      if debounce_timer then
        debounce_timer = nil
      end
      fn((table.unpack or unpack)(args))
    end, delay)
  end
end

local function on_file_change(filepath, events)
  if not should_check() then
    return
  end

  local buf = find_buffer_by_filepath(filepath)
  if buf and should_reload_buffer(buf) then
    if vim.api.nvim_buf_is_valid(buf) then
      vim.cmd("checktime " .. buf)
    end
  end
end

local function start_watcher(path, debounce_delay)
  M.stop()

  path = vim.fn.fnamemodify(path, ":p"):gsub("/$", "")

  local fs_event = uv.new_fs_event()

  if not fs_event then
    vim.notify("Failed to create file watcher", vim.log.levels.WARN)
    return false
  end

  local on_change = debounce(function(err, filename, events)
    if not watcher then
      return
    end

    if err then
      vim.notify("File watcher error: " .. tostring(err), vim.log.levels.ERROR)
      M.stop()
      return
    end

    if filename then
      local full_path = join_path(path, filename)
      local ok, pcall_err = pcall(on_file_change, full_path, events)
      if not ok then
        vim.notify("Hotreload error: " .. tostring(pcall_err), vim.log.levels.ERROR)
      end
    end
  end, debounce_delay)

  local start_ok, start_err = fs_event:start(path, { recursive = false }, vim.schedule_wrap(on_change))

  if start_ok ~= 0 then
    fs_event:close()
    vim.notify(
      "Failed to start file watcher on " .. path .. ": " .. tostring(start_err or "unknown error"),
      vim.log.levels.WARN
    )
    return false
  end

  watcher = fs_event
  watched_path = path
  return true
end

M.setup = function(opts)
  opts = opts or {}

  vim.api.nvim_create_autocmd(
    { "FocusGained", "TermLeave", "BufEnter", "WinEnter", "CursorHold", "CursorHoldI" },
    {
      group = vim.api.nvim_create_augroup("hotreload", { clear = true }),
      callback = function()
        if should_check() then
          vim.cmd "checktime"
        end
      end,
    }
  )

  if opts.watch_dir then
    start_watcher(opts.watch_dir, opts.debounce or 100)
  end
end

M.stop = function()
  if watcher then
    watcher:stop()
    watcher = nil
  end

  if debounce_timer then
    debounce_timer:close()
    debounce_timer = nil
  end

  watched_path = nil
end

return M