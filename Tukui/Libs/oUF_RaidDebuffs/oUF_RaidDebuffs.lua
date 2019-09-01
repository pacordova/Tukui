local T, C, L = select(2, ...):unpack()

local _, ns = ...
local oUF = ns.oUF or oUF
local addon = {}
	
ns.oUF_RaidDebuffs = addon
oUF_RaidDebuffs = ns.oUF_RaidDebuffs

if not _G.oUF_RaidDebuffs then
	_G.oUF_RaidDebuffs = addon
end

local debuff_data = {}
	
addon.DebuffData = debuff_data
addon.ShowDispellableDebuff = true
addon.FilterDispellableDebuff = true
addon.MatchBySpellName = false
addon.priority = 10

local function add(spell, priority, stackThreshold)
	if addon.MatchBySpellName and type(spell) == 'number' then
		spell = GetSpellInfo(spell)
	end
	
	if(spell) then
		debuff_data[spell] = {
			priority = (addon.priority + priority),
			stackThreshold = (stackThreshold or 0),
		}
	end
end

function addon:RegisterDebuffs(t)
	for spell, value in pairs(t) do
		if type(t[spell]) == 'boolean' then
			local oldValue = t[spell]
			t[spell] = {
				['enable'] = oldValue,
				['priority'] = 0,
				['stackThreshold'] = 0
			}
		else
			if t[spell].enable then
				add(spell, t[spell].priority, t[spell].stackThreshold)
			end
		end
	end
end

function addon:ResetDebuffData()
	wipe(debuff_data)
end

local DispellColor = {
	['Magic']	= {.2, .6, 1},
	['Curse']	= {.6, 0, 1},
	['Disease']	= {.6, .4, 0},
	['Poison']	= {0, .6, 0},
	['none'] = {1, 0, 0},
}

local DispellPriority = {
	['Magic']	= 4,
	['Curse']	= 3,
	['Disease']	= 2,
	['Poison']	= 1,
}

local DispellFilter
do
	local dispellClasses = {
		['PRIEST'] = {
			['Magic'] = true,
			['Disease'] = true,
		},
		['SHAMAN'] = {
			['Curse'] = true,
		},
		['PALADIN'] = {
			['Poison'] = true,
			['Magic'] = false,
			['Disease'] = true,
		},
		['DRUID'] = {
			['Curse'] = true,
			['Poison'] = true,
		},
		['MAGE'] = {
			['Curse'] = true,
		},
	}
	
	DispellFilter = dispellClasses[select(2, UnitClass('player'))] or {}
end

local function OnUpdate(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed

	if (self.elapsed >= 0.1) then
		local timeLeft = self.endTime - GetTime()
	
		if (timeLeft > 0) then
			local text = T.FormatTime(timeLeft)
			self.time:SetText(text)
		else
			self:SetScript('OnUpdate', nil)
			self.time:Hide()
		end
	
		self.elapsed = 0
	end
end

local function UpdateDebuff(self, name, icon, count, debuffType, duration, endTime, spellId, stackThreshold)
	local f = self.RaidDebuffs

	if name and (count >= stackThreshold) then
		f.icon:SetTexture(icon)
		f.icon:Show()
		f.duration = duration
		
		if f.count then
			if count and (count > 1) then
				f.count:SetText(count)
				f.count:Show()
			else
				f.count:SetText("")
				f.count:Hide()
			end
		end
		
		if f.time then
			if duration and (duration > 0) then
				f.endTime = endTime
				f.nextUpdate = 0
				f:SetScript('OnUpdate', OnUpdate)
				f.time:Show()
			else
				f:SetScript('OnUpdate', nil)
				f.time:Hide()
			end
		end
		
		if f.cd then
			if duration and (duration > 0) then
				f.cd:SetCooldown(endTime - duration, duration)
				f.cd:Show()
			else
				f.cd:Hide()
			end
		end
		
		local c = DispellColor[debuffType] or DispellColor.none
		f:SetBorderColor(c[1], c[2], c[3])
		
		f:Show()
	else
		f:Hide()
	end
end

local function Update(self, event, unit)
	if unit ~= self.unit then return end
	local _name, _icon, _count, _dtype, _duration, _endTime, _spellId
	local _priority, priority = 0, 0
	local _stackThreshold = 0
	
	--store if the unit its charmed, mind controlled units (Imperial Vizier Zor'lok: Convert)
	local isCharmed = UnitIsCharmed(unit)		
	
	--store if we cand attack that unit, if its so the unit its hostile (Amber-Shaper Un'sok: Reshape Life)
	local canAttack = UnitCanAttack("player", unit)
	
	for i = 1, 40 do
		local name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff = UnitAura(unit, i, 'HARMFUL')
		
		if (not name) then break end

		--we coudln't dispell if the unit its charmed, or its not friendly
		if addon.ShowDispellableDebuff and (self.RaidDebuffs.showDispellableDebuff ~= false) and debuffType and (not isCharmed) and (not canAttack) then
			if addon.FilterDispellableDebuff then						
				DispellPriority[debuffType] = (DispellPriority[debuffType] or 0) + addon.priority --Make Dispell buffs on top of Boss Debuffs
				priority = DispellFilter[debuffType] and DispellPriority[debuffType] or 0
				if priority == 0 then
					debuffType = nil
				end
			else
				priority = DispellPriority[debuffType] or 0
			end			

			if priority > _priority then
				_priority, _name, _icon, _count, _dtype, _duration, _endTime, _spellId = priority, name, icon, count, debuffType, duration, expirationTime, spellId
			end
		end

		local debuff
		
		if self.RaidDebuffs.onlyMatchSpellID then
			debuff = debuff_data[spellId]
		else
			if debuff_data[spellId] then
				debuff = debuff_data[spellId]
			else
				debuff = debuff_data[name]
			end
		end

		priority = debuff and debuff.priority
		
		if priority and (priority > _priority) then
			_priority, _name, _icon, _count, _dtype, _duration, _endTime, _spellId = priority, name, icon, count, debuffType, duration, expirationTime, spellId
		end
	end

	if self.RaidDebuffs.forceShow then
		_spellId = 6788
		_name, _, _icon = GetSpellInfo(_spellId)
		_count, _dtype, _duration, _endTime, _stackThreshold = 5, 'Magic', 0, 60, 0
	end

	if _name then
		_stackThreshold = debuff_data[addon.MatchBySpellName and _name or _spellId] and debuff_data[addon.MatchBySpellName and _name or _spellId].stackThreshold or _stackThreshold
	end

	UpdateDebuff(self, _name, _icon, _count, _dtype, _duration, _endTime, _spellId, _stackThreshold)
end

local function Enable(self)
	if self.RaidDebuffs then
		self:RegisterEvent('UNIT_AURA', Update)
			
		return true
	end
end

local function Disable(self)
	if self.RaidDebuffs then
		self:UnregisterEvent('UNIT_AURA', Update)
			
		self.RaidDebuffs:Hide()
	end
end

oUF:AddElement('RaidDebuffs', Update, Enable, Disable)
