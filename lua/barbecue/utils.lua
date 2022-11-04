local M = {}

---escapes the given string from lua regex
---@param str string
---@return string
function M.str_escape(str)
  local escaped = str:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1")
  return escaped
end

---substitutes string within range
---@param str string
---@param patt string
---@param repl string
---@param from number?
---@param to number?
---@return string
function M.str_gsub(str, patt, repl, from, to)
  from = from or 1
  to = to or str:len()
  return str:sub(1, from - 1) .. str:sub(from, to):gsub(patt, repl) .. str:sub(to + 1, str:len())
end

---escapes the given string from winbar expansion
---@param str string
---@return string
function M.exp_escape(str)
  str = str:gsub("%%", "%%%%")
  str = str:gsub("\n", " ")
  return str
end

---applies callback to all values of tbl
---@param tbl table
---@param callback function
---@return table
function M.tbl_map(tbl, callback)
  local ret = {}
  for key, value in pairs(tbl) do
    local v, k = callback(value, key)
    ret[k or #ret + 1] = v
  end

  return ret
end

return M
