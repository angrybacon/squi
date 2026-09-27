---@class Squi
---@field Commons Commons
---@field Fonts Fonts
---@field Modules fun()[]

---@type string, Squi
local NAME, S = ...

-- NOTE Modules register their entry point here, they run in file order
S.Modules = {}

local events = CreateFrame("Frame")

events:RegisterEvent("PLAYER_LOGIN")

events:SetScript("OnEvent", function()
  local start = debugprofilestop()
  for _, module in ipairs(S.Modules) do module() end
  local elapsed = debugprofilestop() - start
  print(NAME .. format(" loaded in %.0f ms", elapsed))
end)
