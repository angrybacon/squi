---@type string, Squi
local _, S = ...

table.insert(S.Modules, function()
  S.Commons.Hide(BuffFrame.CollapseAndExpandButton)
end)
