---@type string, Squi
local _, S = ...

---@return table?
local function GetLayout()
  if InCombatLockdown()
    or not C_EditMode
    or not C_EditMode.GetLayouts
    or not C_EditMode.SaveLayouts then
    return nil
  end

  -- NOTE Never write while Edit Mode is open: it keeps its own copy of the
  --      layout for the session and overwrites this on its next save anyway
  local frame = EditModeManagerFrame
  if frame
    and (frame.editModeActive or (frame.IsShown and frame:IsShown())) then
    return nil
  end

  local ok, layout = pcall(C_EditMode.GetLayouts)
  if not ok
    or type(layout) ~= "table"
    or type(layout.layouts) ~= "table" then
    return nil
  end

  if not (EditModePresetLayoutManager and EditModePresetLayoutManager.GetCopyOfPresetLayouts) then
    return nil
  end
  local presets = EditModePresetLayoutManager:GetCopyOfPresetLayouts()
  if type(presets) ~= "table" or #presets == 0 then return nil end
  tAppendAll(presets, layout.layouts)
  layout.layouts = presets

  return layout
end

---@class Commons
local Commons = {
  ---@alias Anchor { anchor: string, anchored: string, on: string, x: number, y: number }
  ---@alias Options { anchor?: Anchor, settings?: table<number, number> }
  ---@param specifications table<number, Options | table<number, Options>>
  ConfigureLayout = function(specifications)
    local base = GetLayout()
    if not base then return end

    local layout = base.layouts[base.activeLayout]
    if not layout or type(layout.systems) ~= "table" then return end

    local changed = false
    for _, system in ipairs(layout.systems) do
      local bucket = specifications[system.system]
      -- NOTE Some systems such as action bars have multiple indexed instances,
      --      others are singletons with no `systemIndex` at all.
      local index = system.systemIndex
      local options = bucket and (index and bucket[index] or bucket)
      if options and options.anchor then
        local wanted = {
          offsetX = options.anchor.x,
          offsetY = options.anchor.y,
          point = options.anchor.anchored,
          relativePoint = options.anchor.anchor,
          relativeTo = options.anchor.on,
        }
        local current = system.anchorInfo
        local same = system.isInDefaultPosition == false
          and current
          and current.point == wanted.point
          and current.relativeTo == wanted.relativeTo
          and current.relativePoint == wanted.relativePoint
          and current.offsetX == wanted.offsetX
          and current.offsetY == wanted.offsetY
        if not same then
          system.anchorInfo = wanted
          system.isInDefaultPosition = false
          changed = true
        end
      end
      if options and options.settings and type(system.settings) == "table" then
        for _, setting in ipairs(system.settings) do
          local value = options.settings[setting.setting]
          if value and setting.value ~= value then
            setting.value = value
            changed = true
          end
        end
      end
    end

    if changed then
      C_EditMode.SaveLayouts(base)
      -- NOTE SaveLayouts only persists the change but not change live UI
      print("Squi layout updated, /reload again to see it")
    end
  end,

  -- NOTE Presets are read-only so we get-or-create a profile "Squi"
  EnsureLayout = function()
    local layout = GetLayout()
    if not layout then return end
    local name = "Squi"
    local target
    for index, candidate in ipairs(layout.layouts) do
      if candidate.layoutName == name then
        target = index
        break
      end
    end
    if not target then
      table.insert(layout.layouts, {
        layoutName = name,
        layoutType = Enum.EditModeLayoutType.Account,
        systems = CopyTable(layout.layouts[1].systems),
      })
      target = #layout.layouts
      C_EditMode.SaveLayouts(layout)
    end
    if layout.activeLayout ~= target then
      C_EditMode.SetActiveLayout(target)
    end
  end,

  ---Hide the region, keeping it hidden even if something else tries to show
  ---it again later
  ---@param region table
  Hide = function(region)
    region:Hide()
    if region.HookScript then
      region:HookScript("OnShow", region.Hide)
    end
  end,

  ---Draw a solid outline inward, overlaid on top of the region's own edges
  ---@param region table
  ---@param thickness "thick" | "thin"
  ---@param color colorRGBA
  ---@return table edges
  Outline = function(region, thickness, color)
    local function CreateEdge()
      local texture = region:CreateTexture(nil, "OVERLAY")
      texture:SetColorTexture(color:GetRGBA())
      return texture
    end
    local size = thickness == "thick" and 4 or 2
    local bottom = CreateEdge()
    bottom:SetPoint("BOTTOMLEFT", region, "BOTTOMLEFT", 0, 0)
    bottom:SetPoint("BOTTOMRIGHT", region, "BOTTOMRIGHT", 0, 0)
    bottom:SetHeight(size)
    local left = CreateEdge()
    left:SetPoint("TOPLEFT", region, "TOPLEFT", 0, 0)
    left:SetPoint("BOTTOMLEFT", region, "BOTTOMLEFT", 0, 0)
    left:SetWidth(size)
    local right = CreateEdge()
    right:SetPoint("TOPRIGHT", region, "TOPRIGHT", 0, 0)
    right:SetPoint("BOTTOMRIGHT", region, "BOTTOMRIGHT", 0, 0)
    right:SetWidth(size)
    local top = CreateEdge()
    top:SetPoint("TOPLEFT", region, "TOPLEFT", 0, 0)
    top:SetPoint("TOPRIGHT", region, "TOPRIGHT", 0, 0)
    top:SetHeight(size)
    return { top, right, bottom, left }
  end,
}

S.Commons = Commons
