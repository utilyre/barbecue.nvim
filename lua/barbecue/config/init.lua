local highlights = require("barbecue.config.highlights")
local default = require("barbecue.config.default")

---@class BarbecueConfig
---@field highlights BarbecueHighlightsConfig
---@field default BarbecueDefaultConfig
---@field user BarbecueDefaultConfig

local instance = nil

local Config = {}

Config.prototype = {}
Config.mt = {}

Config.prototype.highlights = highlights
Config.prototype.default = default

---instantiates a new instance
---@param cfg BarbecueDefaultConfig
---@return BarbecueConfig
function Config:new(cfg)
  local config = Config.prototype
  config.user = vim.tbl_deep_extend("force", config.default, cfg)

  return setmetatable(config, Config.mt)
end

---instantiates or returns the singleton instance
---@param cfg BarbecueDefaultConfig?
---@return BarbecueConfig
function Config:get_instance(cfg)
  if instance == nil then
    instance = self:new(cfg or Config.prototype.default)
  end

  return instance
end

return Config
