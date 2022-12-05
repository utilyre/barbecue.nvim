local navic = require("nvim-navic")
local config = require("barbecue.config")
local ui = require("barbecue.ui")
local utils = require("barbecue.utils")

local M = {}

---configures and starts barbecue
---@param cfg barbecue.Config?
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
    local events = {
      "WinScrolled",
      "BufWinEnter",
      "CursorMoved",
      "InsertLeave",
    }

    if config.user.symbols.modified ~= false then
      utils.tbl_merge(events, {
        "BufWritePost",
        "TextChanged",
        "TextChangedI",
      })
    end

    vim.api.nvim_create_autocmd(events, {
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
