local T, C, L = select(2, ...):unpack()

local TukuiUnitFrames = T["UnitFrames"]
local Movers = T["Movers"]
local Class = select(2, UnitClass("player"))

function TukuiUnitFrames:Target()
	local HealthTexture = T.GetTexture(C["Textures"].UFHealthTexture)
	local PowerTexture = T.GetTexture(C["Textures"].UFPowerTexture)
	local CastTexture = T.GetTexture(C["Textures"].UFCastTexture)
	local Font = T.GetFont(C["UnitFrames"].Font)

	self:RegisterForClicks("AnyUp")
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)
	self:SetBackdrop(TukuiUnitFrames.Backdrop)
	self:SetBackdropColor(0, 0, 0)
	self:CreateShadow()

	local Panel = CreateFrame("Frame", nil, self)
	Panel:SetFrameStrata(self:GetFrameStrata())
	Panel:SetTemplate()
	Panel:Size(250, 21)
	Panel:Point("BOTTOM", self, "BOTTOM", 0, 0)
	Panel:SetFrameLevel(2)
	Panel:SetBorderColor(0, 0, 0, 0)

	local Health = CreateFrame("StatusBar", nil, self)
	Health:SetFrameStrata(self:GetFrameStrata())
	Health:Height(26)
	Health:SetPoint("TOPLEFT")
	Health:SetPoint("TOPRIGHT")
	Health:SetStatusBarTexture(HealthTexture)

	Health.Background = Health:CreateTexture(nil, "BACKGROUND")
	Health.Background:SetTexture(HealthTexture)
    Health.Background:SetAllPoints(Health)
	Health.Background.multiplier = C.UnitFrames.StatusBarBackgroundMultiplier / 100

	Health.Value = Health:CreateFontString(nil, "OVERLAY")
	Health.Value:SetFontObject(Font)
	Health.Value:Point("RIGHT", Panel, "RIGHT", -4, 0)

	Health.frequentUpdates = true
	Health.colorDisconnected = true
	Health.colorClass = true
	Health.colorReaction = true
	Health.colorTapping = true

	Health.PreUpdate = TukuiUnitFrames.PreUpdateHealth
	Health.PostUpdate = TukuiUnitFrames.PostUpdateHealth

	if (C.UnitFrames.Smooth) then
		Health.Smooth = true
	end

	local Power = CreateFrame("StatusBar", nil, self)
	Power:SetFrameStrata(self:GetFrameStrata())
	Power:Height(8)
	Power:Point("TOPLEFT", Health, "BOTTOMLEFT", 0, -1)
	Power:Point("TOPRIGHT", Health, "BOTTOMRIGHT", 0, -1)
	Power:SetStatusBarTexture(PowerTexture)

	Power.Background = Power:CreateTexture(nil, "BORDER")
	Power.Background:SetTexture(PowerTexture)
	Power.Background:SetAllPoints(Power)
	Power.Background.multiplier = C.UnitFrames.StatusBarBackgroundMultiplier / 100

	if C.UnitFrames.ShowTargetManaText then
		Power.Value = Power:CreateFontString(nil, "OVERLAY")
		Power.Value:SetFontObject(Font)
		Power.Value:SetPoint("RIGHT", -4, 4)
		Power.PostUpdate = TukuiUnitFrames.PostUpdatePower
	end

	Power.frequentUpdates = true
	Power.colorPower = true

	if (C.UnitFrames.Smooth) then
		Power.Smooth = true
	end

	if C.UnitFrames.Portrait then
		local Portrait

		if C.UnitFrames.Portrait2D then
			Portrait = self:CreateTexture(nil, 'OVERLAY')
			Portrait:SetTexCoord(0.1,0.9,0.1,0.9)
		else
			Portrait = CreateFrame("PlayerModel", nil, Health)
			Portrait:SetFrameStrata(self:GetFrameStrata())
			Portrait:SetBackdrop(TukuiUnitFrames.Backdrop)
			Portrait:SetBackdropColor(0, 0, 0)
			Portrait:CreateBackdrop()

			Portrait.Backdrop:SetOutside(Portrait, -1, 1)
			Portrait.Backdrop:SetBorderColor(unpack(C["General"].BorderColor))
		end

		Portrait:Size(Health:GetHeight() + Power:GetHeight() + 1)
		Portrait:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0 ,0)

		Health:ClearAllPoints()
		Health:SetPoint("TOPLEFT")
		Health:SetPoint("TOPRIGHT", -Portrait:GetWidth() - 1, 0)

		self.Portrait = Portrait
	end

	local Name = Panel:CreateFontString(nil, "OVERLAY")
	Name:Point("LEFT", Panel, "LEFT", 4, 0)
	Name:SetJustifyH("LEFT")
	Name:SetFontObject(Font)

	if (C.UnitFrames.CastBar) then
		local CastBar = CreateFrame("StatusBar", "TukuiTargetCastBar", self)
		CastBar:SetFrameStrata(self:GetFrameStrata())
		CastBar:SetStatusBarTexture(CastTexture)
		CastBar:SetFrameLevel(6)
		CastBar:SetInside(Panel)

		CastBar.Background = CastBar:CreateTexture(nil, "BORDER")
		CastBar.Background:SetAllPoints(CastBar)
		CastBar.Background:SetTexture(CastTexture)
		CastBar.Background:SetVertexColor(0.15, 0.15, 0.15)

		CastBar.Time = CastBar:CreateFontString(nil, "OVERLAY")
		CastBar.Time:SetFontObject(Font)
		CastBar.Time:Point("RIGHT", Panel, "RIGHT", -4, 0)
		CastBar.Time:SetTextColor(0.84, 0.75, 0.65)
		CastBar.Time:SetJustifyH("RIGHT")

		CastBar.Text = CastBar:CreateFontString(nil, "OVERLAY")
		CastBar.Text:SetFontObject(Font)
		CastBar.Text:Point("LEFT", Panel, "LEFT", 4, 0)
		CastBar.Text:SetTextColor(0.84, 0.75, 0.65)
		CastBar.Text:SetWidth(166)
		CastBar.Text:SetJustifyH("LEFT")

		if (C.UnitFrames.CastBarIcon) then
			CastBar.Button = CreateFrame("Frame", nil, CastBar)
			CastBar.Button:Size(26)
			CastBar.Button:SetTemplate()
			CastBar.Button:CreateShadow()
			CastBar.Button:Point("RIGHT", 46.5, 26.5)

			CastBar.Icon = CastBar.Button:CreateTexture(nil, "ARTWORK")
			CastBar.Icon:SetInside()
			CastBar.Icon:SetTexCoord(unpack(T.IconCoord))
		end

		if (C.UnitFrames.CastBarLatency) then
			CastBar.SafeZone = CastBar:CreateTexture(nil, "ARTWORK")
			CastBar.SafeZone:SetTexture(CastTexture)
			CastBar.SafeZone:SetVertexColor(0.69, 0.31, 0.31, 0.75)
		end

		CastBar.CustomTimeText = TukuiUnitFrames.CustomCastTimeText
		CastBar.CustomDelayText = TukuiUnitFrames.CustomCastDelayText
		CastBar.PostCastStart = TukuiUnitFrames.CheckCast
		CastBar.PostChannelStart = TukuiUnitFrames.CheckChannel

		if (C.UnitFrames.UnlinkCastBar) then
			CastBar:ClearAllPoints()
			CastBar:SetWidth(200)
			CastBar:SetHeight(23)
			CastBar:SetPoint("TOP", UIParent, "TOP", 0, -140)
			CastBar:CreateShadow()

			if (C.UnitFrames.CastBarIcon) then
				CastBar.Icon:ClearAllPoints()
				CastBar.Icon:SetPoint("RIGHT", CastBar, "LEFT", -8, 0)
				CastBar.Icon:SetSize(CastBar:GetHeight(), CastBar:GetHeight())

				CastBar.Button:ClearAllPoints()
				CastBar.Button:SetAllPoints(CastBar.Icon)
			end

			CastBar.Time:ClearAllPoints()
			CastBar.Time:Point("RIGHT", CastBar, "RIGHT", -4, 0)

			CastBar.Text:ClearAllPoints()
			CastBar.Text:Point("LEFT", CastBar, "LEFT", 4, 0)

			Movers:RegisterFrame(CastBar)
		end

		self.Castbar = CastBar
	end

	if (C.UnitFrames.TargetAuras) then
		local Buffs = CreateFrame("Frame", self:GetName()..'Buffs', self)
		local Debuffs = CreateFrame("Frame", self:GetName()..'Debuffs', self)

		Buffs:SetFrameStrata(self:GetFrameStrata())
		Buffs:Point("BOTTOMLEFT", self, "TOPLEFT", -1, 4)

		Buffs:SetHeight(28)
		Buffs:SetWidth(252)
		Buffs.size = 28
		Buffs.num = 32
		Buffs.numRow = 4

		Debuffs:SetFrameStrata(self:GetFrameStrata())
		Debuffs:SetHeight(28)
		Debuffs:SetWidth(252)
		Debuffs:SetPoint("BOTTOMLEFT", Buffs, "TOPLEFT", 0, 18)
		Debuffs.size = 28
		Debuffs.num = 16
		Debuffs.numRow = 2

		Buffs.spacing = 4
		Buffs.initialAnchor = "TOPLEFT"
		Buffs.PostCreateIcon = TukuiUnitFrames.PostCreateAura
		Buffs.PostUpdateIcon = TukuiUnitFrames.PostUpdateAura
		Buffs.PostUpdate = TukuiUnitFrames.UpdateDebuffsHeaderPosition
		Buffs.onlyShowPlayer = C.UnitFrames.OnlySelfBuffs

		Debuffs.spacing = 4
		Debuffs.initialAnchor = "TOPRIGHT"
		Debuffs["growth-y"] = "UP"
		Debuffs["growth-x"] = "LEFT"
		Debuffs.PostCreateIcon = TukuiUnitFrames.PostCreateAura
		Debuffs.PostUpdateIcon = TukuiUnitFrames.PostUpdateAura
		Debuffs.onlyShowPlayer = C.UnitFrames.OnlySelfDebuffs

		if C.UnitFrames.AurasBelow then
			Buffs:Point("BOTTOMLEFT", self, "BOTTOMLEFT", 0, -32)
			Debuffs["growth-y"] = "DOWN"
		end

		self.Buffs = Buffs
		self.Debuffs = Debuffs
	end

	if (C.UnitFrames.CombatLog) then
		local CombatFeedbackText = Health:CreateFontString(nil, "OVERLAY")
		CombatFeedbackText:SetFontObject(Font)
		CombatFeedbackText:SetFont(CombatFeedbackText:GetFont(), 14, "THINOUTLINE")
		CombatFeedbackText:SetPoint("CENTER", 0, -1)
		CombatFeedbackText.colors = {
			DAMAGE = {0.69, 0.31, 0.31},
			CRUSHING = {0.69, 0.31, 0.31},
			CRITICAL = {0.69, 0.31, 0.31},
			GLANCING = {0.69, 0.31, 0.31},
			STANDARD = {0.84, 0.75, 0.65},
			IMMUNE = {0.84, 0.75, 0.65},
			ABSORB = {0.84, 0.75, 0.65},
			BLOCK = {0.84, 0.75, 0.65},
			RESIST = {0.84, 0.75, 0.65},
			MISS = {0.84, 0.75, 0.65},
			HEAL = {0.33, 0.59, 0.33},
			CRITHEAL = {0.33, 0.59, 0.33},
			ENERGIZE = {0.31, 0.45, 0.63},
			CRITENERGIZE = {0.31, 0.45, 0.63},
		}

		self.CombatFeedbackText = CombatFeedbackText
	end

	local RaidIcon = Health:CreateTexture(nil, "OVERLAY")
	RaidIcon:Size(C.UnitFrames.RaidIconSize)
	RaidIcon:SetPoint("TOP", self, 0, C.UnitFrames.RaidIconSize / 2)
	RaidIcon:SetTexture([[Interface\AddOns\Tukui\Medias\Textures\Others\RaidIcons]])

	if C.UnitFrames.HealComm then
		local myBar = CreateFrame("StatusBar", nil, Health)
		local otherBar = CreateFrame("StatusBar", nil, Health)

		myBar:SetFrameLevel(Health:GetFrameLevel())
		myBar:SetStatusBarTexture(HealthTexture)
		myBar:SetPoint("TOP")
		myBar:SetPoint("BOTTOM")
		myBar:SetPoint("LEFT", Health:GetStatusBarTexture(), "RIGHT")
		myBar:SetWidth(250)
		myBar:SetStatusBarColor(unpack(C.UnitFrames.HealCommSelfColor))

		otherBar:SetFrameLevel(Health:GetFrameLevel())
		otherBar:SetPoint("TOP")
		otherBar:SetPoint("BOTTOM")
		otherBar:SetPoint("LEFT", myBar:GetStatusBarTexture(), "RIGHT")
		otherBar:SetWidth(250)
		otherBar:SetStatusBarTexture(HealthTexture)
		otherBar:SetStatusBarColor(unpack(C.UnitFrames.HealCommOtherColor))

		local HealthPrediction = {
			myBar = myBar,
			otherBar = otherBar,
			maxOverflow = 1,
		}

		self.HealthPrediction = HealthPrediction
	end

	self:Tag(Name, "[Tukui:GetNameColor][Tukui:NameLong] [Tukui:Classification][Tukui:DiffColor][level]")
	self.Name = Name
	self.Panel = Panel
	self.Health = Health
	self.Health.bg = Health.Background
	self.Power = Power
	self.Power.bg = Power.Background
	self.RaidTargetIndicator = RaidIcon
end
