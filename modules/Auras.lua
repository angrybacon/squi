---@type string, Squi
local _, S = ...

local GAP = 8
local MARGIN = 24
local SIZE = 150

local function ConfigurePosition()
  -- NOTE Blizzard uses a 50-200 slider and expects an index
  local size = (SIZE - 50) / 10
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
        settings = { [Enum.EditModeAuraFrameSetting.IconSize] = size },
      },
      [Enum.EditModeAuraFrameSystemIndices.DebuffFrame] = {
        anchor = {
          anchor = "BOTTOMRIGHT",
          anchored = "TOPRIGHT",
          on = "BuffFrame",
          x = -offset,
          y = -GAP,
        },
        settings = { [Enum.EditModeAuraFrameSetting.IconSize] = size },
      },
    },
  })
end

table.insert(S.Modules, function()
  S.Commons.Hide(BuffFrame.CollapseAndExpandButton)
  ConfigurePosition()
end)
