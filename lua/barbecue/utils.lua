local M = {}

---escapes `str` from winbar expansion
---@param str string
---@return string
function M.exp_escape(str)
  str = str:gsub("%%", "%%%%")
  str = str:gsub("\n", " ")
  return str
end

---escapes `str` from lua regex
---@param str string
---@return string
function M.str_escape(str)
  local escaped = str:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1")
  return escaped
end

---substitutes `str` within `from` and `to`
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

---applies `cb` to all values of `tbl`
---@generic K, V
---@param tbl table<K, V>
---@param cb fun(value: V, key: K): any, any
---@return table
function M.tbl_map(tbl, cb)
  local ret = {}
  for key, value in pairs(tbl) do
    local v, k = cb(value, key)
    ret[k or #ret + 1] = v
  end

  return ret
end

---removes `value` from `tbl`
---@generic V
---@param list V[]
---@param value V
function M.tbl_remove_by_value(list, value)
  for i, v in ipairs(list) do
    if v == value then
      table.remove(list, i)
      return
    end
  end
end

return M
