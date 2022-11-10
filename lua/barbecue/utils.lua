---@class BarbecueUtils
---@field exp_escape fun(self: BarbecueUtils, str: string): string escapes `str` from winbar expansion
---@field str_escape fun(self: BarbecueUtils, str: string): string escapes `str` from lua regex
---@field str_gsub fun(self: BarbecueUtils, str: string, patt: string, repl: string, from: number?, to: number?): string substitutes `str` within `from` and `to`
---@field tbl_map fun(self: BarbecueUtils, tbl: table, cb: fun(value: any, key: any)): table applies `cb` to all values of `tbl`
---@field tbl_insert_unique fun(self: BarbecueUtils, tbl: table, value: any)
---@field tbl_remove_by_value fun(self: BarbecueUtils, tbl: table, value: any)

local Utils = {}

---@type BarbecueUtils
Utils.prototype = {}
Utils.mt = {}

function Utils.prototype:exp_escape(str)
  str = str:gsub("%%", "%%%%")
  str = str:gsub("\n", " ")
  return str
end

function Utils.prototype:str_escape(str)
  local escaped = str:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1")
  return escaped
end

function Utils.prototype:str_gsub(str, patt, repl, from, to)
  from = from or 1
  to = to or str:len()
  return str:sub(1, from - 1) .. str:sub(from, to):gsub(patt, repl) .. str:sub(to + 1, str:len())
end

function Utils.prototype:tbl_map(tbl, cb)
  local ret = {}
  for key, value in pairs(tbl) do
    local v, k = cb(value, key)
    ret[k or #ret + 1] = v
  end

  return ret
end

function Utils.prototype:tbl_insert_unique(tbl, value)
  if vim.tbl_contains(tbl, value) then return end
  table.insert(tbl, value)
end

function Utils.prototype:tbl_remove_by_value(tbl, value)
  for i, v in ipairs(tbl) do
    if v == value then
      table.remove(tbl, i)
      return
    end
  end
end

---creates a new instance
---@return BarbecueUtils
function Utils:new()
  local utils = Utils.prototype
  return setmetatable(utils, Utils.mt)
end

return Utils:new()
