local T, C, L = select(2, ...):unpack()

local TukuiActionBars = T["ActionBars"]
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

function TukuiActionBars:CreateBar5()
	local Movers = T["Movers"]
	local Size = C.ActionBars.NormalButtonSize
	local Spacing = C.ActionBars.ButtonSpacing
	local MultiBarLeft = MultiBarLeft
	local ActionBar5 = T.Panels.ActionBar5

	MultiBarLeft:SetParent(ActionBar5)
	MultiBarLeft:SetScript("OnHide", function() ActionBar5.Backdrop:Hide() end)
	MultiBarLeft:SetScript("OnShow", function() ActionBar5.Backdrop:Show() end)

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local Button = _G["MultiBarLeftButton"..i]
		local PreviousButton = _G["MultiBarLeftButton"..i-1]

		Button:Size(Size)
		Button:ClearAllPoints()
		Button.noGrid = false
		Button:SetAttribute("showgrid", 1)

		if (i == 1) then
			Button:SetPoint("TOPLEFT", ActionBar5, Spacing, -Spacing)

			ActionBar5:SetHeight((Button:GetWidth() * 6) + (Spacing * 7))
			ActionBar5:SetWidth((Button:GetWidth() * 2) + (Spacing * 3))
		elseif (i==7) then
			Button:SetPoint("TOPLEFT", ActionBar5, Button:GetWidth()+2*Spacing, -Spacing)
		else
			Button:SetPoint("TOP", PreviousButton, "BOTTOM", 0, -Spacing)
		end

		ActionBar5["Button"..i] = Button
	end

	Movers:RegisterFrame(ActionBar5)
end
