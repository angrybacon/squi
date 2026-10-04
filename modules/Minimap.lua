---@type string, Squi
local _, S = ...

local MARGIN = 20

local function ConfigurePosition()
  S.Commons.ConfigureLayout({
    [Enum.EditModeSystem.Minimap] = {
      anchor = {
        anchor = "BOTTOMRIGHT",
        anchored = "BOTTOMRIGHT",
        on = "UIParent",
        x = -MARGIN,
        y = MARGIN,
      },
    },
  })
  MinimapCluster.MinimapContainer:SetPoint("TOP", MinimapCluster, "TOP", 0, 0)
end

local function ConfigureSize()
  local width, height = MinimapCluster.MinimapContainer.Minimap:GetSize()
  MinimapCluster:SetHeight(height)
  MinimapCluster:SetWidth(width)
  MinimapCluster.MinimapContainer:SetHeight(height)
  MinimapCluster.MinimapContainer:SetWidth(width)
  MinimapBackdrop:SetHeight(height)
  MinimapBackdrop:SetWidth(width)
end

---Enable every tracking kind except the ones listed
---@param ... string
local function ConfigureTracking(...)
  local exceptions = tInvert({ ... })
  for index = 1, C_Minimap.GetNumTrackingTypes() do
    local name = C_Minimap.GetTrackingInfo(index).name
    C_Minimap.SetTracking(index, not exceptions[name])
  end
end

local function ConfigureZoom()
  Minimap:SetZoom(Minimap:GetZoomLevels() - 1)
end

table.insert(S.Modules, function()
  SetCVar("rotateMinimap", "1")
  S.Commons.Hide(GameTimeFrame)
  S.Commons.Hide(Minimap.ZoomIn)
  S.Commons.Hide(Minimap.ZoomOut)
  S.Commons.Hide(MinimapCluster.BorderTop)
  S.Commons.Hide(MinimapCluster.Tracking)
  S.Commons.Hide(MinimapCluster.ZoneTextButton)
  S.Commons.Hide(MinimapZoneText)
  S.Commons.Hide(TimeManagerClockButton)
  ConfigurePosition()
  ConfigureSize()
  ConfigureTracking("Low-Level Quests", "Track Pets", "Transmogrifier")
  ConfigureZoom()
end)
