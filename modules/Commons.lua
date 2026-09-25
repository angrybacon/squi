---@type string, Squi
local _, S = ...

---@class Commons
local Commons = {
  ---Hide the region, keeping it hidden even if something else tries to show
  ---it again later
  ---@param region table
  Hide = function(region)
    region:Hide()
    if region.HookScript then
      region:HookScript("OnShow", region.Hide)
    end
  end,
}

S.Commons = Commons
