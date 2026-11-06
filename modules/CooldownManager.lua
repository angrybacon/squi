---@type string, Squi
local _, S = ...

local MARGIN = 4
---Same as the action bars, except Blizzard substracts a fixed 4
local PADDING = 6
local SIZE = 90

local function ConfigurePosition()
  S.Commons.ConfigureLayout({
    [Enum.EditModeSystem.CooldownViewer] = {
      [Enum.EditModeCooldownViewerSystemIndices.Essential] = {
        anchor = {
          anchor = "TOP",
          anchored = "BOTTOM",
          on = "MultiBarBottomLeft",
          x = 0,
          y = MARGIN,
        },
        settings = {
          [Enum.EditModeCooldownViewerSetting.IconPadding] = PADDING,
          [Enum.EditModeCooldownViewerSetting.IconSize] = S.Commons.SliderIndex(
            SIZE,
            50
          ),
        },
      },
    },
  })
end

table.insert(S.Modules, function()
  SetCVar("cooldownViewerEnabled", "0")
  ConfigurePosition()
end)
