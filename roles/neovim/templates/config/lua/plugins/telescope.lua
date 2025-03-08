local safe_require = require("utils").safe_require

local telescope = safe_require("telescope")
local telescope_actions = safe_require("telescope.actions")

if telescope and telescope_actions then
  telescope.setup({
    defaults = {
      path_display = { "truncate " },
      mappings = {
        i = {
          ["<C-a>"] = telescope_actions.select_all,
          ["<C-k>"] = telescope_actions.move_selection_previous,
          ["<C-j>"] = telescope_actions.move_selection_next,
          ["<C-q>"] = telescope_actions.send_selected_to_qflist + telescope_actions.open_qflist
        }
      }
    }
  })

  if pcall(function() telescope.load_extension("fzf") end) then
    print("Successfully loaded fzf extension.")
  end
end