local T, C, L = select(2, ...):unpack()

local TukuiActionBars = T["ActionBars"]
local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS

function TukuiActionBars:CreatePetBar()
	local Bar = T.Panels.PetActionBar
	local Movers = T["Movers"]

	if (not C.ActionBars.Pet) then
		Bar.Backdrop:StripTextures()

		return
	end

	local PetSize = C.ActionBars.PetButtonSize
	local Spacing = C.ActionBars.ButtonSpacing
	local PetActionBarFrame = PetActionBarFrame
	local PetActionBar_UpdateCooldowns = PetActionBar_UpdateCooldowns
	
	PetActionBarFrame:EnableMouse(0)
	PetActionBarFrame:ClearAllPoints()
	PetActionBarFrame:SetParent(T.Hider)

	for i = 1, NUM_PET_ACTION_SLOTS do
		local Button = _G["PetActionButton"..i]
		Button:ClearAllPoints()
		Button:SetParent(Bar)
		Button:Size(PetSize)
		Button:SetNormalTexture("")
		Button:Show()

		if (i == 1) then
			Button:SetPoint("TOPLEFT", Spacing, -Spacing)

			Bar:SetHeight(Button:GetWidth() + (Spacing * 2))
			Bar:SetWidth((Button:GetWidth() * 10) + (Spacing * 11))
		else
			Button:SetPoint("LEFT", _G["PetActionButton"..(i - 1)], "RIGHT", Spacing, 0)
		end

		Bar:SetAttribute("addchild", Button)
		Bar["Button"..i] = Button
	end

	hooksecurefunc("PetActionBar_Update", TukuiActionBars.UpdatePetBar)

	TukuiActionBars:SkinPetButtons()

	RegisterStateDriver(Bar, "visibility", "[pet] show; hide")

	Movers:RegisterFrame(Bar)
end
