---@class Squi
---@field Colors Colors
---@field Commons Commons
---@field Debug Debug
---@field Enchanting Enchanting
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
  S.Commons.EnsureLayout()
  for _, module in ipairs(S.Modules) do
    module()
  end
  local elapsed = debugprofilestop() - start
  local errors = S.Debug.Count()
  local suffix = errors > 0 and (", %d errors"):format(errors) or ""
  print(("(%s) Loaded in %.0f ms%s"):format(NAME, elapsed, suffix))
end)
