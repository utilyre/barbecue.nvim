local config = require("barbecue.config")
local theme = require("barbecue.theme")
local ui = require("barbecue.ui")
local autocmd = require("barbecue.autocmd")

local M = {}

---creates user command named `name` and defines subcommands according to `actions`
---@param actions table<string, fun()>
local function create_barbecue_command(actions)
  local subcommands = vim.tbl_keys(actions)

  vim.api.nvim_create_user_command("Barbecue", function(params)
    if #params.fargs < 1 then
      local msg = "Available subcommands:"
      for _, subcommand in ipairs(subcommands) do
        msg = string.format("%s\n  - %s", msg, subcommand)
      end

      vim.notify(msg, vim.log.levels.INFO)
      return
    end

    local subcommand = params.fargs[1]
    local action = actions[subcommand]
    if action == nil then
      vim.notify(
        string.format("'%s' is not a subcommand", subcommand),
        vim.log.levels.ERROR
      )
      return
    end

    action()
  end, {
    nargs = "*",
    complete = function(_, line)
      local args = vim.split(line, "%s+")
      if #args ~= 2 then return {} end

      return vim.tbl_filter(function(subcommand)
        return vim.startswith(subcommand, args[2])
      end, subcommands)
    end,
  })
end

---configures and starts barbecue
---@param cfg barbecue.Config?
function M.setup(cfg)
  config.apply(cfg or {})
  theme.load()

  autocmd.create_colorscheme_synchronizer()
  if config.user.attach_navic then autocmd.create_navic_attacher() end
  if config.user.create_autocmd then autocmd.create_updater() end

  create_barbecue_command({
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
