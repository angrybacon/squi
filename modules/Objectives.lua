---@type string, Squi
local _, S = ...

local MARGIN = 24

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
  ConfigurePosition()
end)
