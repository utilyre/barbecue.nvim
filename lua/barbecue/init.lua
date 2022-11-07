local config = require("barbecue.config")
local ui = require("barbecue.ui")
local utils = require("barbecue.utils")

local M = {}

local function create_user_command(actions)
  local subcommands = utils.tbl_map(actions, function(_, subcommand)
    return subcommand
  end)

  vim.api.nvim_create_user_command("Barbecue", function(params)
    if #params.fargs < 1 then
      vim.notify("no subcommand is provided", vim.log.levels.ERROR)
      return
    end

    local subcommand = params.fargs[1]
    local action = actions[subcommand]
    if action == nil then
      vim.notify(("'%s' is not a subcommand"):format(subcommand), vim.log.levels.ERROR)
      return
    end

    action()
  end, {
    nargs = "*",
    complete = function(_, line)
      local args = vim.split(line, "%s+")
      if #args ~= 2 then
        return {}
      end

      return vim.tbl_filter(function(subcommand)
        return vim.startswith(subcommand, args[2])
      end, subcommands)
    end,
  })
end

---@deprecated
function M.update(winnr)
  vim.notify(
    "require(\"barbecue\").update is deprecated now, use require(\"barbecue.ui\"):update instead",
    vim.log.levels.WARN
  )

  ui:update(winnr)
end

---@deprecated
function M.toggle(shown)
  vim.notify(
    "require(\"barbecue\").toggle is deprecated now, use require(\"barbecue.ui\"):toggle instead",
    vim.log.levels.WARN
  )

  ui:toggle(shown)
end

---configures and starts the plugin
---@param cfg BarbecueTemplateConfig
function M.setup(cfg)
  config:apply(cfg)

  -- resorts to built-in and nvim-cmp highlight groups if nvim-navic highlight groups are not defined
  for from, to in pairs(config.highlights) do
    vim.api.nvim_set_hl(0, from, {
      link = to,
      default = true,
    })
  end

  if config.user.create_autocmd then
    vim.api.nvim_create_autocmd({
      "BufWinEnter",
      "BufWritePost",
      "CursorMoved",
      "TextChanged",
      "TextChangedI",
    }, {
      group = vim.api.nvim_create_augroup("barbecue", {}),
      callback = function(a)
        for _, winnr in ipairs(vim.api.nvim_list_wins()) do
          if a.buf == vim.api.nvim_win_get_buf(winnr) then
            ui:update(winnr)
          end
        end
      end,
    })
  end

  create_user_command({
    hide = function()
      ui:toggle(false)
    end,
    show = function()
      ui:toggle(true)
    end,
    toggle = function()
      ui:toggle()
    end,
  })
end

return M
