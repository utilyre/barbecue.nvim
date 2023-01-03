local navic = require("nvim-navic")
local config = require("barbecue.config")
local ui = require("barbecue.ui")
local utils = require("barbecue.utils")
local theme = require("barbecue.theme")

local M = {}

local PREFIX = "barbecue"

---attaches navic to capable LSPs on their initialization
function M.create_navic_attacher()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup(
      string.format("%s#attach_navic", PREFIX),
      {}
    ),
    callback = function(a)
      local client = vim.lsp.get_client_by_id(a.data.client_id)
      if client.server_capabilities["documentSymbolProvider"] then
        navic.attach(client, a.buf)
      end
    end,
  })
end

---updates winbar on necessary events
function M.create_updater()
  local events = {
    "WinScrolled",
    "BufWinEnter",
    "CursorMoved",
    "InsertLeave",
  }

  if config.user.show_modified then
    utils.tbl_merge(events, {
      "BufWritePost",
      "TextChanged",
      "TextChangedI",
    })
  end

  vim.api.nvim_create_autocmd(events, {
    group = vim.api.nvim_create_augroup(
      string.format("%s#create_autocmd", PREFIX),
      {}
    ),
    callback = function()
      ui.update()
    end,
  })
end

---keeps the theme in sync with the current colorscheme
function M.create_colorscheme_synchronizer()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup(
      string.format("%s#colorscheme", PREFIX),
      {}
    ),
    callback = function()
      theme.load()
    end,
  })
end

return M
