---@type string, Squi
local _, S = ...

local function ConfigureBank()
  BankFrame:HookScript("OnShow", function(frame)
    -- NOTE Opening the bank also opens the bags, which are configured to also
    --      automatically sort. This locks items so we wait a bit.
    C_Timer.After(1, function()
      local bank = frame:IsShown() and frame:GetActiveBankType()
      -- NOTE Sorting a bank without a purchased tab does nothing
      if bank and C_Bank.FetchNumPurchasedBankTabs(bank) > 0 then
        C_Container.SortBank(bank)
      end
    end)
  end)
end

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
  SetCVar("combinedBags", "1")
  ConfigureBank()
  ConfigureJunk()
  ConfigureSort()
end)
