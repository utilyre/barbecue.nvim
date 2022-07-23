local navic = require("nvim-navic")
local state = require("barbecue.state")
local utils = require("barbecue.utils")

local M = {}

---Configures and starts the plugin
---@param config table
M.setup = function(config)
  -- Merges `config` into `default_config` (prefres `config`)
  state.config = vim.tbl_deep_extend("force", state.default_config, config)

  navic.setup({
    separator = state.config.separator,
    icons = state.config.icons,
  })

  local Barbecue = vim.api.nvim_create_augroup("Barbecue", {})
  vim.api.nvim_create_autocmd(state.config.update_events, {
    group = Barbecue,
    callback = function(args)
      local winnr = vim.api.nvim_get_current_win()

      -- FIXME: Pass `args.buf` and `winnr` when `update_context` from nvim-navic is fixed
      if utils.excludes(0, 0) then
        vim.wo[winnr].winbar = nil
        return
      end

      -- FIXME: Remove this schedule after `update_context` from nvim-navic is fixed
      vim.schedule(function()
        local dirname, filename, highlight, icon = utils.get_buf_metadata(args.file, args.buf)
        local location = utils.get_location()

        if filename == "" then
          return
        end

        local winbar = state.config.prefix
          .. utils.str_gsub(dirname, "/", utils.str_escape(state.config.separator), 2)
          .. ((icon == nil or highlight == nil) and "" or "%#" .. highlight .. "#" .. icon .. "%* ")
          .. "%#"
          .. (vim.bo[args.buf].modified and "BufferCurrentMod" or "BufferCurrent")
          .. "#"
          .. filename
          .. "%*"

        if location ~= nil then
          winbar = winbar .. state.config.separator .. location
        end

        vim.wo[winnr].winbar = winbar
      end)
    end,
  })
end

return M
