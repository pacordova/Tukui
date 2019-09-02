local T, C, L = select(2, ...):unpack()

local TukuiActionBars = T["ActionBars"]
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS

function TukuiActionBars:CreateBar2()
	local Movers = T["Movers"]
	local Size = C.ActionBars.NormalButtonSize
	local Spacing = C.ActionBars.ButtonSpacing
	local MultiBarBottomLeft = MultiBarBottomLeft
	local ActionBar2 = T.Panels.ActionBar2

	MultiBarBottomLeft:SetParent(ActionBar2)
	MultiBarBottomLeft:SetScript("OnHide", function() ActionBar2.Backdrop:Hide() end)
	MultiBarBottomLeft:SetScript("OnShow", function() ActionBar2.Backdrop:Show() end)

	for i = 1, NUM_ACTIONBAR_BUTTONS do
		local Button = _G["MultiBarBottomLeftButton"..i]
		local PreviousButton = _G["MultiBarBottomLeftButton"..i-1]

		Button:Size(Size)
		Button:ClearAllPoints()
		Button.noGrid = false
		Button:SetAttribute("showgrid", 1)

		if (i == 1) then
			Button:SetPoint("TOPLEFT", ActionBar2, Spacing, -Spacing)

			ActionBar2:SetWidth((Button:GetWidth() * 12) + (Spacing * 13))
			ActionBar2:SetHeight((Button:GetWidth() * 2) + (Spacing * 3))
		else
			Button:SetPoint("LEFT", PreviousButton, "RIGHT", Spacing, 0)
		end

		ActionBar2["Button"..i] = Button
	end
	
	Movers:RegisterFrame(ActionBar2)
end
