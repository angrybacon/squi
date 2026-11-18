---@type string, Squi
local _, S = ...

---Minimap container has hardcoded padding
local MARGIN = 0
local SIZE = 120

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
      settings = {
        [Enum.EditModeMinimapSetting.Size] = S.Commons.SliderIndex(SIZE, 50),
      },
    },
  })
  MinimapCluster.MinimapContainer:SetPoint("TOP", MinimapCluster, "TOP", 0, 0)
end

local function ConfigureSize()
  local container = MinimapCluster.MinimapContainer
  container:ClearAllPoints()
  container:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -MARGIN, MARGIN)
end

---Enable every tracking kind except the ones listed
---@param ... Enum.MinimapTrackingFilter
local function ConfigureTracking(...)
  local exceptions = tInvert({ ... })
  for index = 1, C_Minimap.GetNumTrackingTypes() do
    -- NOTE The filter is nil for tracking that comes from a spell
    local filter = C_Minimap.GetTrackingFilter(index)
    C_Minimap.SetTracking(index, not (filter and exceptions[filter.filterID]))
  end
end

local function ConfigureZoom()
  S.Commons.OnIndoorsChange(function(indoors)
    Minimap:SetZoom(indoors and Minimap:GetZoomLevels() - 2 or 1)
  end)
end

table.insert(S.Modules, function()
  SetCVar("rotateMinimap", "0")
  S.Commons.Hide(GameTimeFrame)
  S.Commons.Hide(MinimapCluster.DielFrame)
  S.Commons.Hide(MinimapCluster.MinimapContainer.PlayerCoords)
  S.Commons.Hide(MinimapCluster.Tracking)
  S.Commons.Hide(MinimapCluster.ZoneTextButton)
  S.Commons.Hide(TimeManagerClockButton)
  ConfigurePosition()
  ConfigureSize()
  ConfigureTracking(
    Enum.MinimapTrackingFilter.Barber,
    Enum.MinimapTrackingFilter.Stablemaster,
    Enum.MinimapTrackingFilter.Target,
    Enum.MinimapTrackingFilter.Transmogrifier,
    Enum.MinimapTrackingFilter.TrivialQuests
  )
  ConfigureZoom()
end)
