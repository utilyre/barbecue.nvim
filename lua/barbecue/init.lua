local navic = require("nvim-navic")
local consts = require("barbecue.consts")
local utils = require("barbecue.utils")

local M = {}

---@type table
M.config = consts.default_config

---Configures and starts the plugin
---@param config table
M.setup = function(config)
  -- Merges `config` into `default_config` (prefres `config`)
  M.config = vim.tbl_deep_extend("force", consts.default_config, config)

  navic.setup({
    separator = M.config.separator,
    icons = M.config.icons,
  })

  local Barbecue = vim.api.nvim_create_augroup("Barbecue", {})
  vim.api.nvim_create_autocmd(M.config.update_events, {
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

        vim.opt_local.winbar = M.config.prefix
          .. utils.str_gsub(dirname, "/", utils.str_escape(M.config.separator), 2)
          .. ((icon == nil or highlight == nil) and "" or "%#" .. highlight .. "#" .. icon .. "%* ")
          .. "%#"
          .. (vim.bo.modified and "BufferCurrentMod" or "BufferCurrent")
          .. "#"
          .. filename
          .. "%*"

        if location ~= nil then
          vim.opt_local.winbar:append(M.config.separator .. location)
        end
      end)
    end,
  })
end

return M
