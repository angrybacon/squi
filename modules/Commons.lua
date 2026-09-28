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

  ---Draw a solid outline inward, overlaid on top of the region's own edges
  ---@param region table
  ---@param thickness "thin" | "thick"
  ---@param color colorRGBA
  Outline = function(region, thickness, color)
    local function CreateEdge()
      local texture = region:CreateTexture(nil, "OVERLAY")
      texture:SetColorTexture(color:GetRGBA())
      return texture
    end
    local size = thickness == "thick" and 4 or 2
    local bottom = CreateEdge()
    bottom:SetPoint("BOTTOMLEFT", region, "BOTTOMLEFT", 0, 0)
    bottom:SetPoint("BOTTOMRIGHT", region, "BOTTOMRIGHT", 0, 0)
    bottom:SetHeight(size)
    local left = CreateEdge()
    left:SetPoint("TOPLEFT", region, "TOPLEFT", 0, 0)
    left:SetPoint("BOTTOMLEFT", region, "BOTTOMLEFT", 0, 0)
    left:SetWidth(size)
    local right = CreateEdge()
    right:SetPoint("TOPRIGHT", region, "TOPRIGHT", 0, 0)
    right:SetPoint("BOTTOMRIGHT", region, "BOTTOMRIGHT", 0, 0)
    right:SetWidth(size)
    local top = CreateEdge()
    top:SetPoint("TOPLEFT", region, "TOPLEFT", 0, 0)
    top:SetPoint("TOPRIGHT", region, "TOPRIGHT", 0, 0)
    top:SetHeight(size)
  end,
}

S.Commons = Commons
