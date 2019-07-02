local T, C, L = select(2, ...):unpack()

local Miscellaneous = T["Miscellaneous"]
local Experience = CreateFrame("Frame", nil, UIParent)
local HideTooltip = GameTooltip_Hide
local Panels = T["Panels"]
local Bars = 20

Experience.NumBars = 2
Experience.RestedColor = {75 / 255, 175 / 255, 76 / 255}
Experience.XPColor = {0 / 255, 144 / 255, 255 / 255}

function Experience:SetTooltip()
	local BarType = self.BarType
	local Current, Max, Pts

	if (self == Experience.XPBar1) then
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", -1, 5)
	else
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT", 1, 5)
	end

	if BarType == "XP" then
		local Rested = GetXPExhaustion()
		local IsRested = GetRestState()

		Current, Max = Experience:GetExperience()

		if Max == 0 then
			return
		end

		GameTooltip:AddLine("|cff0090FF"..XP..": " .. Current .. " / " .. Max .. " (" .. floor(Current / Max * 100) .. "% - " .. floor(Bars - (Bars * (Max - Current) / Max)) .. "/" .. Bars .. ")|r")

		if (IsRested == 1 and Rested) then
			GameTooltip:AddLine("|cff4BAF4C"..TUTORIAL_TITLE26..": +" .. Rested .." (" .. floor(Rested / Max * 100) .. "%)|r")
		end
	end

	GameTooltip:Show()
end

function Experience:GetExperience()
	return UnitXP("player"), UnitXPMax("player")
end


function Experience:Update(event, owner)
	if (event == "UNIT_INVENTORY_CHANGED" and owner ~= "player") then
		return
	end

	local PlayerLevel = UnitLevel("player")

	local Current, Max = self:GetExperience()
	local Rested = GetXPExhaustion()
	local IsRested = GetRestState()

	for i = 1, self.NumBars do
		local Bar = self["XPBar"..i]
		local RestedBar = self["RestedBar"..i]
		local r, g, b
		local InstanceType = select(2, IsInInstance())

		Bar.BarType = "XP"

		local BarType = Bar.BarType

		Bar:SetMinMaxValues(0, Max)
		Bar:SetValue(Current)

		if (BarType == "XP" and IsRested == 1 and Rested) then
			RestedBar:Show()
			RestedBar:SetMinMaxValues(0, Max)
			RestedBar:SetValue(Rested + Current)
		else
			RestedBar:Hide()
		end

		if BarType == "XP" then
			r, g, b = unpack(self.XPColor)
		end

		Bar:SetStatusBarColor(r, g, b)
	end
end

function Experience:Create()
	for i = 1, self.NumBars do
		local XPBar = CreateFrame("StatusBar", nil, UIParent)
		local RestedBar = CreateFrame("StatusBar", nil, XPBar)

		XPBar:SetStatusBarTexture(C.Medias.Normal)
		XPBar:EnableMouse()
		XPBar:SetFrameStrata("BACKGROUND")
		XPBar:SetFrameLevel(3)
		XPBar:CreateBackdrop()
		XPBar:SetScript("OnEnter", Experience.SetTooltip)
		XPBar:SetScript("OnLeave", HideTooltip)

		RestedBar:SetStatusBarTexture(C.Medias.Normal)
		RestedBar:SetFrameStrata("BACKGROUND")
		RestedBar:SetStatusBarColor(unpack(self.RestedColor))
		RestedBar:SetAllPoints(XPBar)
		RestedBar:SetOrientation("HORIZONTAL")
		RestedBar:SetFrameLevel(XPBar:GetFrameLevel() - 1)
		RestedBar:SetAlpha(.5)
		RestedBar:SetReverseFill(i == 2 and true)

		XPBar:SetSize(i == 1 and Panels.LeftChatBG:GetWidth() or Panels.RightChatBG:GetWidth(), 6)
		XPBar:Point("BOTTOMLEFT", i == 1 and Panels.LeftChatBG or Panels.RightChatBG, "TOPLEFT", 0, 4)
		XPBar:SetReverseFill(i == 2 and true)

		XPBar.Backdrop:CreateShadow()

		self["XPBar"..i] = XPBar
		self["RestedBar"..i] = RestedBar
	end

	self:RegisterEvent("PLAYER_XP_UPDATE")
	self:RegisterEvent("PLAYER_LEVEL_UP")
	self:RegisterEvent("UPDATE_EXHAUSTION")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_UPDATE_RESTING")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED")
	--self:RegisterEvent("HONOR_XP_UPDATE")
	--self:RegisterEvent("HONOR_LEVEL_UPDATE")
	--self:RegisterEvent("AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED")
	--self:RegisterEvent("RESPEC_AZERITE_EMPOWERED_ITEM_CLOSED")
	self:RegisterEvent("PLAYER_MONEY")

	self:SetScript("OnEvent", self.Update)
end

function Experience:Enable()
	if not C.Misc.ExperienceEnable then
		return
	end

	if not self.IsCreated then
		self:Create()

		self.IsCreated = true
	end

	for i = 1, self.NumBars do
		if not self["XPBar"..i]:IsShown() then
			self["XPBar"..i]:Show()
		end

		if not self["RestedBar"..i]:IsShown() then
			self["RestedBar"..i]:Show()
		end
	end
end

function Experience:Disable()
	for i = 1, self.NumBars do
		if self["XPBar"..i]:IsShown() then
			self["XPBar"..i]:Hide()
		end

		if self["RestedBar"..i]:IsShown() then
			self["RestedBar"..i]:Hide()
		end
	end
end

Miscellaneous.Experience = Experience
