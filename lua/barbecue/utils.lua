local navic = require("nvim-navic")
local barbecue = require("barbecue")

local U = {}

---Escapes the given string from lua regex
---@param str string
---@return string
U.str_escape = function(str)
  local escaped = str:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1")
  return escaped
end

---Subsitutes string within range
---@param str string
---@param patt string
---@param repl string
---@param from integer?
---@param to integer?
---@return string
U.str_gsub = function(str, patt, repl, from, to)
  from = from or 1
  to = to or str:len()
  return str:sub(1, from - 1) .. str:sub(from, to):gsub(patt, repl) .. str:sub(to + 1, str:len())
end

---Returns `true` if current buffer should be excluded otherwise returns `false`
---@param buffnr number
---@param winnr number
---@return boolean
U.excludes = function(buffnr, winnr)
  local buftype = vim.api.nvim_buf_get_option(buffnr, "buftype")
  local relative = vim.api.nvim_win_get_config(winnr).relative

  return not vim.tbl_contains(barbecue.config.include_buftypes, buftype) or (barbecue.config.exclude_float and relative ~= "")
end

---Returns all the information about the current buffer
---@param filepath string
---@param buffnr number
---@return string filepath
---@return string filename
---@return string icon
---@return string highlight
U.get_buf_metadata = function(filepath, buffnr)
  -- Gets the current buffer filepath with trailing slash
  local dirname = vim.fn.fnamemodify(filepath, (barbecue.config.tilde_home and ":~" or "") .. ":.:h") .. "/"
  -- Treats the first slash as directory instead of separator
  if dirname ~= "//" and dirname:sub(1, 1) == "/" then
    dirname = "/" .. dirname
  end
  -- Won't show the filepath if the file is in the current working directory
  if dirname == "./" then
    dirname = ""
  end

  -- Obtains the current buffer icon and highlight group via web-devicons (optional)
  local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
  local icon, highlight = nil, nil
  if devicons_ok then
    local filetype = vim.api.nvim_buf_get_option(buffnr, "filetype")
    icon, highlight = devicons.get_icon_by_filetype(filetype)
  end

  -- Gets the current buffer name
  local filename = vim.fn.fnamemodify(filepath, ":t")

  return dirname, filename, highlight, icon
end

---Returns the current location of cursor
---@return string
U.get_location = function()
  local location = nil
  if navic.is_available() then
    location = navic.get_location()
    location = location == "" and barbecue.config.no_info_indicator or location
  end

  return location
end

return U
