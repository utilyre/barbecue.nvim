local template = require("barbecue.config.template")
local highlights = require("barbecue.config.highlights")

local M = {}

---user specified configurations
---@type BarbecueConfig
M.user = template

---merges `cfg` into `template` and sets it as `user`
---@param cfg BarbecueConfig
function M.apply_config(cfg)
  M.user = vim.tbl_deep_extend("force", template, cfg)

  if M.user.truncation.method ~= "simple" then
    vim.notify("barbecue: truncation methods other that 'simple' are not supported yet", vim.log.levels.WARN)
    M.user.truncation.method = "simple"
  end
end

---resorts to default highlight mappings if plugin specific highlights are not defined
function M.guarantee_highlights()
  for from, to in pairs(highlights) do
    vim.api.nvim_set_hl(0, from, {
      link = to,
      default = true,
    })
  end
end

return M
