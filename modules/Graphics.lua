---@type string, Squi
local _, S = ...

local SCALE = .8

table.insert(S.Modules, function()
  SetCVar("Brightness", 48)
  SetCVar("Contrast", 60)
  SetCVar("Gamma", 1.0)
  SetCVar("RenderScale", 1.0)
  SetCVar("uiScale", SCALE)
  SetCVar("useUiScale", "1")
end)
