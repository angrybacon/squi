---@type string, Squi
local _, S = ...

local FONT_SIZE_HEADER = 16
local FONT_SIZE_BODY = 16
local MARGIN = 24

local function ConfigureFont()
  S.Fonts.Set(ObjectiveTrackerHeaderFont, {
    font = S.Fonts.Blackletter,
    outline = true,
    size = FONT_SIZE_HEADER,
  })
  S.Fonts.Set(ObjectiveTrackerLineFont, {
    font = S.Fonts.Sans,
    outline = true,
    size = FONT_SIZE_BODY,
  })
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
  ConfigurePosition()
end)
