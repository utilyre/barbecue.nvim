local template = require("barbecue.config.template")

local M = {}

---User configurations.
---
---@type barbecue.Config
M.user = template

---Merge configurations into default configurations and set it as user configurations.
---
---@param cfg barbecue.Config Configurations to be merged.
function M.apply(cfg) M.user = vim.tbl_deep_extend("force", template, cfg) end

return M
