---Get highlight group value by name.
---
---@param name string String for looking up highlight group.
---@return table
local function hl(name)
  local highlight = vim.api.nvim_get_hl_by_name(name, true)
  setmetatable(highlight, {
    __index = function(self, key)
      if key == "bg" then return self.background end
      if key == "fg" then return self.foreground end

      return nil
    end,
  })

  return highlight
end

---@alias barbecue.Theme table<string, table>
---@type barbecue.Theme
local M = {
  normal = { bg = hl("Normal").bg, fg = hl("Normal").fg },

  ellipsis = { fg = hl("Conceal").fg },
  separator = { fg = hl("Conceal").fg },
  modified = { fg = hl("String").fg },
  diagnostics = { fg = "red" },

  dirname = { fg = hl("Conceal").fg },
  basename = { bold = true },
  context = {},

  context_file = { fg = hl("Structure").fg },
  context_module = { fg = hl("Structure").fg },
  context_namespace = { fg = hl("Structure").fg },
  context_package = { fg = hl("Structure").fg },
  context_class = { fg = hl("Structure").fg },
  context_method = { fg = hl("Function").fg },
  context_property = { fg = hl("Identifier").fg },
  context_field = { fg = hl("Identifier").fg },
  context_constructor = { fg = hl("Structure").fg },
  context_enum = { fg = hl("Type").fg },
  context_interface = { fg = hl("Type").fg },
  context_function = { fg = hl("Function").fg },
  context_variable = { fg = hl("Identifier").fg },
  context_constant = { fg = hl("Constant").fg },
  context_string = { fg = hl("String").fg },
  context_number = { fg = hl("Number").fg },
  context_boolean = { fg = hl("Boolean").fg },
  context_array = { fg = hl("Structure").fg },
  context_object = { fg = hl("Structure").fg },
  context_key = { fg = hl("Identifier").fg },
  context_null = { fg = hl("Special").fg },
  context_enum_member = { fg = hl("Identifier").fg },
  context_struct = { fg = hl("Structure").fg },
  context_event = { fg = hl("Type").fg },
  context_operator = { fg = hl("Operator").fg },
  context_type_parameter = { fg = hl("Type").fg },
}

return M
