---@type string, Squi
local _, S = ...

local function ConfigureNames()
  hooksecurefunc(NamePlateUnitFrameMixin, "ApplyFrameOptions", function(self)
    if self._SquiHooked then return end
    -- NOTE Mark the frame as having been Squi'd because the hooks are chained
    --      and not self-replacing; and `ApplyFrameOptions` runs _many_ times.
    self._SquiHooked = true

    self:HookScript("OnShow", function()
      -- NOTE Leave hostile nameplates untouched
      if not (self.unit and UnitIsFriend("player", self.unit)) then
        return
      end

      -- NOTE Blizzard's own code re-parents this frame back onto the nameplate
      --      when the unit re-enters view, silently undoing a one-time detach.
      --      Stop Blizzard's own code from updating this frame further and
      --      remove it from the parent chain entirely. We can't `:Hide()` it
      --      because the frame is protected.
      self:UnregisterAllEvents()
      if CompactUnitFrame_UnregisterEvents then
        CompactUnitFrame_UnregisterEvents(self)
      end
      self:ClearAllPoints()
      self:SetParent(nil)

      -- NOTE We parent our replacement text to the root frame that remains
      --      after the above detach.
      local base = self.namePlateFrame
      if not base._SquiName then
        base._SquiName = base:CreateFontString(nil, "OVERLAY")
        base._SquiName:SetPoint("CENTER", base, "CENTER", 0, 0)
      end
      S.Fonts.Set(base._SquiName, {
        font = S.Fonts.HandwritingRegular,
        size = 16,
        outline = true,
      })

      -- NOTE The original `self.name` text still reflects the original CVars
      --      even though it's detached and hidden, and is empty for
      --      non-interactive NPCs. We reuse that instead of guessing at an "is
      --      interactive" check that doesn't exist anyway. Defer the read since
      --      reading it immediately here raced Blizzard's own text population.
      --      By the time the deferred function below runs, the same frame could
      --      already be reused for something else, and `self.unit` would then
      --      point at the wrong unit.
      local unit = self.unit
      C_Timer.After(0, function()
        -- NOTE The `self.name` is Blizzard's original, now hidden, FontString.
        --      Its text is empty if our CVars decided this unit shouldn't show
        --      a name at all: a non-interactive NPC.
        local name = self.name:GetText()
        if not name or name == "" then
          -- NOTE No name for this unit means we should clear our text too
          --      otherwise a previous unit's name would linger.
          base._SquiName:SetText("")
        elseif UnitIsPlayer(unit) then
          local _, class = UnitClass(unit)
          base._SquiName:SetTextColor(C_ClassColor.GetClassColor(class):GetRGB())
          base._SquiName:SetText(name)
        else
          base._SquiName:SetTextColor(GOLD_FONT_COLOR:GetRGB())
          base._SquiName:SetText(name)
        end
      end)
    end)
  end)
end

table.insert(S.Modules, function()
  ConfigureNames()
  SetCVar("nameplateSize", Enum.NamePlateSize.Small)

  -- NOTE Customize friendly plates
  SetCVar("UnitNameFriendlyPlayerName", "1")
  SetCVar("UnitNameFriendlySpecialNPCName", "1")
  SetCVar("UnitNameInteractiveNPC", "1")
  SetCVar("UnitNameNPC", "0")
  SetCVar("UnitNameOwn", "0")

  -- NOTE Customize the plates with a bar that we do want to see.
  --      We also need to enable those that are handled in `ConfigureNames`
  --      because without an actual plate, the units get a low-level name that
  --      is not exposed to the Lua bindings.
  SetCVar("nameplateShowAll", "1")
  SetCVar("nameplateShowEnemies", "1")
  SetCVar("nameplateShowFriendlyNpcs", "1")
  SetCVar("nameplateShowFriendlyPlayers", "1")
end)
