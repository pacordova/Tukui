local T, C, L = select(2, ...):unpack()

local Panels = CreateFrame("Frame")

function Panels:Enable()
	local BottomLine = CreateFrame("Frame", "TukuiBottomLine", UIParent)
	BottomLine:SetTemplate()
	BottomLine:Size(2)
	BottomLine:Point("BOTTOMLEFT", 30, 30)
	BottomLine:Point("BOTTOMRIGHT", -30, 30)
	BottomLine:SetFrameStrata("BACKGROUND")
	BottomLine:SetFrameLevel(0)

	local LeftVerticalLine = CreateFrame("Frame", nil, BottomLine)
	LeftVerticalLine:SetTemplate()
	LeftVerticalLine:Size(2, 130)
	LeftVerticalLine:Point("BOTTOMLEFT", 0, 0)
	LeftVerticalLine:SetFrameLevel(0)
	LeftVerticalLine:SetFrameStrata("BACKGROUND")
	LeftVerticalLine:SetAlpha(0)

	local RightVerticalLine = CreateFrame("Frame", nil, BottomLine)
	RightVerticalLine:SetTemplate()
	RightVerticalLine:Size(2, 130)
	RightVerticalLine:Point("BOTTOMRIGHT", 0, 0)
	RightVerticalLine:SetFrameLevel(0)
	RightVerticalLine:SetFrameStrata("BACKGROUND")
	RightVerticalLine:SetAlpha(0)

	local DataTextLeft = CreateFrame("Frame", "TukuiLeftDataTextBox", UIParent)
	DataTextLeft:Size(C.General.Themes.Value == "Tukui 18" and C.Chat.LeftWidth or 370, 23)
	DataTextLeft:SetPoint("LEFT", BottomLine, 4, -1)
	DataTextLeft:SetTemplate()
	DataTextLeft:SetFrameStrata("BACKGROUND")
	DataTextLeft:SetFrameLevel(2)

	local DataTextRight = CreateFrame("Frame", "TukuiRightDataTextBox", UIParent)
	DataTextRight:Size(C.General.Themes.Value == "Tukui 18" and C.Chat.RightWidth or 370, 23)
	DataTextRight:SetPoint("RIGHT", BottomLine, -4, -1)
	DataTextRight:SetTemplate()
	DataTextRight:SetFrameStrata("BACKGROUND")
	DataTextRight:SetFrameLevel(2)

	BottomLine:SetAlpha(0)

	local LeftChatBG = CreateFrame("Frame", "TukuiChatLeftBackground", DataTextLeft)
	LeftChatBG:Size(DataTextLeft:GetWidth() + 12, C.General.Themes.Value == "Tukui 18" and C.Chat.LeftHeight or 177)
	LeftChatBG:Point("BOTTOM", DataTextLeft, "BOTTOM", 0, -6)
	LeftChatBG:SetFrameLevel(1)
	LeftChatBG:SetFrameStrata("BACKGROUND")
	LeftChatBG:CreateBackdrop("Transparent")
	LeftChatBG.Backdrop:CreateShadow()

	local RightChatBG = CreateFrame("Frame", "TukuiChatRightBackground", DataTextRight)
	RightChatBG:Size(DataTextRight:GetWidth() + 12, C.General.Themes.Value == "Tukui 18" and C.Chat.RightHeight or 177)
	RightChatBG:Point("BOTTOM", DataTextRight, "BOTTOM", 0, -6)
	RightChatBG:SetFrameLevel(1)
	RightChatBG:SetFrameStrata("BACKGROUND")
	RightChatBG:CreateBackdrop("Transparent")
	RightChatBG.Backdrop:CreateShadow()

	local TabsBGLeft = CreateFrame("Frame", nil, LeftChatBG)
	TabsBGLeft:SetTemplate()
	TabsBGLeft:Size(DataTextLeft:GetWidth(), 23)
	TabsBGLeft:Point("TOP", LeftChatBG, "TOP", 0, -6)
	TabsBGLeft:SetFrameLevel(2)

	local TabsBGRight = CreateFrame("Frame", nil, RightChatBG)
	TabsBGRight:SetTemplate()
	TabsBGRight:Size(DataTextRight:GetWidth(), 23)
	TabsBGRight:Point("TOP", RightChatBG, "TOP", 0, -6)
	TabsBGRight:SetFrameLevel(2)

	self.LeftChatBG = LeftChatBG
	self.RightChatBG = RightChatBG
	self.TabsBGLeft = TabsBGLeft
	self.TabsBGRight = TabsBGRight

	self.BottomLine = BottomLine
	self.LeftVerticalLine = LeftVerticalLine
	self.RightVerticalLine = RightVerticalLine
	self.DataTextLeft = DataTextLeft
	self.DataTextRight = DataTextRight
end

T["Panels"] = Panels
