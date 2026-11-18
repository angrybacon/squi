---@type string, Squi
local _, S = ...

local OFFSET = 120

local function ConfigurePosition()
  S.Commons.ConfigureLayout({
    [Enum.EditModeSystem.CooldownViewer] = {
      [Enum.EditModeCooldownViewerSystemIndices.Essential] = {
        anchor = {
          anchor = "CENTER",
          anchored = "TOP",
          on = "UIParent",
          x = 0,
          y = -OFFSET,
        },
      },
    },
  })
end

table.insert(S.Modules, function()
  SetCVar("cooldownViewerEnabled", "0")
  ConfigurePosition()
end)
