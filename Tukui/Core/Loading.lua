local T, C, L = select(2, ...):unpack()

local Loading = CreateFrame("Frame")

function Loading:LoadCustomSettings()
	local Settings
	local Name = UnitName("Player")
	local Realm = GetRealmName()

	if (TukuiConfigPerAccount) then
		Settings = TukuiConfigShared.Account
	else
		Settings = TukuiConfigShared[Realm][Name]
	end

	for group, options in pairs(Settings) do
		if C[group] then
			local Count = 0

			for option, value in pairs(options) do
				if (C[group][option] ~= nil) then
					if (C[group][option] == value) then
						Settings[group][option] = nil
					else
						Count = Count + 1

						C[group][option] = value
					end
				end
			end

			-- Keeps TukuiConfig clean and small
			if (Count == 0) then
				Settings[group] = nil
			end
		else
			Settings[group] = nil
		end
	end
end

function Loading:Enable()
	local IsConfigLoaded = IsAddOnLoaded("Tukui_Config")
	local Toolkit = UIToolkit

	if IsConfigLoaded then
		self:LoadCustomSettings()

		Toolkit.Settings.UIScale = C.General.Scaling.Value

		SetCVar("uiScale", C.General.Scaling.Value)
		SetCVar("useUiScale", 1)
	end

	if C.General.HideShadows then
		Toolkit.Settings.ShadowTexture = ""
	end
end

function Loading:OnEvent(event)
	if (event == "PLAYER_LOGIN") then
			T["Loading"]:Enable()
			T["Panels"]:Enable()
			T["Inventory"]["Bags"]:Enable()
			T["Inventory"]["Loot"]:Enable()
			T["Inventory"]["Merchant"]:Enable()
			T["ActionBars"]:Enable()
			T["Cooldowns"]:Enable()
			T["Miscellaneous"]["Experience"]:Enable()
			T["Miscellaneous"]["Reputation"]:Enable()
			T["Miscellaneous"]["ErrorFilter"]:Enable()
			T["Miscellaneous"]["MirrorTimers"]:Enable()
			T["Miscellaneous"]["DropDown"]:Enable()
			T["Miscellaneous"]["CollectGarbage"]:Enable()
			T["Miscellaneous"]["GameMenu"]:Enable()
			T["Miscellaneous"]["StaticPopups"]:Enable()
			T["Miscellaneous"]["Durability"]:Enable()
			--T["Miscellaneous"]["UIWidgets"]:Enable()
			T["Miscellaneous"]["AFK"]:Enable()
			T["Miscellaneous"]["MicroMenu"]:Enable()
			T["Auras"]:Enable()
			T["Maps"]["Minimap"]:Enable()
			--T["Maps"]["Zonemap"]:Enable()
			T["Maps"]["Worldmap"]:Enable()
			T["DataTexts"]:Enable()
			T["Chat"]:Enable()
			T["UnitFrames"]:Enable()
			T["Tooltips"]:Enable()

			print(T.WelcomeMessage)
	elseif (event == "PLAYER_ENTERING_WORLD") then
			T["Miscellaneous"]["ObjectiveTracker"]:Enable()
	end
end

Loading:RegisterEvent("PLAYER_LOGIN")
Loading:RegisterEvent("PLAYER_ENTERING_WORLD")
Loading:RegisterEvent("ADDON_LOADED")
Loading:SetScript("OnEvent", Loading.OnEvent)

T["Loading"] = Loading

