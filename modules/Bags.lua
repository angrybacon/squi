---@type string, Squi
local _, S = ...

local function ConfigureJunk()
  local watcher = CreateFrame("Frame")
  watcher:RegisterEvent("MERCHANT_SHOW")
  watcher:SetScript("OnEvent", function()
    if
      C_MerchantFrame.IsSellAllJunkEnabled()
      and C_MerchantFrame.GetNumJunkItems() > 0
    then
      C_MerchantFrame.SellAllJunkItems()
    end
  end)
end

local function ConfigureSort()
  EventRegistry:RegisterCallback("ContainerFrame.OpenAllBags", function()
    C_Container.SortBags()
  end, S)
end

table.insert(S.Modules, function()
  SetCVar("combinedBags", "0")
  ConfigureJunk()
  ConfigureSort()
end)
