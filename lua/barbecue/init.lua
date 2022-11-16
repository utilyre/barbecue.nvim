local navic = require("nvim-navic")
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
---@param cfg BarbecueConfig?
function M.setup(cfg)
  config.apply_config(cfg or {})
  config.guarantee_highlights()

  local augroup = vim.api.nvim_create_augroup("barbecue", {})

  if config.user.attach_navic then
    vim.api.nvim_create_autocmd("LspAttach", {
      group = augroup,
      callback = function(a)
        local client = vim.lsp.get_client_by_id(a.data.client_id)
        if client.server_capabilities["documentSymbolProvider"] then navic.attach(client, a.buf) end
      end,
    })
  end

  if config.user.create_autocmd then
    vim.api.nvim_create_autocmd({
      "BufWinEnter",
      "BufWritePost",
      "CursorMoved",
      "InsertLeave",
      "TextChanged",
      "TextChangedI",
    }, {
      group = augroup,
      callback = function()
        ui.update()
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
