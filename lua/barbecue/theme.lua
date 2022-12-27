local devicons_ok, devicons = pcall(require, "nvim-web-devicons")

local M = {}

---an abstraction layer for highlight groups
M.highlights = {
  normal = "barbecue_normal",
  ellipsis = "barbecue_ellipsis",
  separator = "barbecue_separator",
  modified = "barbecue_modified",

  dirname = "barbecue_dirname",
  basename = "barbecue_basename",
  context = "barbecue_context",

  context_file = "barbecue_context_file",
  context_module = "barbecue_context_module",
  context_namespace = "barbecue_context_namespace",
  context_package = "barbecue_context_package",
  context_class = "barbecue_context_class",
  context_method = "barbecue_context_method",
  context_property = "barbecue_context_property",
  context_field = "barbecue_context_field",
  context_constructor = "barbecue_context_constructor",
  context_enum = "barbecue_context_enum",
  context_interface = "barbecue_context_interface",
  context_function = "barbecue_context_function",
  context_variable = "barbecue_context_variable",
  context_constant = "barbecue_context_constant",
  context_string = "barbecue_context_string",
  context_number = "barbecue_context_number",
  context_boolean = "barbecue_context_boolean",
  context_array = "barbecue_context_array",
  context_object = "barbecue_context_object",
  context_key = "barbecue_context_key",
  context_null = "barbecue_context_null",
  context_enum_member = "barbecue_context_enum_member",
  context_struct = "barbecue_context_struct",
  context_event = "barbecue_context_event",
  context_operator = "barbecue_context_operator",
  context_type_parameter = "barbecue_context_type_parameter",
}

setmetatable(M.highlights, {
  __index = function(self, key)
    if type(key) ~= "string" then return nil end

    local parts = vim.split(key, "_")
    if #parts == 2 and parts[1] == "filetype" then
      local filetype = parts[2]

      local filetype_highlight = {}
      if devicons_ok then
        local _, foreground = devicons.get_icon_color_by_filetype(filetype, { default = true })
        if foreground ~= nil then filetype_highlight = { foreground = foreground } end
      end

      local name = string.format("barbecue_filetype_%s", filetype)
      vim.api.nvim_set_hl(
        0,
        name,
        vim.tbl_extend("force", vim.api.nvim_get_hl_by_name(M.highlights.normal, true), filetype_highlight)
      )

      self[key] = name
      return name
    end

    return nil
  end,
})

---sets the highlight groups according to `colorscheme`
---@param colorscheme string
function M.load(colorscheme)
  local theme_ok, theme = pcall(require, "barbecue.theme." .. colorscheme)
  if not theme_ok then theme = require("barbecue.theme.default") end

  for name, group in pairs(M.highlights) do
    vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", theme.normal, theme[name]))
  end
end

return M
