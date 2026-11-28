---@type string, Squi
local _, S = ...

local MARGIN = 24

local function ConfigureFont()
  S.Fonts.Set(
    ObjectiveTrackerHeaderFont,
    { face = "Gothic", outline = false, scale = "Body1" }
  )
  S.Fonts.Set(
    ObjectiveTrackerLineFont,
    { face = "Sans", outline = true, scale = "Body2" }
  )
end

---Start stacking the panels on the left after the tracker
local function ConfigurePanels()
  local width = ObjectiveTrackerFrame:GetWidth()
  local scale = ObjectiveTrackerFrame:GetScale()
  -- NOTE Blizzard reads the offset every time it lays the panels out
  SetUIPanelLayoutAttribute("LEFT_OFFSET", MARGIN + width * scale + MARGIN)
end

local function ConfigurePosition()
  S.Commons.ConfigureLayout({
    [Enum.EditModeSystem.ObjectiveTracker] = {
      anchor = {
        anchor = "TOPLEFT",
        anchored = "TOPLEFT",
        on = "UIParent",
        x = MARGIN,
        y = -MARGIN,
      },
    },
  })
end

table.insert(S.Modules, function()
  ConfigureFont()
  ConfigurePanels()
  ConfigurePosition()
end)
