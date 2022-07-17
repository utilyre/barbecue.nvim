local M = {}

local default_opts = {
  exclude_float = true,
  include_buftypes = { "" },

  update_events = {
    "BufWinEnter",
    "BufWritePost",
    "CursorMoved",
    "CursorMovedI",
    "TextChanged",
    "TextChangedI",
  },

  tilde_home = true,
  prefix = " ",
  separator = " > ",
  no_info_indicator = "…",
  icons = {
    File = " ",
    Module = " ",
    Namespace = " ",
    Package = " ",
    Class = " ",
    Method = " ",
    Property = " ",
    Field = " ",
    Constructor = " ",
    Enum = "練",
    Interface = "練",
    Function = " ",
    Variable = " ",
    Constant = " ",
    String = " ",
    Number = " ",
    Boolean = "◩ ",
    Array = " ",
    Object = " ",
    Key = " ",
    Null = "ﳠ ",
    EnumMember = " ",
    Struct = " ",
    Event = " ",
    Operator = " ",
    TypeParameter = " ",
  },
}

---Returns `true` if current buffer should be excluded otherwise returns `false`
---@param buffnr number
---@param winnr number
---@return boolean
local excludes = function(buffnr, winnr)
  local buftype = vim.api.nvim_buf_get_option(buffnr, "buftype")
  local relative = vim.api.nvim_win_get_config(winnr).relative

  return not vim.tbl_contains(vim.g.barbecue.include_buftypes, buftype)
      or (vim.g.barbecue.exclude_float and relative ~= "")
end

---Escapes the given string from lua regex
---@param str string
---@return string
local str_escape = function(str)
  return str:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1")
end

---Subsitutes string within range
---@param str string
---@param patt string
---@param repl string
---@param from integer?
---@param to integer?
---@return string
local str_gsub = function(str, patt, repl, from, to)
  from = from or 1
  to = to or str:len()
  return str:sub(1, from - 1) .. str:sub(from, to):gsub(patt, repl) .. str:sub(to + 1, str:len())
end

---Returns all the information about the current buffer
---@param buffnr number
---@return string filepath
---@return string filename
---@return string icon
---@return string highlight
local get_buf_metadata = function(buffnr)
  -- Gets the current buffer filepath with trailing slash
  local filepath = vim.fn.expand("<afile>" .. (vim.g.barbecue.tilde_home and ":~" or "") .. ":.:h") .. "/"
  -- Treats the first slash as directory instead of separator
  if filepath ~= "//" and filepath:sub(1, 1) == "/" then
    filepath = "/" .. filepath
  end
  -- Won't show the filepath if the file is in the current working directory
  if filepath == "./" then
    filepath = ""
  end

  -- Obtains the current buffer icon and highlight group via web-devicons (optional)
  local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
  local icon, highlight = nil, nil
  if devicons_ok then
    local filetype = vim.api.nvim_buf_get_option(buffnr, "filetype")
    icon, highlight = devicons.get_icon_by_filetype(filetype)
  end

  -- Gets the current buffer name
  local filename = vim.fn.expand("<afile>:t")

  return filepath, filename, icon, highlight
end

---Returns the current location of cursor
---@return string
local get_location = function()
  local navic = require("nvim-navic")

  local location = nil
  if navic.is_available() then
    location = navic.get_location()
    location = location == "" and vim.g.barbecue.no_info_indicator or location
  end

  return location
end

M.setup = function(opts)
  -- Merges the user opts into default opts (prefres user opts)
  vim.g.barbecue = vim.tbl_deep_extend("force", default_opts, opts)

  local navic = require("nvim-navic")
  navic.setup({
    separator = vim.g.barbecue.separator,
    icons = vim.g.barbecue.icons,
  })

  local gBarbecue = vim.api.nvim_create_augroup("Barbecue", {})
  vim.api.nvim_create_autocmd(vim.g.barbecue.update_events, {
    group = gBarbecue,
    callback = function()
      local buffnr = vim.api.nvim_get_current_buf()
      local winnr = vim.api.nvim_get_current_win()

      local filepath, filename, icon, highlight = get_buf_metadata(buffnr)
      if filename == "" then
        return
      end

      vim.schedule(function()
        if excludes(buffnr, winnr) then
          vim.opt_local.winbar = nil
          return
        end

        local location = get_location()

        vim.opt_local.winbar = vim.g.barbecue.prefix
            .. str_gsub(filepath, "/", str_escape(vim.g.barbecue.separator), 2)
            .. ((icon == nil or highlight == nil) and "" or "%#" .. highlight .. "#" .. icon .. "%* ")
            .. "%#"
            .. (vim.bo.modified and "BufferCurrentMod" or "BufferCurrent")
            .. "#"
            .. filename
            .. "%*"

        if location ~= nil then
          vim.opt_local.winbar:append(vim.g.barbecue.separator .. location)
        end
      end)
    end,
  })
end

return M
