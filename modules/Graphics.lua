---@type string, Squi
local _, S = ...

table.insert(S.Modules, function()
  SetCVar("Brightness", 45)
  SetCVar("Contrast", 60)
  SetCVar("Gamma", 1.0)
  SetCVar("useUiScale", "0")
end)
