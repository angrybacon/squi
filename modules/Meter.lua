---@type string, Squi
local _, S = ...

local MARGIN = 24

local function ConfigurePosition()
  S.Commons.ConfigureLayout({
    [Enum.EditModeSystem.DamageMeter] = {
      anchor = {
        anchor = "TOPRIGHT",
        anchored = "TOPLEFT",
        on = "ObjectiveTrackerFrame",
        x = MARGIN,
        y = 0,
      },
      settings = {
        [Enum.EditModeDamageMeterSetting.Numbers] = Enum.DamageMeterNumbers.Complete,
        [Enum.EditModeDamageMeterSetting.Padding] = 0,
        [Enum.EditModeDamageMeterSetting.Visibility] = Enum.DamageMeterVisibility.InGroup,
      },
    },
  })
end

table.insert(S.Modules, function()
  ConfigurePosition()
end)
