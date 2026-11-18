---@type string, Squi
local _, S = ...

---Ring diameter of the swing timer in screen pixels
local SIZE = 48

local function ConfigureSwing()
  local Start = S.Commons.Ring(SIZE)
  local watcher = CreateFrame("Frame")
  watcher:RegisterEvent("PLAYER_SWING")
  watcher:SetScript("OnEvent", function(_, _, duration, swingType)
    if
      swingType == Enum.PlayerSwingType.MainHand
      or swingType == Enum.PlayerSwingType.Ranged
    then
      Start(duration)
    end
  end)
end

table.insert(S.Modules, function()
  SetCVar("showSwingTimer", "0")
  ConfigureSwing()
end)
