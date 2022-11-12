local config = require("barbecue.config")
local ui = require("barbecue.ui")
local utils = require("barbecue.utils")

local M = {}

---@deprecated
function M.update(winnr)
  vim.notify(
    "require(\"barbecue\").update is deprecated now, use require(\"barbecue.ui\").update instead",
    vim.log.levels.WARN
  )

  ui.update(winnr)
end

---@deprecated
function M.toggle(shown)
  vim.notify(
    "require(\"barbecue\").toggle is deprecated now, use require(\"barbecue.ui\").toggle instead",
    vim.log.levels.WARN
  )

  ui.toggle(shown)
end

---configures and starts barbecue
---@param cfg BarbecueTemplateConfig
function M.setup(cfg)
  config.apply_config(cfg)
  config.resort_highlights()

  if config.user.create_autocmd then
    vim.api.nvim_create_autocmd({
      "BufWinEnter",
      "BufWritePost",
      "CursorMoved",
      "InsertLeave",
      "TextChanged",
      "TextChangedI",
    }, {
      group = vim.api.nvim_create_augroup("barbecue", {}),
      callback = function(a)
        for _, winnr in ipairs(vim.api.nvim_list_wins()) do
          if a.buf == vim.api.nvim_win_get_buf(winnr) then ui.update(winnr) end
        end
      end,
    })
  end

  utils.create_user_command("Barbecue", {
    hide = function()
      ui.toggle(false)
    end,
    show = function()
      ui.toggle(true)
    end,
    toggle = function()
      ui.toggle()
    end,
  })
end

return M
