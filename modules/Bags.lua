---@type string, Squi
local _, S = ...

-- NOTE Blizzard uses this value between stacked bags
local GAP = 16
local MARGIN = 24
---Icon tint of items assigned to an equipment set
local TINT_ASSIGNED = { 0.0, 0.0, 1.0 }
---Icon tint of equipment the character can't equip
local TINT_UNUSABLE = { 1.0, 0.0, 0.0 }

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

local function ConfigureEquipment()
  ---Whether the tooltip of an item reports a red field.
  ---Surely there's a better way to detect unusable pieces of equipment.
  local function HasRedLine(bag, slot)
    local tooltip = C_TooltipInfo.GetBagItem(bag, slot)
    if not tooltip or not canaccessvalue(tooltip) then
      return false
    end
    local function IsRed(color)
      return color ~= nil and color.r > 0.9 and color.g < 0.3 and color.b < 0.3
    end
    for _, line in ipairs(tooltip.lines) do
      if IsRed(line.leftColor) or IsRed(line.rightColor) then
        return true
      end
    end
    return false
  end

  local function Update()
    -- NOTE Items are keyed by `bag:slot`, any set counts
    local assigned = {}
    for _, setID in ipairs(C_EquipmentSet.GetEquipmentSetIDs()) do
      local locations = C_EquipmentSet.GetItemLocations(setID)
      if locations and canaccessvalue(locations) then
        for _, location in pairs(locations) do
          local data = EquipmentManager_GetLocationData(location)
          if data.isBags and not data.isBank then
            assigned[data.bag .. ":" .. data.slot] = true
          end
        end
      end
    end
    for _, frame in ContainerFrameUtil_EnumerateContainerFrames() do
      for _, button in frame:EnumerateValidItems() do
        -- NOTE Buttons are created lazily, a frame can be sized before they are
        if not button then
          break
        end
        local bag, slot = button:GetBagID(), button:GetID()
        local itemID = C_Container.GetContainerItemID(bag, slot)
        if assigned[bag .. ":" .. slot] then
          button.icon:SetVertexColor(unpack(TINT_ASSIGNED))
        elseif
          itemID
          and C_Item.IsEquippableItem(itemID)
          and HasRedLine(bag, slot)
        then
          button.icon:SetVertexColor(unpack(TINT_UNUSABLE))
        else
          button.icon:SetVertexColor(1, 1, 1)
        end
      end
    end
  end

  for _, frame in ContainerFrameUtil_EnumerateContainerFrames() do
    hooksecurefunc(frame, "UpdateItems", Update)
    -- NOTE Blizzard resets the icon color along with the cooldown, which
    --      happens on its own on every cooldown event. If combat gets laggy
    --      with bags open, this is the place.
    hooksecurefunc(frame, "UpdateCooldowns", Update)
  end
  local watcher = CreateFrame("Frame")
  watcher:RegisterEvent("EQUIPMENT_SETS_CHANGED")
  watcher:SetScript("OnEvent", Update)
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
  ConfigureEquipment()
  ConfigureJunk()
  ConfigurePosition()
  ConfigureSort()
  ConfigureVisibility()
end)
