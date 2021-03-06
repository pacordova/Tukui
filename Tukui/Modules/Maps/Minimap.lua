local T, C, L = select(2, ...):unpack()

local _G = _G
local Miscellaneous = T["Miscellaneous"]
local Maps = T["Maps"]
local Interval = 2
local Panels = T["Panels"]

Minimap.ZoneColors = {
	["friendly"] = {0.1, 1.0, 0.1},
	["sanctuary"] = {0.41, 0.8, 0.94},
	["arena"] = {1.0, 0.1, 0.1},
	["hostile"] = {1.0, 0.1, 0.1},
	["contested"] = {1.0, 0.7, 0.0},
}

function Minimap:DisableMinimapElements()
	local Time = _G["TimeManagerClockButton"]
	local North = _G["MinimapNorthTag"]
	local HiddenFrames = {
		"MinimapCluster",
		"MinimapBorder",
		"MinimapBorderTop",
		"MinimapZoomIn",
		"MinimapZoomOut",
		"MinimapNorthTag",
		"MinimapZoneTextButton",
		"GameTimeFrame",
		"MiniMapWorldMapButton",
	}

	for i, FrameName in pairs(HiddenFrames) do
		local Frame = _G[FrameName]
		Frame:Hide()

		if Frame.UnregisterAllEvents then
			Frame:UnregisterAllEvents()
		end
	end

	North:SetTexture(nil)

	if Time then
		Time:Kill()
	end
end

function Minimap:OnMouseClick(button)
	if (button == "RightButton") or (button == "MiddleButton") then
		Miscellaneous.DropDown.Open(Miscellaneous.MicroMenu.Buttons, Miscellaneous.MicroMenu, "cursor", -160, 0, "MENU", 2)
	else
		Minimap_OnClick(self)
	end
end

function Minimap:StyleMinimap()
	local Mail = MiniMapMailFrame
	local MailBorder = MiniMapMailBorder
	local MailIcon = MiniMapMailIcon
	local QueueStatusMinimapButton = QueueStatusMinimapButton
	local QueueStatusFrame = QueueStatusFrame
	local MiniMapInstanceDifficulty = MiniMapInstanceDifficulty
	local GuildInstanceDifficulty = GuildInstanceDifficulty
	local HelpOpenTicketButton = HelpOpenTicketButton
	local BGFrame = MiniMapBattlefieldFrame
	local BGFrameBorder = MiniMapBattlefieldBorder

	self:SetMaskTexture(C.Medias.Blank)
	self:CreateBackdrop()
	self:SetScript("OnMouseUp", Minimap.OnMouseClick)

	self.Backdrop:SetFrameStrata("BACKGROUND")
	self.Backdrop:SetFrameLevel(2)
	self.Backdrop:CreateShadow()

	self.Ticket = CreateFrame("Frame", nil, Minimap)
	self.Ticket:SetTemplate()
	self.Ticket:Size(Minimap:GetWidth() + 2, 24)
	self.Ticket:SetFrameLevel(Minimap:GetFrameLevel() + 4)
	self.Ticket:SetFrameStrata(Minimap:GetFrameStrata())
	self.Ticket:Point("BOTTOM", 0, -47)
	self.Ticket.Text = self.Ticket:CreateFontString(nil, "OVERLAY")
	self.Ticket.Text:SetFontTemplate(C.Medias.Font, 12)
	self.Ticket.Text:SetPoint("CENTER")
	self.Ticket.Text:SetText(HELP_TICKET_EDIT)
	self.Ticket:SetAlpha(0)
	self.Ticket:CreateShadow()

	Mail:ClearAllPoints()
	Mail:Point("TOPRIGHT", 12, 29)
	Mail:SetFrameLevel(self:GetFrameLevel() + 2)
	MailBorder:Hide()
	MailIcon:SetTexture("Interface\\AddOns\\Tukui\\Medias\\Textures\\Others\\Mail")

	BGFrame:ClearAllPoints()
	BGFrame:Point("BOTTOMRIGHT", Minimap, 3, 0)
	BGFrameBorder:Hide()

	HelpOpenTicketButton:SetParent(Minimap.Ticket)
	HelpOpenTicketButton:SetFrameLevel(Minimap.Ticket:GetFrameLevel() + 1)
	HelpOpenTicketButton:SetFrameStrata(Minimap.Ticket:GetFrameStrata())
	HelpOpenTicketButton:ClearAllPoints()
	HelpOpenTicketButton:SetAllPoints()
	HelpOpenTicketButton:SetHighlightTexture(nil)
	HelpOpenTicketButton:SetAlpha(0)
	HelpOpenTicketButton:HookScript("OnShow", function(self) Minimap.Ticket:SetAlpha(1) end)
	HelpOpenTicketButton:HookScript("OnHide", function(self) Minimap.Ticket:SetAlpha(0) end)

	if (MiniMapTrackingFrame) then
		MiniMapTrackingFrame:ClearAllPoints()
		MiniMapTrackingFrame:Point("TOPRIGHT", Minimap, 4, -1)

		if (MiniMapTrackingBorder) then
			MiniMapTrackingBorder:Hide()
		end

		if (MiniMapTrackingIcon) then
			MiniMapTrackingIcon:SetDrawLayer("ARTWORK")
			MiniMapTrackingIcon:SetTexCoord(unpack(T.IconCoord))
			MiniMapTrackingIcon:Size(16)
		end

		MiniMapTrackingFrame:CreateBackdrop()
		MiniMapTrackingFrame.Backdrop:SetFrameLevel(MiniMapTrackingFrame:GetFrameLevel())
		MiniMapTrackingFrame.Backdrop:SetOutside(MiniMapTrackingIcon)
		MiniMapTrackingFrame.Backdrop:SetTemplate()
		MiniMapTrackingFrame.Backdrop:CreateShadow()
	end
end

function Minimap:PositionMinimap()
	local Movers = T["Movers"]

	self:SetParent(UIParent)
	self:Point("TOPRIGHT", UIParent, "TOPRIGHT", -28, -28)
	self:SetMovable(true)

	Movers:RegisterFrame(self)
end

function Minimap:AddMinimapDataTexts()
	local Backdrop = self.Backdrop

	local MinimapDataText = CreateFrame("Frame", nil, self)
	MinimapDataText:Size(self.Backdrop:GetWidth(), 19)
	MinimapDataText:SetPoint("TOPLEFT", self.Backdrop, "BOTTOMLEFT", 0, 19)
	MinimapDataText:SetTemplate()

	-- Resize Minimap Backdrop
	Backdrop:ClearAllPoints()
	Backdrop:Point("TOPLEFT", self, "TOPLEFT", -1, 1)
	Backdrop:Point("BOTTOMRIGHT", self, "BOTTOMRIGHT", 1, -19)

	Panels.MinimapDataText = MinimapDataText
end

function GetMinimapShape()
	return "SQUARE"
end

function Minimap:AddZoneAndCoords()
	local MinimapZone = CreateFrame("Button", "TukuiMinimapZone", self)
	local MinimapCoords = CreateFrame("Frame", "TukuiMinimapCoord", self)

	MinimapZone:SetTemplate()
	MinimapZone:Size(self:GetWidth() + 2, 19)
	MinimapZone:Point("TOP", self, 0, 2)
	MinimapZone:SetFrameStrata(self:GetFrameStrata())
	MinimapZone:SetAlpha(0)
	MinimapZone:EnableMouse()

	MinimapZone.Text = MinimapZone:CreateFontString("TukuiMinimapZoneText", "OVERLAY")
	MinimapZone.Text:SetFont(C["Medias"].Font, 10)
	MinimapZone.Text:Point("TOP", 0, -1)
	MinimapZone.Text:SetPoint("BOTTOM")
	MinimapZone.Text:Height(12)
	MinimapZone.Text:Width(MinimapZone:GetWidth() - 6)

	MinimapZone.Anim = CreateAnimationGroup(MinimapZone):CreateAnimation("Fade")
	MinimapZone.Anim:SetDuration(0.3)
	MinimapZone.Anim:SetSmoothing("InOut")
	MinimapZone.Anim:SetChange(1)

	MinimapCoords:SetTemplate()
	MinimapCoords:Size(40, 19)
	MinimapCoords:Point("BOTTOMLEFT", self, "BOTTOMLEFT", 2, 2)
	MinimapCoords:SetFrameStrata(self:GetFrameStrata())
	MinimapCoords:SetAlpha(0)

	MinimapCoords.Text = MinimapCoords:CreateFontString("TukuiMinimapCoordText", "OVERLAY")
	MinimapCoords.Text:SetFont(C["Medias"].Font, 10)
	MinimapCoords.Text:Point("Center", 0, -1)
	MinimapCoords.Text:SetText("0, 0")

	MinimapCoords.Anim = CreateAnimationGroup(MinimapCoords):CreateAnimation("Fade")
	MinimapCoords.Anim:SetDuration(0.3)
	MinimapCoords.Anim:SetSmoothing("InOut")
	MinimapCoords.Anim:SetChange(1)

	-- Update zone text
	MinimapZone:RegisterEvent("PLAYER_ENTERING_WORLD")
	MinimapZone:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	MinimapZone:RegisterEvent("ZONE_CHANGED")
	MinimapZone:RegisterEvent("ZONE_CHANGED_INDOORS")
	MinimapZone:SetScript("OnEvent", Minimap.UpdateZone)

	-- Update coordinates
	MinimapCoords:SetScript("OnUpdate", Minimap.UpdateCoords)

	Minimap.MinimapZone = MinimapZone
	Minimap.MinimapCoords = MinimapCoords
end

function Minimap:UpdateCoords(t)
	if (Minimap.MinimapCoords:GetAlpha() == 0) then
		Interval = 0

		return
	end

	Interval = Interval - t

	if (Interval < 0) then
		local UnitMap = C_Map.GetBestMapForUnit("player")
		local X, Y = 0, 0

		if UnitMap then
			local GetPlayerMapPosition = C_Map.GetPlayerMapPosition(UnitMap, "player")

			if GetPlayerMapPosition then
				X, Y = C_Map.GetPlayerMapPosition(UnitMap, "player"):GetXY()
			end
		end

		local XText, YText

		X = math.floor(100 * X)
		Y = math.floor(100 * Y)

		if (X == 0 and Y == 0) then
			Minimap.MinimapCoords:Hide()
		else
			Minimap.MinimapCoords:Show()

			if (X < 10) then
				XText = "0"..X
			else
				XText = X
			end

			if (Y < 10) then
				YText = "0"..Y
			else
				YText = Y
			end

			Minimap.MinimapCoords.Text:SetText(XText .. ", " .. YText)
		end

		Interval = 2
	end
end

function Minimap:UpdateZone()
	local Info = GetZonePVPInfo()

	if Minimap.ZoneColors[Info] then
		local Color = Minimap.ZoneColors[Info]

		Minimap.MinimapZone.Text:SetTextColor(Color[1], Color[2], Color[3])
	else
		Minimap.MinimapZone.Text:SetTextColor(1.0, 1.0, 1.0)
	end

	Minimap.MinimapZone.Text:SetText(GetMinimapZoneText())
end

function Minimap:EnableMouseOver()
	self:SetScript("OnEnter", function()
		Minimap.MinimapZone:SetAlpha(1)
		Minimap.MinimapCoords:SetAlpha(1)
	end)

	self:SetScript("OnLeave", function()
		Minimap.MinimapZone:SetAlpha(0)
		Minimap.MinimapCoords:SetAlpha(0)
	end)
end

function Minimap:SizeMinimap()
	local X, Y = self:GetSize()
	local Scale = C.General.MinimapScale / 100

	self:Size(X * Scale, Y * Scale)
end

function Minimap:EnableMouseWheelZoom()
	self:EnableMouseWheel(true)
	self:SetScript("OnMouseWheel", function(self, delta)
		if (delta > 0) then
			MinimapZoomIn:Click()
		elseif (delta < 0) then
			MinimapZoomOut:Click()
		end
	end)
end

function Minimap:TaxiExitOnEvent(event)
	if UnitOnTaxi("player") then
		self:Show()
	else
		self:Hide()
	end
end

function Minimap:TaxiExitOnClick()
	if (UnitOnTaxi("player")) then
		TaxiRequestEarlyLanding()

		Minimap.EarlyExitButton:Hide()
	end
end

function Minimap:AddTaxiEarlyExit()
	Minimap.EarlyExitButton = CreateFrame("Button", nil, self)
	Minimap.EarlyExitButton:SetAllPoints(Panels.MinimapDataText)
	Minimap.EarlyExitButton:SetSize(Panels.MinimapDataText:GetWidth(), Panels.MinimapDataText:GetHeight())
	Minimap.EarlyExitButton:SkinButton()
	Minimap.EarlyExitButton:CreateShadow()
	Minimap.EarlyExitButton:ClearAllPoints()
	Minimap.EarlyExitButton:SetPoint("TOP", Panels.MinimapDataText, "BOTTOM", 0, -6)
	Minimap.EarlyExitButton:RegisterForClicks("AnyUp")
	Minimap.EarlyExitButton:SetScript("OnClick", Minimap.TaxiExitOnClick)
	Minimap.EarlyExitButton:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
	Minimap.EarlyExitButton:RegisterEvent("PLAYER_ENTERING_WORLD")
	Minimap.EarlyExitButton:SetScript("OnEvent", Minimap.TaxiExitOnEvent)
	Minimap.EarlyExitButton:Hide()

	Minimap.EarlyExitButton.Text = Minimap.EarlyExitButton:CreateFontString(nil, "OVERLAY")
	Minimap.EarlyExitButton.Text:SetFont(C.Medias.Font, 12)
	Minimap.EarlyExitButton.Text:Point("CENTER", 0, 0)
	Minimap.EarlyExitButton.Text:SetShadowOffset(1.25, -1.25)
	Minimap.EarlyExitButton.Text:SetText("|cffFF0000Land at nearest flight path|r")
end

function Minimap:Enable()
	self:DisableMinimapElements()
	self:StyleMinimap()
	self:PositionMinimap()
	self:AddMinimapDataTexts()
	self:AddZoneAndCoords()
	self:EnableMouseOver()
	self:EnableMouseWheelZoom()
	self:AddTaxiEarlyExit()
end

-- Need to be sized as soon as possible, because of LibDBIcon10
Minimap:RegisterEvent("VARIABLES_LOADED")
Minimap:SetScript("OnEvent", function(self, event)
	if event == "VARIABLES_LOADED" then
		self:SizeMinimap()
		self:UnregisterEvent("VARIABLES_LOADED")
	end
end)

T["Maps"].Minimap = Minimap
