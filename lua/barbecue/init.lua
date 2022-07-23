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
      vim.schedule(function()
        if utils.excludes(0, 0) then
          vim.opt_local.winbar = nil
          return
        end

        local dirname, filename, highlight, icon = utils.get_buf_metadata(args.file, args.buf)
        local location = utils.get_location()

        if filename == "" then
          return
        end

        vim.opt_local.winbar = state.config.prefix
          .. utils.str_gsub(dirname, "/", utils.str_escape(state.config.separator), 2)
          .. ((icon == nil or highlight == nil) and "" or "%#" .. highlight .. "#" .. icon .. "%* ")
          .. "%#"
          .. (vim.bo.modified and "BufferCurrentMod" or "BufferCurrent")
          .. "#"
          .. filename
          .. "%*"

        if location ~= nil then
          vim.opt_local.winbar:append(state.config.separator .. location)
        end
      end)
    end,
  })
end

return M
