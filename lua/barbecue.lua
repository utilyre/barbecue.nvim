local config = require("barbecue.config")
local theme = require("barbecue.theme")
local ui = require("barbecue.ui")
local autocmd = require("barbecue.autocmd")

local M = {}

---Create the generic `Barbecue` command which can be run without any arguments
---to list all the available subcommands.
---
---It can potentially be followed by a subcommand to directly run a specific
---action.
---
---@param actions table<string, { [1]: fun(), desc: string? }> Subcommand to options mapping of some actions to be provided.
local function create_barbecue_command(actions)
  local subcommands = vim.tbl_keys(actions)

  vim.api.nvim_create_user_command("Barbecue", function(params)
    if #params.fargs == 0 then
      vim.ui.select(subcommands, {
        kind = "barbecue_subcommand",
        prompt = "Subcommands:",
        format_item = function(subcommand)
          local desc = actions[subcommand].desc
          if desc == nil then return subcommand end

          return string.format("%s (%s)", subcommand, desc)
        end,
      }, function(choice)
        if choice == nil then return end

        local action = actions[choice][1]
        action()
      end)

      return
    end

    local subcommand = params.fargs[1]
    local choice = actions[subcommand]
    if choice == nil then
      vim.notify(
        string.format("'%s' is not a subcommand", subcommand),
        vim.log.levels.ERROR
      )
      return
    end

    local action = actions[subcommand][1]
    action()
  end, {
    desc = "Run subcommands through this general command",
    nargs = "?",
    complete = function(_, line)
      local args = vim.split(line, "%s+")
      if #args ~= 2 then return {} end

      return vim.tbl_filter(
        function(subcommand) return vim.startswith(subcommand, args[2]) end,
        subcommands
      )
    end,
  })
end

---Load and setup the plugin with potentially a table of configurations.
---
---@param cfg barbecue.Config? Table of of configurations to override the default behavior.
function M.setup(cfg)
  config.apply(cfg or {})
  theme.load()

  autocmd.create_colorscheme_synchronizer()
  if config.user.attach_navic then autocmd.create_navic_attacher() end
  if config.user.create_autocmd then autocmd.create_updater() end

  create_barbecue_command({
    hide = {
      function() ui.toggle(false) end,
      desc = "Hides barbecue globally",
    },
    show = {
      function() ui.toggle(true) end,
      desc = "Shows barbecue globally",
    },
    toggle = {
      function() ui.toggle() end,
      desc = "Toggles barbecue globally",
    },
  })
end

return M
