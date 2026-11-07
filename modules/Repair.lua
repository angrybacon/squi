---@type string, Squi
local _, S = ...

local MARGIN = 4

local function ConfigureDurability()
  S.Commons.ConfigureLayout({
    [Enum.EditModeSystem.DurabilityFrame] = {
      anchor = {
        anchor = "BOTTOMRIGHT",
        anchored = "BOTTOMRIGHT",
        on = "UIParent",
        x = -MARGIN,
        y = MARGIN,
      },
    },
  })
end

local function ConfigureRepair()
  local watcher = CreateFrame("Frame")
  watcher:RegisterEvent("MERCHANT_SHOW")
  watcher:SetScript("OnEvent", function()
    local cost, should = GetRepairAllCost()
    -- NOTE Personal funds only, the guild bank is never touched
    if should and cost > 0 and cost <= GetMoney() then
      RepairAllItems()
    end
  end)
end

table.insert(S.Modules, function()
  ConfigureDurability()
  ConfigureRepair()
end)
