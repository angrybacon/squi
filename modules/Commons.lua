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
  ---@param thickness "thick" | "thin"
  ---@param color colorRGBA
  ---@return table edges
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
    return { top, right, bottom, left }
  end,

  -- NOTE Calling `SetPoint` or `ClearAllPoints` on a frame managed by edit mode
  --      taints `EditModeManagerFrame`, and that taint can later surface as
  --      unrelated secret-value errors on any other system. We wrap them and
  --      call those instead to bypass the taint entirely.
  ---@param frame table
  ---@param point string
  ---@param anchor table
  ---@param origin string
  ---@param x number
  ---@param y number
  SetPoint = function(frame, point, anchor, origin, x, y)
    local clear = frame.ClearAllPointsBase or frame.ClearAllPoints
    local set = frame.SetPointBase or frame.SetPoint
    local function Apply()
      clear(frame)
      set(frame, point, anchor, origin, x, y)
    end
    Apply()
    if frame.ApplySystemAnchor then
      hooksecurefunc(frame, "ApplySystemAnchor", Apply)
    end
    if EditModeManagerFrame then
      hooksecurefunc(EditModeManagerFrame, "UpdateBottomActionBarPositions", Apply)
      hooksecurefunc(EditModeManagerFrame, "UpdateRightActionBarPositions", Apply)
    end
  end,
}

S.Commons = Commons
