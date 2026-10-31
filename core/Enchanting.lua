---@type string, Squi
local NAME, S = ...

local EPSILON = 0.001

-- NOTE Forever only, so original-era item levels. Data adapted from
--      DisenchantBuddy and cross-checked against Disenchantry. Both disagree on
--      a few rows (e.g. weapon dust at ilvl 51-60). We asumme the former is
--      more correct.

---@enum Materials
local Materials = {
  DreamDust = 11176,
  GreaterAstralEssence = 11082,
  GreaterEternalEssence = 16203,
  GreaterMagicEssence = 10939,
  GreaterMysticEssence = 11135,
  GreaterNetherEssence = 11175,
  IllusionDust = 16204,
  LargeBrilliantShard = 14344,
  LargeGlimmeringShard = 11084,
  LargeGlowingShard = 11139,
  LargeRadiantShard = 11178,
  LesserAstralEssence = 10998,
  LesserEternalEssence = 16202,
  LesserMagicEssence = 10938,
  LesserMysticEssence = 11134,
  LesserNetherEssence = 11174,
  NexusCrystal = 20725,
  SmallBrilliantShard = 14343,
  SmallGlimmeringShard = 10978,
  SmallGlowingShard = 11138,
  SmallRadiantShard = 11177,
  SoulDust = 11083,
  StrangeDust = 10940,
  VisionDust = 11137,
}

---@param material number
---@param chance? number
---@param minimum? number
---@param maximum? number
local function Drop(material, chance, minimum, maximum)
  return {
    chance = chance or 100,
    id = material,
    maximum = maximum or minimum or 1,
    minimum = minimum or 1,
  }
end

-- NOTE Every table is sorted by maximum item level
local TABLES = {
  EPIC = {
    { 45, Drop(Materials.SmallRadiantShard, 100, 2, 4) },
    { 50, Drop(Materials.LargeRadiantShard, 100, 2, 4) },
    { 55, Drop(Materials.SmallBrilliantShard, 100, 2, 4) },
    { 60, Drop(Materials.NexusCrystal) },
    {
      92,
      Drop(Materials.NexusCrystal, 33, 1, 1),
      Drop(Materials.NexusCrystal, 67, 2, 2),
    },
  },

  RARE = {
    { 25, Drop(Materials.SmallGlimmeringShard) },
    { 30, Drop(Materials.LargeGlimmeringShard) },
    { 35, Drop(Materials.SmallGlowingShard) },
    { 40, Drop(Materials.LargeGlowingShard) },
    { 45, Drop(Materials.SmallRadiantShard) },
    { 50, Drop(Materials.LargeRadiantShard) },
    { 55, Drop(Materials.SmallBrilliantShard) },
    {
      86,
      Drop(Materials.LargeBrilliantShard, 99.5),
      Drop(Materials.NexusCrystal, 0.5),
    },
  },

  UNCOMMON_ARMOR = {
    {
      15,
      Drop(Materials.StrangeDust, 80, 1, 2),
      Drop(Materials.LesserMagicEssence, 20, 1, 2),
    },
    {
      20,
      Drop(Materials.StrangeDust, 75, 2, 3),
      Drop(Materials.GreaterMagicEssence, 20, 1, 2),
      Drop(Materials.SmallGlimmeringShard, 5, 1, 1),
    },
    {
      25,
      Drop(Materials.StrangeDust, 75, 4, 6),
      Drop(Materials.LesserAstralEssence, 15, 1, 2),
      Drop(Materials.SmallGlimmeringShard, 10, 1, 1),
    },
    {
      30,
      Drop(Materials.SoulDust, 75, 1, 2),
      Drop(Materials.GreaterAstralEssence, 20, 1, 2),
      Drop(Materials.LargeGlimmeringShard, 5, 1, 1),
    },
    {
      35,
      Drop(Materials.SoulDust, 75, 2, 5),
      Drop(Materials.LesserMysticEssence, 20, 1, 2),
      Drop(Materials.SmallGlowingShard, 5, 1, 1),
    },
    {
      40,
      Drop(Materials.VisionDust, 75, 1, 2),
      Drop(Materials.GreaterMysticEssence, 20, 1, 2),
      Drop(Materials.LargeGlowingShard, 5, 1, 1),
    },
    {
      45,
      Drop(Materials.VisionDust, 75, 2, 5),
      Drop(Materials.LesserNetherEssence, 20, 1, 2),
      Drop(Materials.SmallRadiantShard, 5, 1, 1),
    },
    {
      50,
      Drop(Materials.DreamDust, 75, 1, 2),
      Drop(Materials.GreaterNetherEssence, 20, 1, 2),
      Drop(Materials.LargeRadiantShard, 5, 1, 1),
    },
    {
      55,
      Drop(Materials.DreamDust, 75, 2, 6),
      Drop(Materials.LesserEternalEssence, 20, 1, 2),
      Drop(Materials.SmallBrilliantShard, 5, 1, 1),
    },
    {
      60,
      Drop(Materials.IllusionDust, 75, 1, 2),
      Drop(Materials.GreaterEternalEssence, 20, 1, 2),
      Drop(Materials.LargeBrilliantShard, 5, 1, 1),
    },
    {
      65,
      Drop(Materials.IllusionDust, 75, 2, 5),
      Drop(Materials.GreaterEternalEssence, 20, 2, 3),
      Drop(Materials.LargeBrilliantShard, 5, 1, 1),
    },
  },

  UNCOMMON_WEAPON = {
    {
      15,
      Drop(Materials.LesserMagicEssence, 80, 1, 2),
      Drop(Materials.StrangeDust, 20, 1, 2),
    },
    {
      20,
      Drop(Materials.GreaterMagicEssence, 75, 1, 2),
      Drop(Materials.StrangeDust, 20, 2, 3),
      Drop(Materials.SmallGlimmeringShard, 5, 1, 1),
    },
    {
      25,
      Drop(Materials.GreaterMagicEssence, 75, 1, 2),
      Drop(Materials.StrangeDust, 15, 4, 6),
      Drop(Materials.SmallGlimmeringShard, 10, 1, 1),
    },
    {
      30,
      Drop(Materials.GreaterMagicEssence, 75, 1, 2),
      Drop(Materials.SoulDust, 20, 1, 2),
      Drop(Materials.LargeGlimmeringShard, 5, 1, 1),
    },
    {
      35,
      Drop(Materials.LesserMysticEssence, 75, 1, 2),
      Drop(Materials.SoulDust, 20, 2, 5),
      Drop(Materials.SmallGlowingShard, 5, 1, 1),
    },
    {
      40,
      Drop(Materials.GreaterMysticEssence, 75, 1, 2),
      Drop(Materials.VisionDust, 20, 1, 2),
      Drop(Materials.LargeGlowingShard, 5, 1, 1),
    },
    {
      45,
      Drop(Materials.LesserNetherEssence, 75, 1, 2),
      Drop(Materials.VisionDust, 20, 2, 5),
      Drop(Materials.SmallRadiantShard, 5, 1, 1),
    },
    {
      50,
      Drop(Materials.GreaterNetherEssence, 75, 1, 2),
      Drop(Materials.DreamDust, 20, 1, 2),
      Drop(Materials.LargeRadiantShard, 5, 1, 1),
    },
    {
      55,
      Drop(Materials.LesserEternalEssence, 75, 1, 2),
      Drop(Materials.DreamDust, 20, 2, 5),
      Drop(Materials.SmallBrilliantShard, 5, 1, 1),
    },
    {
      60,
      Drop(Materials.GreaterEternalEssence, 75, 1, 2),
      Drop(Materials.IllusionDust, 20, 1, 2),
      Drop(Materials.LargeBrilliantShard, 5, 1, 1),
    },
    {
      65,
      Drop(Materials.GreaterEternalEssence, 75, 2, 3),
      Drop(Materials.IllusionDust, 20, 2, 5),
      Drop(Materials.LargeBrilliantShard, 5, 1, 1),
    },
  },
}

-- NOTE Quality, then class. Rare and epic both share rows between classes.
local DISENCHANT = {
  [Enum.ItemQuality.Uncommon] = {
    [Enum.ItemClass.Armor] = TABLES.UNCOMMON_ARMOR,
    [Enum.ItemClass.Weapon] = TABLES.UNCOMMON_WEAPON,
  },
  [Enum.ItemQuality.Rare] = {
    [Enum.ItemClass.Armor] = TABLES.RARE,
    [Enum.ItemClass.Weapon] = TABLES.RARE,
  },
  [Enum.ItemQuality.Epic] = {
    [Enum.ItemClass.Armor] = TABLES.EPIC,
    [Enum.ItemClass.Weapon] = TABLES.EPIC,
  },
}

---@param rows table[]
---@param level number
local function Find(rows, level)
  for _, row in ipairs(rows) do
    if level <= row[1] then
      return { unpack(row, 2) }
    end
  end
  return nil
end

---Warn about rows whose chances don't sum to 100%
local function Validate()
  for name, rows in pairs(TABLES) do
    for _, row in ipairs(rows) do
      local total = 0
      for index = 2, #row do
        total = total + row[index].chance
      end
      if math.abs(total - 100) > EPSILON then
        print(
          ("(%s) Disenchant results for %s (%d) sum to %s%%"):format(
            NAME,
            name,
            row[1],
            total
          )
        )
      end
    end
  end
end

Validate()

---@class Enchanting
local Enchanting = {
  ---Get what disenchanting an item may yield, or nil when it can't be known
  ---@param quality number
  ---@param class number
  ---@param level number
  ---@return { chance: number, id: number, maximum: number, minimum: number }[]?
  Drops = function(quality, class, level)
    local rows = DISENCHANT[quality] and DISENCHANT[quality][class]
    return rows and Find(rows, level)
  end,
}

S.Enchanting = Enchanting
