local _, ns = ...
local oUF = ns.oUF

local VISIBLE = 1
local HIDDEN = 0

local LCD = LibStub('LibClassicDurations', true)
local infinity = math.huge
local format = format
local floor = floor
local UnitIsUnit = UnitIsUnit
local UnitAura = UnitAura
local tinsert = tinsert

local DAY, HOUR, MINUTE = 86400, 3600, 60
local function FormatTime(s)
	if s == infinity then return end

	if s < MINUTE then
		return format("%.1fs", s)
	elseif s < HOUR then
		return format("%dm %ds", s/60%60, s%60)
	elseif s < DAY then
		return format("%dh %dm", s/(60*60), s/60%60)
	else
		return format("%dd %dh", s/DAY, (s / HOUR) - (floor(s/DAY) * 24))
	end
end

local function onEnter(self)
	if(not self:IsVisible()) then return end

	GameTooltip:SetOwner(self, self.tooltipAnchor)
	GameTooltip:SetUnitAura(self.unit, self.index, self.filter)
end

local function onLeave()
	GameTooltip:Hide()
end

local function onUpdate(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed >= 0.01 then
		local timeNow = GetTime()

		self:SetValue((self.expiration - timeNow) / self.duration)
		self.timeText:SetText(FormatTime(self.expiration - timeNow))

		if self.sparkEnabled then
			self.spark:Show()
		end

		self.elapsed = 0
	end
end

local function createAuraBar(element, index)
	local statusBar = CreateFrame('StatusBar', element:GetDebugName() .. 'StatusBar' .. index, element)
	statusBar:SetStatusBarTexture(element.auraBarTexture)
	statusBar:SetMinMaxValues(0, 1)
	statusBar.tooltipAnchor = element.tooltipAnchor
	statusBar:SetScript('OnEnter', onEnter)
	statusBar:SetScript('OnLeave', onLeave)
	statusBar:EnableMouse(false)

	local spark = statusBar:CreateTexture(nil, "OVERLAY", nil);
	spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
	spark:SetWidth(12)
	spark:SetBlendMode("ADD")
	spark:SetPoint('CENTER', statusBar:GetStatusBarTexture(), 'RIGHT')

	local icon = statusBar:CreateTexture(nil, 'ARTWORK')
	icon:SetPoint('RIGHT', statusBar, 'LEFT', -(element.gap or 2), 0)
	icon:SetSize(element.height, element.height)
	icon:SetTexCoord(0.1,0.9,0.1,0.9)

	local nameText = statusBar:CreateFontString(nil, 'OVERLAY', element.spellNameObject)
	nameText:SetPoint('LEFT', statusBar, 'LEFT', 2, 0)

	local countText = statusBar:CreateFontString(nil, 'OVERLAY', element.spellNameObject)
	countText:SetPoint('LEFT', nameText, 'RIGHT', 2, 0)

	local timeText = statusBar:CreateFontString(nil, 'OVERLAY', element.spellTimeObject)
	timeText:SetPoint('RIGHT', statusBar, 'RIGHT', -2, 0)

	statusBar.icon = icon
	statusBar.countText = countText
	statusBar.nameText = nameText
	statusBar.timeText = timeText
	statusBar.spark = spark

	if(element.PostCreateBar) then element:PostCreateBar(statusBar) end

	return statusBar
end

local function customFilter(element, unit, button, name)
	if((element.onlyShowPlayer and button.isPlayer and not button.isDebuff) or (not element.onlyShowPlayer and name)) then
		return true
	end
end

local function updateBar(element, unit, index, offset, filter, isDebuff, visible)
	local name, texture, count, debuffType, duration, expiration, caster, isStealable,
		nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll,
		timeMod, effect1, effect2, effect3 = UnitAura(unit, index, filter)

	if(name) then
		local position = visible + offset + 1
		local statusBar = element[position]
		if(not statusBar) then
			statusBar = (element.CreateBar or createAuraBar) (element, position)
			tinsert(element, statusBar)
			element.createdBars = element.createdBars + 1
		end

		statusBar.unit = unit
		statusBar.index = index
		statusBar.caster = caster
		statusBar.filter = filter
		statusBar.isDebuff = isDebuff
		statusBar.isPlayer = caster == 'player'

		if LCD and spellID and not UnitIsUnit('player', unit) then
			local durationNew, expirationTimeNew = LCD:GetAuraDurationByUnit(unit, spellID, caster, name)
			if durationNew and durationNew > 0 then
				duration, expiration = durationNew, expirationTimeNew
			end
		end

		local show = (element.CustomFilter or customFilter) (element, unit, statusBar, name, texture,
			count, debuffType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID,
			canApply, isBossDebuff, casterIsPlayer, nameplateShowAll, timeMod, effect1, effect2, effect3)

		if(show) then
			statusBar.icon:SetTexture(texture)
			statusBar.countText:SetText(count > 1 and count)
			statusBar.nameText:SetText(name)
			statusBar.spark:Hide()

			statusBar.duration = duration
			statusBar.expiration = expiration
			statusBar.sparkEnabled = element.sparkEnabled
			statusBar.spellID = spellID
			statusBar.spell = name
			statusBar.noTime = (duration == 0 and expiration == 0)

			local r, g, b = .2, .6, 1
			if element.buffColor then r, g, b = unpack(element.buffColor) end
			if filter == 'HARMFUL' then
				if not debuffType or debuffType == '' then debuffType = 'none' end
				r, g, b = DebuffTypeColor[debuffType].r, DebuffTypeColor[debuffType].g, DebuffTypeColor[debuffType].b
			end

			statusBar:SetStatusBarColor(r, g, b)
			statusBar:SetSize(element.width, element.height)
			statusBar.icon:SetSize(element.height, element.height)
			statusBar:SetID(index)
			statusBar:Show()

			if statusBar.noTime then
				statusBar:SetScript('OnUpdate', nil)
				statusBar:SetMinMaxValues(0, 1)
				statusBar:SetValue(1)
				statusBar.countText:SetText("")
				statusBar.timeText:SetText("")
				statusBar.spark:Hide()
			else
				statusBar:SetScript('OnUpdate', onUpdate)
			end

			if(element.PostUpdateBar) then
				element:PostUpdateBar(unit, statusBar, index, position, duration, expiration, debuffType, isStealable)
			end

			return VISIBLE
		else
			return HIDDEN
		end
	end
end

local function SetPosition(element, from, to)
	local height = (element.height + element.spacing) or 1
	local anchor = element.initialAnchor
	local growth = element.growth == 'DOWN' and -1 or 1

	for i = from, to do
		local button = element[i]
		if(not button) then break end

		button:ClearAllPoints()
		button:SetPoint(anchor, element, anchor, (height + element.gap), (i > 1 and ((i - 1) * (height + growth)) or 0))
	end
end

local function filterBars(element, unit, filter, limit, isDebuff, offset, dontHide)
	if(not offset) then offset = 0 end
	local index = 1
	local visible = 0
	local hidden = 0
	while(visible < limit) do
		local result = updateBar(element, unit, index, offset, filter, isDebuff, visible)
		if(not result) then
			break
		elseif(result == VISIBLE) then
			visible = visible + 1
		elseif(result == HIDDEN) then
			hidden = hidden + 1
		end

		index = index + 1
	end

	if(not dontHide) then
		for i = visible + offset + 1, #element do
			element[i]:Hide()
		end
	end

	return visible, hidden
end

local function UpdateAuras(self, event, unit)
    if(self.unit ~= unit) then return end

    local element = self.AuraBars
    if(element) then
        if(element.PreUpdate) then element:PreUpdate(unit) end

        local numBuffs = element.numBuffs or 32
        local numDebuffs = element.numDebuffs or 16
        local max = element.numTotal or numBuffs + numDebuffs

        local visibleBuffs = filterBars(element, unit, 'HELPFUL', min(numBuffs, max), nil, 0, true)

        local visibleDebuffs = filterBars(element, unit, 'HARMFUL', min(numDebuffs, max - visibleBuffs), true, visibleBuffs)
        element.visibleDebuffs = visibleDebuffs

        element.visibleBuffs = visibleBuffs
        element.visibleAuras = element.visibleBuffs + element.visibleDebuffs

        local fromRange, toRange

        if(element.PreSetPosition) then
            fromRange, toRange = element:PreSetPosition(max)
        end

        if(fromRange or element.createdBars > element.anchoredBars) then
            (element.SetPosition or SetPosition) (element, fromRange or element.anchoredBars + 1, toRange or element.createdBars)
            element.anchoredBars = element.createdBars
        end

        if(element.PostUpdate) then element:PostUpdate(unit) end
    end
end

local function Update(self, event, unit)
	if(self.unit ~= unit) then return end

	UpdateAuras(self, event, unit)

	-- Assume no event means someone wants to re-anchor things. This is usually
	-- done by UpdateAllElements and :ForceUpdate.
	if(event == 'ForceUpdate' or not event) then
		local element = self.AuraBars
		if(element) then
			(element.SetPosition or SetPosition) (element, 1, element.createdBars)
		end
	end
end

local function ForceUpdate(element)
	return Update(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
	local element = self.AuraBars

	if(element) then
		self:RegisterEvent('UNIT_AURA', UpdateAuras)
		self:RegisterEvent('PLAYER_TOTEM_UPDATE', UpdateAuras, true)

		element.__owner = self
		element.ForceUpdate = ForceUpdate

		element.createdBars = element.createdBars or 0
		element.auraBarTexture = element.auraBarTexture or [[Interface\TargetingFrame\UI-StatusBar]]
		element.anchoredBars = 0
		element.width = element.width or 240
		element.height = element.height or 12
		element.spellTimeObject = element.spellTimeObject or 'NumberFontNormal'
		element.spellNameObject = element.spellTimeObject or 'NumberFontNormal'
		element.sparkEnabled = element.sparkEnabled or true
		element.spacing = element.spacing or 2
		element.initialAnchor = element.initialAnchor or 'BOTTOMLEFT'
		element.growth = element.growth or 'UP'
		element.gap = element.gap or 2
		element.maxBars = element.maxBars or 32

		-- Avoid parenting GameTooltip to frames with anchoring restrictions,
		-- otherwise it'll inherit said restrictions which will cause issues
		-- with its further positioning, clamping, etc

		if(not pcall(self.GetCenter, self)) then
			element.tooltipAnchor = 'ANCHOR_CURSOR'
		else
			element.tooltipAnchor = element.tooltipAnchor or 'ANCHOR_BOTTOMRIGHT'
		end

		element:Show()

		return true
	end
end

local function Disable(self)
	local element = self.AuraBars

	if(element) then
		self:UnregisterEvent('UNIT_AURA', UpdateAuras)
		element:Hide()
	end
end

oUF:AddElement('AuraBars', Update, Enable, Disable)
