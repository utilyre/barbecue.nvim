local navic = require("nvim-navic")
local global = require("barbecue.global")
local utils = require("barbecue.utils")

local M = {}

---updates the winbar
---@param winnr number?
function M.update(winnr)
  winnr = winnr or vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_win_get_buf(winnr)

  if
    not global.is_shown
    or not vim.tbl_contains(global.config.include_buftypes, vim.bo[bufnr].buftype)
    or vim.tbl_contains(global.config.exclude_filetypes, vim.bo[bufnr].filetype)
    or vim.api.nvim_win_get_config(winnr).relative ~= ""
  then
    vim.wo[winnr].winbar = nil
    return
  end

  vim.schedule(function()
    if
      not vim.api.nvim_buf_is_valid(bufnr)
      or not vim.api.nvim_win_is_valid(winnr)
      or bufnr ~= vim.api.nvim_win_get_buf(winnr)
    then
      return
    end

    local dirname, basename = utils.buf_get_filename(bufnr)
    local icon, highlight = utils.buf_get_icon(bufnr)
    local context = utils.buf_get_context(winnr, bufnr)

    if basename == "" then
      return
    end

    local winbar = "%#NavicText#"
      .. global.config.symbols.prefix
      .. utils.str_gsub(
        utils.exp_escape(dirname),
        "/",
        utils.str_escape("%#NavicSeparator# " .. global.config.symbols.separator .. " %#NavicText#"),
        2
      )
      .. "%@v:lua.require'barbecue.mouse'.navigate_"
      .. winnr
      .. "_1_0@"
      .. ((icon == nil or highlight == nil) and "" or ("%#" .. highlight .. "#" .. icon .. " "))
      .. "%#NavicText#"
      .. utils.exp_escape(basename)
      .. "%X"
      .. (vim.bo[bufnr].modified and " %#BarbecueMod#" .. global.config.symbols.modified or "")
      .. context
      .. "%#NavicText#"

    local custom_section = global.config.custom_section(bufnr)
    if vim.tbl_contains({ "number", "string" }, type(custom_section)) then
      winbar = winbar .. "%=" .. custom_section
    end

    vim.wo[winnr].winbar = winbar
  end)
end

---toggles all the winbars
---@param shown boolean?
function M.toggle(shown)
  if shown == nil then
    shown = not global.is_shown
  end

  global.is_shown = shown
  for _, winnr in ipairs(vim.api.nvim_list_wins()) do
    M.update(winnr)
  end
end

---configures and starts the plugin
---@param config BarbecueConfig
function M.setup(config)
  global.config = vim.tbl_deep_extend("force", global.defaults.CONFIG, config or {})

  -- resorts to built-in and nvim-cmp highlight groups if nvim-navic highlight groups are not defined
  for from, to in pairs(global.defaults.HIGHLIGHTS) do
    vim.api.nvim_set_hl(0, from, {
      link = to,
      default = true,
    })
  end

  navic.setup()

  if global.config.create_autocmd then
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
            M.update(winnr)
          end
        end
      end,
    })
  end

  vim.api.nvim_create_user_command("Barbecue", function(params)
    if #params.fargs < 1 then
      return
    end

    local action = params.fargs[1]
    if action == "hide" then
      M.toggle(false)
    elseif action == "show" then
      M.toggle(true)
    elseif action == "toggle" then
      M.toggle()
    else
      vim.notify(("'%s' is not a subcommand"):format(action), vim.log.levels.ERROR, {
        title = "barbecue.nvim",
      })
    end
  end, {
    nargs = "*",
    complete = function(_, line)
      local args = vim.split(line, "%s+")
      if #args ~= 2 then
        return {}
      end

      return vim.tbl_filter(function(subcommand)
        return vim.startswith(subcommand, args[2])
      end, { "show", "hide", "toggle" })
    end,
  })
end

return M
