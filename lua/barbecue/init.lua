local navic = require("nvim-navic")

local G = require("barbecue.global")
local U = require("barbecue.utils")
local M = {}

---updates the winbar
---@param winnr number?
function M.update(winnr)
  winnr = winnr or vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_win_get_buf(winnr)

  if
    not G.is_shown
    or not vim.tbl_contains(G.config.include_buftypes, vim.bo[bufnr].buftype)
    or vim.tbl_contains(G.config.exclude_filetypes, vim.bo[bufnr].filetype)
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

    local dirname, basename = U.buf_get_filename(bufnr)
    local icon, highlight = U.buf_get_icon(bufnr)
    local context = U.buf_get_context(bufnr)

    if basename == "" then
      return
    end

    local winbar = "%#NavicText#"
      .. G.config.symbols.prefix
      .. U.str_gsub(
        dirname,
        "/",
        U.str_escape("%#NavicSeparator# " .. G.config.symbols.separator .. " %#NavicText#"),
        2
      )
      .. "%0@v:lua.require'barbecue'.on_click@"
      .. ((icon == nil or highlight == nil) and "" or ("%#" .. highlight .. "#" .. icon .. " "))
      .. "%#NavicText#"
      .. basename
      .. "%X"
      .. (vim.bo[bufnr].modified and " %#BarbecueMod#" .. G.config.symbols.modified or "")
      .. context
      .. "%#NavicText#"

    local custom_section = G.config.custom_section(bufnr)
    if vim.tbl_contains({ "number", "string" }, type(custom_section)) then
      winbar = winbar .. "%=" .. custom_section
    end

    vim.wo[winnr].winbar = winbar
  end)
end

---Handles mouse click on entries
---@param index number
---@param clicks number
---@param button string
---@param modifiers string
function M.on_click(index, clicks, button, modifiers)
  if button ~= "l" then
    return
  end

  local winnr = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_win_get_buf(winnr)

  -- Puts the cursor on the beginning of window
  if index == 0 then
    vim.api.nvim_win_set_cursor(winnr, { 1, 0 })
    return
  end

  local data = navic.get_data(bufnr)
  if index > #data then
    return
  end

  local entry = data[index]
  vim.api.nvim_win_set_cursor(winnr, {
    entry.scope.start.line,
    entry.scope.start.character,
  })
end

---toggles all the winbars
---@param shown boolean?
function M.toggle(shown)
  if shown == nil then
    shown = not G.is_shown
  end

  G.is_shown = shown
  for _, winnr in ipairs(vim.api.nvim_list_wins()) do
    M.update(winnr)
  end
end

---configures and starts the plugin
---@param config table
function M.setup(config)
  G.config = vim.tbl_deep_extend("force", G.defaults.CONFIG, config or {})

  -- resorts to built-in and nvim-cmp highlight groups if nvim-navic highlight groups are not defined
  for from, to in pairs(G.defaults.HIGHLIGHTS) do
    vim.api.nvim_set_hl(0, from, {
      link = to,
      default = true,
    })
  end

  navic.setup()

  if G.config.create_autocmd then
    vim.api.nvim_create_autocmd({
      "BufWinEnter",
      "BufWritePost",
      "CursorMoved",
      "CursorMovedI",
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
