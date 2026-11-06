---@type string, Squi
local _, S = ...

local GAP = 12
local ICON_SIZE = 40
---Horizontal distance kept between icons and either edge of the line
local INSET = 1
local THRESHOLD_HIGH = 60 * 5
local THRESHOLD_LOW = 2
---Remaining time that lands on the middle of the line
local THRESHOLD_SPLIT = 10

-- NOTE Offset that puts `THRESHOLD_SPLIT` at the middle of a log scale ending
--      at `THRESHOLD_HIGH`. Needs `THRESHOLD_HIGH > 2 * SPLIT_TIME`.
local LOG_OFFSET = THRESHOLD_SPLIT
  * THRESHOLD_SPLIT
  / (THRESHOLD_HIGH - 2 * THRESHOLD_SPLIT)

---@class CooldownEntry
---@field expires number
---@field icon table

---Cooldowns currently tracked, keyed by spell ID
---@type table<number, CooldownEntry>
local ENTRIES = {}

---The cooldown line frame
---@type table
local LINE

---Spells whose cooldown could not be read, to be retried once out of combat
---@type table<number, true>
local PENDING = {}

---Icons of expired cooldowns, ready to be reused
---@type table[]
local POOL = {}

---Number of icon frames created so far, used to give each a unique strate level
local CREATED = 0

---Create an outlined icon frame on the line
---@return table
local function CreateIcon()
  local icon = CreateFrame("Frame", nil, LINE)
  -- NOTE Each icon owns its outline, so a distinct level keeps the outline of
  --      one from drawing over the texture of another. We don't care which one
  --      wins and the level never changes, icons are reused from a pool.
  CREATED = CREATED + 1
  icon:SetFrameLevel(LINE:GetFrameLevel() + CREATED)
  icon:SetSize(ICON_SIZE, ICON_SIZE)
  icon.Texture = icon:CreateTexture(nil, "ARTWORK")
  icon.Texture:SetAllPoints()
  icon.Texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
  S.Commons.Outline(icon, "thin", S.Colors.Outline)
  return icon
end

---Stop tracking a spell and recycle its icon
---@param key number
local function Remove(key)
  -- TODO Flash the icon of a spell that just finished, e.g. zoom and fade
  local entry = ENTRIES[key]
  if entry then
    entry.icon:Hide()
    table.insert(POOL, entry.icon)
    ENTRIES[key] = nil
  end
end

---Round an offset to a whole physical pixel
---@param offset number
---@return number
local function Snap(offset)
  -- TODO The pixel size is the same for every icon, compute it once per frame
  -- NOTE The outline edges snap to the pixel grid but the icon does not, so
  --      they would step apart. Landing on whole pixels keeps them in sync.
  local pixel = S.Commons.PixelSize(1)
  return S.Commons.PixelSize(math.floor(offset / pixel + 0.5))
end

---Read the cooldown of a spell and track, update or drop its entry
---@param id number
local function Track(id)
  local info = C_Spell.GetSpellCooldown(id)
  -- NOTE Values are secret when restricted, keep what we already track
  if
    not info
    or not canaccessvalue(info.startTime)
    or not canaccessvalue(info.duration)
  then
    PENDING[id] = true
    return
  end
  if info.isActive and info.duration > THRESHOLD_LOW then
    local entry = ENTRIES[id]
    if not entry then
      entry = { icon = table.remove(POOL) or CreateIcon() }
      ENTRIES[id] = entry
    end
    entry.expires = info.startTime + info.duration
    entry.icon.Texture:SetTexture(C_Spell.GetSpellTexture(id))
  else
    Remove(id)
  end
end

---Move every tracked icon to the position matching its remaining time
local function Update()
  local now = GetTime()
  local travel = LINE:GetWidth() - ICON_SIZE - 2 * INSET
  -- TODO The log denominator is constant, compute it once outside the loop
  for key, entry in pairs(ENTRIES) do
    local remaining = entry.expires - now
    if remaining <= 0 then
      Remove(key)
    elseif remaining > THRESHOLD_HIGH then
      entry.icon:Hide()
    else
      -- TODO Skip re-anchoring when the snapped offset didn't change, it
      --      invalidates the layout of the icon and its five children.
      entry.icon:ClearAllPoints()
      local ratio = math.log(1 + remaining / LOG_OFFSET)
        / math.log(1 + THRESHOLD_HIGH / LOG_OFFSET)
      entry.icon:SetPoint(
        "CENTER",
        LINE,
        "LEFT",
        Snap(INSET + ICON_SIZE / 2 + travel * ratio),
        0
      )
      entry.icon:Show()
    end
  end
end

---Create the line and wire it to the cooldown and combat events
local function ConfigureLine()
  LINE = CreateFrame("Frame", nil, UIParent)
  LINE:SetHeight(ICON_SIZE)
  local anchor = "MultiBarBottomLeft"
  LINE:SetPoint("BOTTOMLEFT", _G[anchor], "TOPLEFT", 0, GAP)
  LINE:SetPoint("BOTTOMRIGHT", _G[anchor], "TOPRIGHT", 0, GAP)
  LINE:SetScript("OnUpdate", Update)
  LINE:SetShown(not InCombatLockdown())
  LINE:RegisterEvent("PLAYER_REGEN_DISABLED")
  LINE:RegisterEvent("PLAYER_REGEN_ENABLED")
  LINE:RegisterEvent("SPELL_UPDATE_COOLDOWN")
  LINE:SetScript("OnEvent", function(_, event, spell)
    if event == "PLAYER_REGEN_DISABLED" then
      LINE:Hide()
    elseif event == "PLAYER_REGEN_ENABLED" then
      LINE:Show()
      for id in pairs(PENDING) do
        Track(id)
      end
      table.wipe(PENDING)
    elseif spell then
      Track(spell)
    else
      -- NOTE No spell in payload means every cooldown changed, e.g. on login
      -- TODO Walking the whole spellbook is about 1000 API calls, cache the
      --      spell IDs on `SPELLS_CHANGED` instead.
      for lineIndex = 1, C_SpellBook.GetNumSpellBookSkillLines() do
        local skill = C_SpellBook.GetSpellBookSkillLineInfo(lineIndex)
        if skill and not skill.shouldHide then
          for slot = skill.itemIndexOffset + 1, skill.itemIndexOffset + skill.numSpellBookItems do
            local item = C_SpellBook.GetSpellBookItemInfo(
              slot,
              Enum.SpellBookSpellBank.Player
            )
            if
              item
              and item.itemType == Enum.SpellBookItemType.Spell
              and item.spellID
              and not item.isPassive
              and not item.isOffSpec
            then
              Track(item.spellID)
            end
          end
        end
      end
    end
  end)
end

table.insert(S.Modules, function()
  -- NOTE Cooldowns are secret in combat, so the line hides itself until it
  --      ends. Explore options that go around the restriction, e.g. a
  --      secret-safe line driven by status bars and curves, or estimating from
  --      remembered durations.
  ConfigureLine()
end)
