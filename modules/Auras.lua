---@type string, Squi
local _, S = ...

local MARGIN = 20

local function ConfigurePosition()
  local offset = BuffFrame.CollapseAndExpandButton:GetWidth()
  S.Commons.SetPoint(BuffFrame, "TOPRIGHT", UIParent, "TOPRIGHT", offset - MARGIN, -MARGIN)
  S.Commons.SetPoint(DebuffFrame, "TOPRIGHT", BuffFrame, "BOTTOMRIGHT", -MARGIN, -MARGIN)
end

table.insert(S.Modules, function()
  S.Commons.Hide(BuffFrame.CollapseAndExpandButton)
  ConfigurePosition()
end)
