---@type string, Squi
local _, S = ...

table.insert(S.Modules, function()
  SetCVar("Brightness", 48)
  SetCVar("Contrast", 55)
  SetCVar("Gamma", 1.0)
  SetCVar("useUiScale", "0")
end)
