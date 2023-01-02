local template = require("barbecue.config.template")

local M = {}

---user specified configurations
---@type barbecue.Config
M.user = template

---merges `cfg` into `template` and sets it as `user`
---@param cfg barbecue.Config
function M.apply(cfg)
  M.user = vim.tbl_deep_extend("force", template, cfg)
end

return M
