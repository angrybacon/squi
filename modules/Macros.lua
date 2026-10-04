---@type string, Squi
local _, S = ...

local function ConfigureTextarea()
  S.Fonts.Set(MacroFrameText:GetFontObject(), {
    font = S.Fonts.Monospace,
    size = 10,
  })
end

table.insert(S.Modules, function()
  if C_AddOns.IsAddOnLoaded("Blizzard_MacroUI") then
    ConfigureTextarea()
    return
  end

  local watcher = CreateFrame("Frame")
  watcher:RegisterEvent("ADDON_LOADED")
  watcher:SetScript("OnEvent", function(_, _, name)
    if name ~= "Blizzard_MacroUI" then return end
    ConfigureTextarea()
    watcher:UnregisterEvent("ADDON_LOADED")
  end)
end)
