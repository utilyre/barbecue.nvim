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

---merges one or more lists into `list`
---@param list any[]
---@param ... any[]
function M.tbl_merge(list, ...)
  for _, l in ipairs({ ... }) do
    for _, value in ipairs(l) do
      table.insert(list, value)
    end
  end
end

---creates user command named `name` and defines subcommands according to `actions`
---@param name string
---@param actions table<string, fun()>
function M.create_user_command(name, actions)
  local subcommands = vim.tbl_keys(actions)

  vim.api.nvim_create_user_command(name, function(params)
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
      vim.notify(string.format("'%s' is not a subcommand", subcommand), vim.log.levels.ERROR)
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

return M
