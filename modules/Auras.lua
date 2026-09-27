---@type string, Squi
local _, S = ...

local MARGIN = 10

table.insert(S.Modules, function()
  S.Commons.Hide(BuffFrame.CollapseAndExpandButton)
  local offset = BuffFrame.CollapseAndExpandButton:GetWidth()
  BuffFrame:ClearAllPoints()
  BuffFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", offset - MARGIN, -MARGIN)
  DebuffFrame:ClearAllPoints()
  DebuffFrame:SetPoint("TOPRIGHT", BuffFrame, "BOTTOMRIGHT", -MARGIN, -MARGIN)
end)
