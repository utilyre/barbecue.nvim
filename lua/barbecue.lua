local navic = require("nvim-navic")
local config = require("barbecue.config")
local theme = require("barbecue.theme")
local ui = require("barbecue.ui")
local utils = require("barbecue.utils")

local M = {}

---attaches navic to capable language servers on initialization
local function attach_navic()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("barbecue#attach_navic", {}),
    callback = function(a)
      local client = vim.lsp.get_client_by_id(a.data.client_id)
      if client.server_capabilities["documentSymbolProvider"] then
        navic.attach(client, a.buf)
      end
    end,
  })
end

---creates the main autocmd
local function create_autocmd()
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
    group = vim.api.nvim_create_augroup("barbecue#create_autocmd", {}),
    callback = function()
      ui.update()
    end,
  })
end

---configures and starts barbecue
---@param cfg barbecue.Config?
function M.setup(cfg)
  config.apply(cfg or {})
  theme.load()

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("barbecue#colorscheme", {}),
    callback = function()
      theme.load()
    end,
  })

  if config.user.attach_navic then attach_navic() end
  if config.user.create_autocmd then create_autocmd() end

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
