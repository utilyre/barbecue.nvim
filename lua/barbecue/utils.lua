local M = {}

---escapes `str` from winbar expansion
---@param str string
---@return string
function M.str_escape(str)
  str = str:gsub("%%", "%%%%")
  str = str:gsub("\n", " ")
  return str
end

---returns number of UTF-8 chars in `str`
---@param str string
---@return number
function M.str_len(str)
  local _, count = str:gsub("[^\128-\193]", "")
  return count
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
      vim.notify(
        string.format("'%s' is not a subcommand", subcommand),
        vim.log.levels.ERROR
      )
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
