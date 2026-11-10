---@type string, Squi
local _, S = ...

-- NOTE Blizzard uses this value between stacked bags
local GAP = 16
local MARGIN = 24

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

local function ConfigurePosition()
  S.Commons.ConfigureLayout({
    [Enum.EditModeSystem.Bags] = {
      anchor = {
        anchor = "BOTTOMRIGHT",
        anchored = "TOPRIGHT",
        on = "ContainerFrameCombinedBags",
        x = 0,
        y = -GAP,
      },
    },
  })
  -- NOTE Blizzard anchors the first bag to the corner of the screen every time
  --      it lays the bags out, so we move it after each of those.
  hooksecurefunc("UpdateContainerFrameAnchors", function()
    ContainerFrameCombinedBags:ClearAllPoints()
    ContainerFrameCombinedBags:SetPoint(
      "BOTTOMRIGHT",
      MinimapCluster.MinimapContainer,
      "TOPRIGHT",
      -MARGIN,
      0
    )
  end)
  -- NOTE Blizzard stacks every other bag in a new column next to the combined
  --      bags, put the reagent bag right above them instead.
  hooksecurefunc("UpdateContainerFrameAnchors", function()
    for _, frame in ipairs(ContainerFrameSettingsManager:GetBagsShown()) do
      if
        not frame:IsCombinedBagContainer()
        and ContainerFrame_IsReagentBag(frame:GetBagID())
      then
        frame:ClearAllPoints()
        frame:SetPoint(
          "BOTTOMRIGHT",
          ContainerFrameCombinedBags,
          "TOPRIGHT",
          0,
          GAP
        )
      end
    end
  end)
end

local function ConfigureSort()
  EventRegistry:RegisterCallback("ContainerFrame.OpenAllBags", function()
    C_Container.SortBags()
  end, S)
end

local function ConfigureVisibility()
  -- NOTE The bar hangs below the bags, so it only shows along with them
  local function Update()
    BagsBar:SetShown(ContainerFrameCombinedBags:IsShown())
  end
  ContainerFrameCombinedBags:HookScript("OnShow", Update)
  ContainerFrameCombinedBags:HookScript("OnHide", Update)
  BagsBar:HookScript("OnShow", Update)
  Update()
end

table.insert(S.Modules, function()
  SetCVar("combinedBags", "1")
  S.Commons.Peek(BagsBar)
  ConfigureBank()
  ConfigureJunk()
  ConfigurePosition()
  ConfigureSort()
  ConfigureVisibility()
end)
