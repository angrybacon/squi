---@type string, Squi
local _, S = ...

-- NOTE Blizzard uses this value between stacked bags
local GAP = 16
local MARGIN = 24
local TINT_OPACITY = 0.5
local TINT_ASSIGNED = { 0.0, 0.0, 1.0 }
local TINT_QUEST = { 0.0, 1.0, 0.0 }
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

  -- NOTE Hooking methods of Blizzard's frames taints the game code that calls
  --      them, which breaks panels in combat. We draw our own overlay on the
  --      buttons, Blizzard never resets it, and we only refresh on events.
  ---@type table<Frame, Texture>
  local overlays = setmetatable({}, { __mode = "k" })

  ---Tint a button, or clear it when there is no color
  ---@param button Frame
  ---@param tint number[]?
  local function Paint(button, tint)
    local overlay = overlays[button]
    if not tint then
      if overlay then
        overlay:Hide()
      end
      return
    end
    if not overlay then
      -- NOTE Blizzard draws the icon in BORDER, the quality border in OVERLAY
      overlay = button:CreateTexture(nil, "ARTWORK")
      overlay:SetAllPoints(button.icon)
      if button.Mask then
        overlay:AddMaskTexture(button.Mask)
      end
      overlays[button] = overlay
    end
    overlay:SetColorTexture(tint[1], tint[2], tint[3], TINT_OPACITY)
    overlay:Show()
  end

  ---Whether an item belongs to a quest, active or not
  local function IsQuestItem(bag, slot)
    local info = C_Container.GetContainerItemQuestInfo(bag, slot)
    return info ~= nil and canaccessvalue(info) and info.isQuestItem == true
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
        if IsQuestItem(bag, slot) then
          Paint(button, TINT_QUEST)
        elseif assigned[bag .. ":" .. slot] then
          Paint(button, TINT_ASSIGNED)
        elseif
          itemID
          and C_Item.IsEquippableItem(itemID)
          and HasRedLine(bag, slot)
        then
          Paint(button, TINT_UNUSABLE)
        else
          Paint(button)
        end
      end
    end
  end

  local pending = false
  EventRegistry:RegisterCallback(
    "ItemButton.UpdateItemContextMatching",
    function()
      if pending then
        return
      end
      pending = true
      C_Timer.After(0, function()
        pending = false
        Update()
      end)
    end,
    S
  )
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
