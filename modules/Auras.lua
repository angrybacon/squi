---@type string, Squi
local _, S = ...

local MARGIN = 24

local function ConfigurePosition()
  local offset = BuffFrame.CollapseAndExpandButton:GetWidth()
  S.Commons.ConfigureLayout({
    [Enum.EditModeSystem.AuraFrame] = {
      [Enum.EditModeAuraFrameSystemIndices.BuffFrame] = {
        anchor = {
          anchor = "TOPRIGHT",
          anchored = "TOPRIGHT",
          on = "UIParent",
          x = offset - MARGIN,
          y = -MARGIN,
        },
      },
      [Enum.EditModeAuraFrameSystemIndices.DebuffFrame] = {
        anchor = {
          anchor = "BOTTOMRIGHT",
          anchored = "TOPRIGHT",
          on = "BuffFrame",
          x = -MARGIN,
          y = -MARGIN,
        },
      },
    },
  })
end

table.insert(S.Modules, function()
  S.Commons.Hide(BuffFrame.CollapseAndExpandButton)
  ConfigurePosition()
end)
