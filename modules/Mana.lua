---@type string, Squi
local _, S = ...

---Duration of the five-second rule swing ring
local DURATION = 5
---Ring diameter of the five-second rule
local SIZE = 64

---Fill a ring after each mana cast, full means the regeneration is back
local function ConfigureRule()
  local Start = S.Commons.Ring(SIZE)

  ---Whether a spell costs mana, nil when the data is secret
  ---@param spellID number
  ---@return boolean?
  local function SpendsMana(spellID)
    local costs = C_Spell.GetSpellPowerCost(spellID)
    if costs == nil then
      return false
    end
    if not canaccessvalue(costs) then
      return nil
    end
    for _, cost in ipairs(costs) do
      if not (canaccessvalue(cost.type) and canaccessvalue(cost.cost)) then
        return nil
      end
      if cost.type == Enum.PowerType.Mana and cost.cost > 0 then
        return true
      end
    end
    return false
  end

  local watcher = CreateFrame("Frame")
  watcher:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
  watcher:SetScript("OnEvent", function(_, _, _, _, id)
    -- NOTE Restart unless the spell is known to be free. We assume secret data
    --      is not free.
    if not canaccessvalue(id) or SpendsMana(id) ~= false then
      Start(DURATION)
    end
  end)
end

table.insert(S.Modules, function()
  ConfigureRule()
end)
