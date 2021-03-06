local T, C, L = select(2, ...):unpack()

----------------------------------------------------------------
-- Default settings of Tukui
----------------------------------------------------------------

C["General"] = {
	["BackdropColor"] = {0.11, 0.11, 0.11},
	["BorderColor"] = {0, 0, 0},
	["UseGlobal"] = true,
	["HideShadows"] = false,
	["UIScale"] = T.PerfectScale,
	["MinimapScale"] = 100,
	["WorldMapScale"] = 59,

	["Themes"] = {
		["Options"] = {
			["Tukui 18"] = "Tukui 18",
			["Tukui 17"] = "Tukui 17",
		},

		["Value"] = "Tukui 18",
	},
}

C["ActionBars"] = {
	["Enable"] = true,
	["HotKey"] = false,
	["EquipBorder"] = true,
	["Macro"] = false,
	["ShapeShift"] = true,
	["Pet"] = true,
	["SwitchBarOnStance"] = true,
	["NormalButtonSize"] = 27,
	["PetButtonSize"] = 25,
	["ButtonSpacing"] = 4,
	["HideBackdrop"] = false,
	["Font"] = "Tukui Outline",
}

C["Auras"] = {
	["Enable"] = true,
	["Flash"] = true,
	["ClassicTimer"] = false,
	["HideBuffs"] = true,
	["HideDebuffs"] = false,
	["Animation"] = false,
	["BuffsPerRow"] = 12,
	["Font"] = "Tukui Outline",
}

C["Bags"] = {
	["Enable"] = true,
	["ButtonSize"] = 28,
	["Spacing"] = 4,
	["ItemsPerRow"] = 11,
}

C["Chat"] = {
	["Enable"] = true,
	["LeftWidth"] = 370,
	["LeftHeight"] = 185,
	["RightWidth"] = 370,
	["RightHeight"] = 185,
	["RightChatAlignRight"] = true,
	["BackgroundAlpha"] = 80,
	["WhisperSound"] = true,
	["ShortChannelName"] = true,
	["LinkColor"] = {0.08, 1, 0.36},
	["LinkBrackets"] = true,
	["ScrollByX"] = 3,
	["TextFading"] = false,
	["TextFadingTimer"] = 60,
	["TabFont"] = "Pixel",
	["ChatFont"] = "Pixel",
}

C["Cooldowns"] = {
	["Font"] = "Tukui Outline",
}

C["DataTexts"] = {
	["Battleground"] = true,
	["HideFriendsNotPlaying"] = true,
	["NameColor"] = {1, 1, 1},
	["ValueColor"] = {1, 1, 1},
	["ClassColor"] = false,
	["HighlightColor"] = {1, 1, 0},
	["Hour24"] = false,
	["Font"] = "Tukui",
}

C["Loot"] = {
	["Enable"] = true,
	["Font"] = "Tukui",
}

C["Misc"] = {
	["WorldMapEnable"] = false,
	["ThreatBar"] = true,
	["ExperienceEnable"] = true,
	["ErrorFilterEnable"] = true,
	["AutoSellJunk"] = true,
	["AutoRepair"] = false,
	["AFKSaver"] = false,
	["FadeWorldMapWhileMoving"] = false,
	["ObjectiveTrackerFont"] = "Tukui Outline",
}

C["NamePlates"] = {
	["Enable"] = true,
	["Width"] = 129,
	["Height"] = 12,
	["NameplateCastBar"] = true,
	["Font"] = "Tukui Outline",
	["OnlySelfDebuffs"] = true,
	["HighlightColor"] = {1, 1, 0},
	["HighlightSize"] = 10,
}

C["Party"] = {
	["Enable"] = false,
	["ShowPets"] = false,
	["ShowPlayer"] = true,
	["ShowHealthText"] = true,
	["ShowManaText"] = false,
	["RangeAlpha"] = 0.3,
	["Font"] = "Tukui Outline",
	["HealthFont"] = "Tukui Outline",
	["HighlightColor"] = {0, 1, 0},
	["HighlightSize"] = 10,
}

C["Raid"] = {
	["Enable"] = true,
	["DebuffWatch"] = true,
	["ShowPets"] = false,
	["RangeAlpha"] = 0.3,
	["VerticalHealth"] = false,
	["MaxUnitPerColumn"] = 10,
	["Font"] = "Tukui",
	["HealthFont"] = "Tukui Outline",
	["DesaturateNonPlayerBuffs"] = false,
	["RaidBuffs"] = {
		["Options"] = {
			["Hide"] = "Hide",
			["Only my buffs"] = "Self",
			["Only castable buffs"] = "Castable",
			["All buffs"] = "All",
		},
		["Value"] = "Self",
	},
	["ClassRaidBuffs"] = true,
	["WidthSize"] = 79, --46, --79,
	["HeightSize"] = 55, --32, --55,
	["HighlightColor"] = {0, 1, 0},
	["HighlightSize"] = 10,
	["GroupBy"] = {
		["Options"] = {
			["Group"] = "GROUP",
			["Class"] = "CLASS",
			["Role"] = "ROLE",
		},

		["Value"] = "GROUP",
	},
}

C["Tooltips"] = {
	["Enable"] = true,
	["HideInCombat"] = false,
	["AlwaysCompareItems"] = true,
	["UnitHealthText"] = true,
	["MouseOver"] = false,
	["HealthFont"] = "Tukui Outline",
}

C["Textures"] = {
	["QuestProgressTexture"] = "Tukui",
	["TTHealthTexture"] = "Tukui",
	["UFPowerTexture"] = "Tukui",
	["UFHealthTexture"] = "Tukui",
	["UFCastTexture"] = "Tukui",
	["UFPartyPowerTexture"] = "Tukui",
	["UFPartyHealthTexture"] = "Tukui",
	["UFRaidPowerTexture"] = "Tukui",
	["UFRaidHealthTexture"] = "Tukui",
	["NPHealthTexture"] = "Tukui",
	["NPPowerTexture"] = "Tukui",
	["NPCastTexture"] = "Tukui",
}

C["UnitFrames"] = {
	["Enable"] = true,
	["TotemBar"] = true,
	["HealComm"] = true,
	["PlayerAuraBars"] = false,
	["ScrollingCombatText"] = false,
	["ScrollingCombatTextFontSize"] = 32,
	["ScrollingCombatTextFont"] = "Tukui Damage",
	["StatusBarBackgroundMultiplier"] = 20,
	["PowerTick"] = true,
	["Portrait2D"] = true,
	["OOCNameLevel"] = false,
	["OOCPetNameLevel"] = false,
	["Portrait"] = false,
	["CastBar"] = true,
	["ComboBar"] = true,
	["UnlinkCastBar"] = true,
	["CastBarIcon"] = true,
	["CastBarLatency"] = true,
	["Smooth"] = true,
	["TargetEnemyHostileColor"] = true,
	["ShowTargetManaText"] = false,
	["CombatLog"] = true,
	["PlayerAuras"] = false,
	["TargetAuras"] = true,
	["TOTAuras"] = true,
	["PetAuras"] = true,
	["AurasBelow"] = false,
	["OnlySelfDebuffs"] = false,
	["OnlySelfBuffs"] = false,
	["Font"] = "Tukui Outline",
	["HealCommSelfColor"] = {0.29, 1, 0.30},
	["HealCommOtherColor"] = {1, 1, 0.36},
	["RaidIconSize"] = 24,
}
