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
    highlight = true,
  })

  vim.api.nvim_create_augroup("barbecue", {})
  vim.api.nvim_create_autocmd(state.config.update_events, {
    group = "barbecue",
    callback = function(a)
      local winnr = utils.get_buf_win(a.buf)
      if winnr == nil then
        return
      end

      if utils.excludes(a.buf, winnr) then
        vim.wo[winnr].winbar = nil
        return
      end

      -- FIXME: Remove this schedule after `update_context` from nvim-navic is fixed
      vim.schedule(function()
        -- Sometimes `winnr` might not be valid due to schedule call
        if not vim.api.nvim_win_is_valid(winnr) then
          return
        end
        -- Checks if `bufnr` is still inside `winnr`
        if a.buf ~= vim.api.nvim_win_get_buf(winnr) then
          return
        end

        local dirname, filename, highlight, icon = utils.get_buf_metadata(a.file, a.buf)
        local context = utils.get_context()

        if filename == "" then
          return
        end

        local winbar = state.config.prefix
          .. "%#NavicText#"
          .. utils.str_gsub(
            dirname,
            "/",
            utils.str_escape("%*%#NavicSeparator#" .. state.config.separator .. "%*%#NavicText#"),
            2
          )
          .. "%*"
          .. ((icon == nil or highlight == nil) and "" or "%#" .. highlight .. "#" .. icon .. "%* ")
          .. "%#NavicText#"
          .. filename
          .. "%*"

        if context ~= nil then
          winbar = winbar .. "%#NavicSeparator#" .. state.config.separator .. "%*" .. context
        end

        vim.wo[winnr].winbar = winbar
      end)
    end,
  })
end

return M
