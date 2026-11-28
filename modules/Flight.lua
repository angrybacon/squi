---@type string, Squi
local _, S = ...

---Seconds between refreshes of the time left
local INTERVAL = 1
---Seconds to wait after regaining control before the flight counts as landed
local LAND_DELAY = 1
---Seconds between picking a destination and the flight starting
local PENDING_TIMEOUT = 5
local TEXT_UNKNOWN = "Unknown flight duration"

---Show the time left of the flight, learn the duration of each route
local function ConfigureTimer()
  ---@type { back: string, key: string, start: number, early: boolean? }?
  local flight
  ---@type { at: number, back: string, key: string }?
  local pending

  local frame = CreateFrame("Frame", nil, UIParent)
  frame:SetSize(1, 1)
  frame:SetPoint("CENTER")
  frame:Hide()

  local text = frame:CreateFontString(nil, "OVERLAY")
  text:SetFontObject(GameFontNormal)
  text:SetPoint("CENTER")
  S.Fonts.Set(text, { face = "Gothic", outline = true, scale = "Huge" })

  ---Name of the stop the flight master offers as current
  ---@return string?
  local function GetOrigin()
    for index = 1, NumTaxiNodes() do
      if TaxiNodeGetType(index) == "CURRENT" then
        return TaxiNodeName(index)
      end
    end
  end

  local function Update()
    -- NOTE The way back is close enough to count down from
    local known = SquiFlights[flight.key] or SquiFlights[flight.back]
    if not known then
      text:SetText(TEXT_UNKNOWN)
      return
    end
    local left = math.max(0, known - (GetTime() - flight.start))
    text:SetText(("%d:%02d"):format(left / 60, left % 60))
  end

  local function Land()
    -- NOTE Control can come back more than once before the timer fires
    if not flight then
      return
    end
    -- NOTE Landing early says nothing about the duration of the route
    if not flight.early then
      SquiFlights[flight.key] = math.floor(GetTime() - flight.start + 0.5)
    end
    flight = nil
    text:SetText("")
    frame:Hide()
  end

  hooksecurefunc("TakeTaxiNode", function(slot)
    local origin = GetOrigin()
    if origin then
      local destination = TaxiNodeName(slot)
      pending = {
        at = GetTime(),
        back = destination .. ">" .. origin,
        key = origin .. ">" .. destination,
      }
    end
  end)
  hooksecurefunc("TaxiRequestEarlyLanding", function()
    if flight then
      flight.early = true
    end
  end)

  local watcher = CreateFrame("Frame")
  watcher:RegisterEvent("PLAYER_CONTROL_GAINED")
  watcher:RegisterEvent("PLAYER_CONTROL_LOST")
  watcher:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_CONTROL_LOST" then
      if pending and GetTime() - pending.at < PENDING_TIMEOUT then
        flight = {
          back = pending.back,
          key = pending.key,
          start = GetTime(),
        }
        frame:Show()
        Update()
      end
      pending = nil
    elseif flight then
      -- NOTE The taxi state lags behind the event, wait for it to settle
      C_Timer.After(LAND_DELAY, Land)
    end
  end)

  -- NOTE The frame only runs while in flight, to refresh the text
  local elapsed = 0
  frame:SetScript("OnUpdate", function(_, delta)
    elapsed = elapsed + delta
    if elapsed >= INTERVAL then
      elapsed = 0
      if flight then
        Update()
      end
    end
  end)
end

table.insert(S.Modules, function()
  SquiFlights = SquiFlights or {}
  ConfigureTimer()
end)
