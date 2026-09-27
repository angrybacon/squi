---@type string, Squi
local _, S = ...

---Enable every tracking kind except the ones listed
---@param ... string
local function ResetTracking(...)
  local exceptions = tInvert({ ... })
  for index = 1, C_Minimap.GetNumTrackingTypes() do
    local name = C_Minimap.GetTrackingInfo(index).name
    C_Minimap.SetTracking(index, not exceptions[name])
  end
end

local function SetMinimap()
  S.Commons.Hide(GameTimeFrame)
  S.Commons.Hide(Minimap.ZoomIn)
  S.Commons.Hide(Minimap.ZoomOut)
  S.Commons.Hide(MinimapCluster.BorderTop)
  S.Commons.Hide(MinimapCluster.Tracking)
  S.Commons.Hide(MinimapCluster.ZoneTextButton)
  S.Commons.Hide(MinimapZoneText)
  S.Commons.Hide(TimeManagerClockButton)
end

local function SetMinimapPosition()
  local margin = 10
  MinimapCluster:ClearAllPoints()
  MinimapCluster:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -margin, margin)
  MinimapCluster.MinimapContainer:SetPoint("TOP", MinimapCluster, "TOP", 0, 0)
end

local function SetMinimapSize()
  local width, height = MinimapCluster.MinimapContainer.Minimap:GetSize()
  MinimapCluster:SetHeight(height)
  MinimapCluster:SetWidth(width)
  MinimapCluster.MinimapContainer:SetHeight(height)
  MinimapCluster.MinimapContainer:SetWidth(width)
  MinimapBackdrop:SetHeight(height)
  MinimapBackdrop:SetWidth(width)
end

table.insert(S.Modules, function()
  SetCVar("rotateMinimap", "1")
  SetMinimap()
  SetMinimapPosition()
  SetMinimapSize()
  ResetTracking("Low-Level Quests", "Track Pets", "Transmogrifier")
end)
