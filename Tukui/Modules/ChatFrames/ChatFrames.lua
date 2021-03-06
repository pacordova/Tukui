local T, C, L = select(2, ...):unpack()

local _G = _G
local format = format
local Noop = function() end
local Toast = BNToastFrame
local TukuiChat = T["Chat"]
local UIFrameFadeRemoveFrame = UIFrameFadeRemoveFrame

-- Set default position for Voice Activation Alert
TukuiChat.VoiceAlertPosition = {"BOTTOMLEFT", T.Panels.LeftChatBG, "TOPLEFT", 0, 14}

-- Set name for right chat
TukuiChat.RightChatName = OTHER

-- Update editbox border color
function TukuiChat:UpdateEditBoxColor()
	local EditBox = ChatEdit_ChooseBoxForSend()
	local ChatType = EditBox:GetAttribute("chatType")
	local Backdrop = EditBox.Backdrop

	if Backdrop then
		if (ChatType == "CHANNEL") then
			local ID = GetChannelName(EditBox:GetAttribute("channelTarget"))

			if (ID == 0) then
				local R, G, B = unpack(C["General"].BorderColor)

				Backdrop:SetBorderColor(R, G, B, 1)
			else
				local R, G, B = ChatTypeInfo[ChatType..ID].r, ChatTypeInfo[ChatType..ID].g, ChatTypeInfo[ChatType..ID].b

				Backdrop:SetBorderColor(R, G, B, 1)
			end
		else
			local R, G, B = ChatTypeInfo[ChatType].r, ChatTypeInfo[ChatType].g, ChatTypeInfo[ChatType].b

			Backdrop:SetBorderColor(R, G, B, 1)
		end
	end
end

function TukuiChat:LockChat()
	T.Print(L.Help.ChatMove)
end

function TukuiChat:MoveAudioButtons()
	ChatFrameChannelButton:Kill()
end

function TukuiChat:NoMouseAlpha()
	local Frame = self:GetName()
	local Tab = _G[Frame .. "Tab"]

	if (Tab.noMouseAlpha == 0.4) or (Tab.noMouseAlpha == 0.2) then
		Tab:SetAlpha(0)
		Tab.noMouseAlpha = 0
	end
end

function TukuiChat:SetChatFont()
	local Font = T.GetFont(C["Chat"].ChatFont)
	local Path, _, Flag = _G[Font]:GetFont()
	local CurrentFont, CurrentSize, CurrentFlag = self:GetFont()

	if (CurrentFont == Path and CurrentFlag == Flag) then
		return
	end

	self:SetFont(Path, CurrentSize, Flag)
end

function TukuiChat:StyleFrame(frame)
	if frame.IsSkinned then
		return
	end

	local Frame = frame
	local ID = frame:GetID()
	local FrameName = frame:GetName()
	local Tab = _G[FrameName.."Tab"]
	local TabText = _G[FrameName.."TabText"]
	local Scroll = frame.ScrollBar
	local ScrollBottom = frame.ScrollToBottomButton
	local ScrollTex = _G[FrameName.."ThumbTexture"]
	local EditBox = _G[FrameName.."EditBox"]
	local GetTabFont = T.GetFont(C["Chat"].TabFont)
	local TabFont, TabFontSize, TabFontFlags = _G[GetTabFont]:GetFont()
	local DataTextLeft = T.Panels.DataTextLeft

	if Tab.conversationIcon then
		Tab.conversationIcon:Kill()
	end

	-- Hide editbox every time we click on a tab
	Tab:HookScript("OnClick", function()
		EditBox:Hide()
	end)

	-- Kill Scroll Bars
	if Scroll then
		Scroll:Kill()
		ScrollBottom:Kill()
		ScrollTex:Kill()
	end

	-- Style the tab font
	TabText:SetFont(TabFont, TabFontSize, TabFontFlags)
	TabText.SetFont = Noop

	Tab:SetAlpha(1)
	Tab.SetAlpha = UIFrameFadeRemoveFrame

	Frame:SetClampRectInsets(0, 0, 0, 0)
	Frame:SetClampedToScreen(false)
	Frame:SetFading(C.Chat.TextFading)
	Frame:SetTimeVisible(C.Chat.TextFadingTimer)

	-- Move the edit box
	EditBox:ClearAllPoints()
	EditBox:SetInside(DataTextLeft)

	-- Disable alt key usage
	EditBox:SetAltArrowKeyMode(false)
	EditBox:SetFont(TabFont, TabFontSize, TabFontFlags)

	-- Hide editbox on login
	EditBox:Hide()

	-- Hide editbox instead of fading
	EditBox:HookScript("OnEditFocusLost", function(self)
		self:Hide()
	end)

	-- Create our own texture for edit box
	EditBox:CreateBackdrop()
	EditBox.Backdrop:ClearAllPoints()
	EditBox.Backdrop:SetAllPoints(DataTextLeft)
	EditBox.Backdrop:SetFrameStrata("LOW")
	EditBox.Backdrop:SetFrameLevel(1)
	EditBox.Backdrop:SetBackdropColor(unpack(C["General"].BackdropColor))

	-- Hide textures
	for i = 1, #CHAT_FRAME_TEXTURES do
		_G[FrameName..CHAT_FRAME_TEXTURES[i]]:SetTexture(nil)
	end

	-- Remove default chatframe tab textures
	_G[format("ChatFrame%sTabLeft", ID)]:Kill()
	_G[format("ChatFrame%sTabMiddle", ID)]:Kill()
	_G[format("ChatFrame%sTabRight", ID)]:Kill()

	_G[format("ChatFrame%sTabSelectedLeft", ID)]:Kill()
	_G[format("ChatFrame%sTabSelectedMiddle", ID)]:Kill()
	_G[format("ChatFrame%sTabSelectedRight", ID)]:Kill()

	_G[format("ChatFrame%sTabHighlightLeft", ID)]:Kill()
	_G[format("ChatFrame%sTabHighlightMiddle", ID)]:Kill()
	_G[format("ChatFrame%sTabHighlightRight", ID)]:Kill()

	_G[format("ChatFrame%sTabSelectedLeft", ID)]:Kill()
	_G[format("ChatFrame%sTabSelectedMiddle", ID)]:Kill()
	_G[format("ChatFrame%sTabSelectedRight", ID)]:Kill()

	_G[format("ChatFrame%sButtonFrameMinimizeButton", ID)]:Kill()
	_G[format("ChatFrame%sButtonFrame", ID)]:Kill()

	_G[format("ChatFrame%sEditBoxLeft", ID)]:Kill()
	_G[format("ChatFrame%sEditBoxMid", ID)]:Kill()
	_G[format("ChatFrame%sEditBoxRight", ID)]:Kill()

	-- Mouse Wheel
	Frame:SetScript("OnMouseWheel", TukuiChat.OnMouseWheel)

	-- Temp Chats
	if (ID > 10) then
		self.SetChatFont(Frame)
	end

	-- Security for font, in case if revert back to WoW default we restore instantly the tukui font default.
	hooksecurefunc(Frame, "SetFont", TukuiChat.SetChatFont)

	Frame.IsSkinned = true
end

function TukuiChat:StyleTempFrame()
	local Frame = FCF_GetCurrentChatFrame()

	-- Make sure it's not skinned already
	if Frame.IsSkinned then
		return
	end

	-- Pass it on
	TukuiChat:StyleFrame(Frame)
end

function TukuiChat:SkinToastFrame()
	Toast:SetTemplate()
	Toast:CreateShadow()
	Toast.CloseButton:SkinCloseButton()
end

function TukuiChat:SetDefaultChatFramesPositions()
	if (not TukuiData[GetRealmName()][UnitName("Player")].Chat) then
		TukuiData[GetRealmName()][UnitName("Player")].Chat = {}
	end

	local Width = 370

	for i = 1, NUM_CHAT_WINDOWS do
		local Frame = _G["ChatFrame"..i]
		local ID = Frame:GetID()

		-- Set font size and chat frame size
		Frame:Size(Width, 119)

		-- Set default chat frame position
		if (ID == 1) then
			Frame:ClearAllPoints()
			Frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 34, 50)
		elseif (ID ==2) then
			Frame:ClearAllPoints()
			Frame:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -34, 50)
		end

		if (ID == 1) then
			FCF_SetWindowName(Frame, "G, S & W")
		end

		if (ID == 2) then
			FCF_SetWindowName(Frame, " ")
		end

		if (not Frame.isLocked) then
			FCF_SetLocked(Frame, 1)
		end

		local Anchor1, Parent, Anchor2, X, Y = Frame:GetPoint()
		TukuiData[GetRealmName()][UnitName("Player")].Chat["Frame" .. i] = {Anchor1, Anchor2, X, Y, Width, 108}
	end
end

function TukuiChat:SaveChatFramePositionAndDimensions()
	local Anchor1, _, Anchor2, X, Y = self:GetPoint()
	local Width, Height = self:GetSize()
	local ID = self:GetID()

	if not (TukuiData[GetRealmName()][UnitName("Player")].Chat) then
		TukuiData[GetRealmName()][UnitName("Player")].Chat = {}
	end

	TukuiData[GetRealmName()][UnitName("Player")].Chat["Frame" .. ID] = {Anchor1, Anchor2, X, Y, Width, Height}
end

function TukuiChat:RemoveRightChat()
	if not UIParent:IsShown() then
		return
	end

	local Panels = T.Panels

	Panels.RightChatBG:Hide()

	if C.Misc.ExperienceEnable then
		local XP = T.Miscellaneous.Experience.XPBar2
		local Rep = T.Miscellaneous.Reputation.RepBar2

		XP:SetParent(T.Hider)
		Rep:SetParent(T.Hider)
	end

	Panels.DataTextRight:Hide()
end

function TukuiChat:SetChatFramePosition()
	if (not TukuiData[GetRealmName()][UnitName("Player")].Chat) then
		return
	end

	local Frame = self
	local ID = Frame:GetID()

	local Settings = TukuiData[GetRealmName()][UnitName("Player")].Chat["Frame" .. ID]

	if Settings then
		if C.General.Themes.Value == "Tukui 18" then
			local Anchor1, Anchor2, X, Y, Width, Height = unpack(Settings)
			local Movers = T.Movers
			local Panels = T.Panels

			if ID == 1 then
				Frame:SetParent(Panels.DataTextLeft)
				Frame:SetUserPlaced(true)
				Frame:ClearAllPoints()
				Frame:SetSize(C.Chat.LeftWidth, C.Chat.LeftHeight - 62)
				Frame:SetPoint("BOTTOMLEFT", Panels.DataTextLeft, "TOPLEFT", 0, 2)

				Movers:RegisterFrame(T.Panels.DataTextLeft)
			elseif (ID == 2) then
				if Frame:IsShown() and not Frame.isDocked then
					Frame:SetParent(Panels.DataTextRight)
					Frame:SetUserPlaced(true)
					Frame:ClearAllPoints()
					Frame:SetSize(C.Chat.RightWidth, C.Chat.RightHeight - 62)
					Frame:SetPoint("BOTTOMLEFT", Panels.DataTextRight, "TOPLEFT", 0, 2)

					if C.Chat.RightChatAlignRight then
						Frame:SetJustifyH("RIGHT")
					end

					Movers:RegisterFrame(T.Panels.DataTextRight)
				end
			end
		else
			if not Frame:IsMovable() then
				return
			end

			local Anchor1, Anchor2, X, Y, Width, Height = unpack(Settings)

			Frame:SetUserPlaced(true)
			Frame:ClearAllPoints()
			Frame:SetPoint(Anchor1, UIParent, Anchor2, X, Y)
			Frame:SetSize(Width, Height)

			if (ID ==2) and (C.Chat.RightChatAlignRight) then
				Frame:SetJustifyH("RIGHT")
			end
		end
	end
end

function TukuiChat:Install()
	-- Create our custom chatframes
	FCF_ResetChatWindows()
	FCF_SetLocked(ChatFrame1, 1)
	FCF_DockFrame(ChatFrame2)
	FCF_UnDockFrame(ChatFrame2)
	FCF_OpenNewWindow(GLOBAL_CHANNELS)
	FCF_SetLocked(ChatFrame3, 1)
	FCF_DockFrame(ChatFrame3)
	FCF_OpenNewWindow(self.RightChatName)
	FCF_SetLocked(ChatFrame4, 1)
	FCF_DockFrame(ChatFrame4)
	FCF_SetChatWindowFontSize(nil, ChatFrame1, 12)
	FCF_SetChatWindowFontSize(nil, ChatFrame2, 12)
	FCF_SetChatWindowFontSize(nil, ChatFrame3, 12)
	FCF_SetChatWindowFontSize(nil, ChatFrame4, 12)

	DEFAULT_CHAT_FRAME:SetUserPlaced(true)

	self:SetDefaultChatFramesPositions()
end

function TukuiChat:MoveChannels()
	local IsPublicChannelFound = EnumerateServerChannels()
	
	if not IsPublicChannelFound then
		-- Restart this function until we are able to query public channels
		T.Delay(1, TukuiChat.MoveChannels)
		
		return
	end

	local ChatGroup = {}
	local Channels = {}
	
	for i=1, select("#", EnumerateServerChannels()), 1 do
		Channels[i] = select(i, EnumerateServerChannels())
	end
	
	-- Remove everything in first 4 chat windows
	for i = 1, 4 do
		if i ~= 2 then
			local ChatFrame = _G["ChatFrame"..i]

			ChatFrame_RemoveAllMessageGroups(ChatFrame)
			ChatFrame_RemoveAllChannels(ChatFrame)
		end
	end
	
	-- Join public channels
	for i = 1, #Channels do
		SlashCmdList["JOIN"](Channels[i])
	end

	-----------------------
	-- ChatFrame 1 Setup --
	-----------------------
	
	ChatGroup = {"SAY", "EMOTE", "YELL", "GUILD","OFFICER", "GUILD_ACHIEVEMENT", "WHISPER", "MONSTER_SAY", "MONSTER_EMOTE", "MONSTER_YELL", "MONSTER_WHISPER", "MONSTER_BOSS_EMOTE", "MONSTER_BOSS_WHISPER", "PARTY", "PARTY_LEADER", "RAID", "RAID_LEADER", "RAID_WARNING", "INSTANCE_CHAT", "INSTANCE_CHAT_LEADER", "BG_HORDE", "BG_ALLIANCE", "BG_NEUTRAL", "AFK", "DND", "ACHIEVEMENT", "BN_WHISPER", "BN_CONVERSATION"}
	
	for _, v in ipairs(ChatGroup) do
		ChatFrame_AddMessageGroup(_G.ChatFrame1, v)
	end

	-----------------------
	-- ChatFrame 3 Setup --
	-----------------------

	for i = 1, #Channels do
		ChatFrame_RemoveChannel(ChatFrame1, Channels[i])
		ChatFrame_AddChannel(ChatFrame3, Channels[i])
	end
	
	-- Adjust Chat Colors
	ChangeChatColor("CHANNEL1", 195/255, 230/255, 232/255)
	ChangeChatColor("CHANNEL2", 232/255, 158/255, 121/255)
	ChangeChatColor("CHANNEL3", 232/255, 228/255, 121/255)
	ChangeChatColor("CHANNEL4", 232/255, 228/255, 121/255)
	ChangeChatColor("CHANNEL5", 0/255, 228/255, 121/255)
	ChangeChatColor("CHANNEL6", 0/255, 228/255, 0/255)
	
	-----------------------
	-- ChatFrame 4 Setup --
	-----------------------

	ChatGroup = {"COMBAT_XP_GAIN", "COMBAT_HONOR_GAIN", "COMBAT_FACTION_CHANGE", "LOOT","MONEY", "SYSTEM", "ERRORS", "IGNORED", "SKILL", "CURRENCY"}
	
	for _, v in ipairs(ChatGroup) do
		ChatFrame_AddMessageGroup(_G.ChatFrame4, v)
	end
end

function TukuiChat:OnMouseWheel(delta)
	if (delta < 0) then
		if IsShiftKeyDown() then
			self:ScrollToBottom()
		else
			for i = 1, (C.Chat.ScrollByX or 3) do
				self:ScrollDown()
			end
		end
	elseif (delta > 0) then
		if IsShiftKeyDown() then
			self:ScrollToTop()
		else
			for i = 1, (C.Chat.ScrollByX or 3) do
				self:ScrollUp()
			end
		end
	end
end

function TukuiChat:PlayWhisperSound()
	PlaySoundFile(C.Medias.Whisper)
end

function TukuiChat:SwitchSpokenDialect(button)
	if (IsAltKeyDown() and button == "LeftButton") then
		ToggleFrame(ChatMenu)
	end
end

function TukuiChat:AddMessage(text, ...)
	text = text:gsub("|h%[(%d+)%. .-%]|h", "|h[%1]|h")

	return self.DefaultAddMessage(self, text, ...)
end

function TukuiChat:HideChatFrame(button, id)
	local Panels = T.Panels
	local Background = id == 1 and Panels.LeftChatBG or Panels.RightChatBG
	local DataText = id == 1 and Panels.DataTextLeft or Panels.DataTextRight
	local BG = T.DataTexts.BGFrame

	Background:Hide()

	if C.Misc.ExperienceEnable then
		local XP = T.Miscellaneous.Experience["XPBar"..id]
		local Rep = T.Miscellaneous.Reputation["RepBar"..id]

		XP:SetParent(T.Hider)
		Rep:SetParent(T.Hider)
	end
	
	if BG then
		BG:SetParent(T.Hider)
	end

	DataText:Hide()

	for i = 1, 10 do
		local Chat =  _G["ChatFrame"..i]
		local Tab = _G["ChatFrame"..i.."Tab"]

		if id == 1 and Chat.isDocked then
			Tab:SetParent(T.Hider)
		elseif id == 2 and not Chat.isDocked then
			Tab:SetParent(T.Hider)
		end
	end

	button.state = "hidden"
	button.Texture:SetTexture(C.Medias.ArrowUp)

	local Data = TukuiData[T.MyRealm][T.MyName]

	if id == 1 then
		Data.ChatLeftHidden = true
	elseif id == 2 then
		Data.ChatRightHidden = true
	end
end

function TukuiChat:ShowChatFrame(button, id)
	local Panels = T.Panels
	local Background = id == 1 and Panels.LeftChatBG or Panels.RightChatBG
	local DataText = id == 1 and Panels.DataTextLeft or Panels.DataTextRight
	local BG = T.DataTexts.BGFrame

	Background:Show()

	if C.Misc.ExperienceEnable then
		local XP = T.Miscellaneous.Experience["XPBar"..id]
		local Rep = T.Miscellaneous.Reputation["RepBar"..id]

		XP:SetParent(UIParent)
		Rep:SetParent(UIParent)
		Rep:SetFrameLevel(XP:GetFrameLevel() + 2)
	end
	
	if BG then
		BG:SetParent(UIParent)
	end

	DataText:Show()

	for i = 1, 10 do
		local Chat =  _G["ChatFrame"..i]
		local Tab = _G["ChatFrame"..i.."Tab"]

		if id == 1 and Chat.isDocked then
			Tab:SetParent(UIParent)
		elseif id == 2 and not Chat.isDocked then
			Tab:SetParent(UIParent)
		end
	end

	button.state = "show"
	button.Texture:SetTexture(C.Medias.ArrowDown)

	local Data = TukuiData[T.MyRealm][T.MyName]

	if id == 1 then
		Data.ChatLeftHidden = false
	elseif id == 2 then
		Data.ChatRightHidden = false
	end
end

function TukuiChat:ToggleChat()
	if self.state == "show" then
		TukuiChat:HideChatFrame(self, self.id)
	else
		TukuiChat:ShowChatFrame(self, self.id)
	end
end

function TukuiChat:AddToggles()
	if C.General.Themes.Value ~= "Tukui 18" then
		return
	end

	local Panels = T.Panels

	for i = 1, 2 do
		local Button = CreateFrame("Button", nil, UIParent)

		if i == 1 then
			Button:SetSize(19, Panels.LeftChatBG:GetHeight())
			Button:SetPoint("TOPRIGHT", Panels.LeftChatBG, "TOPLEFT", -6, 0)

			Panels.LeftChatToggle = Button
		else
			Button:SetSize(19, Panels.RightChatBG:GetHeight())
			Button:SetPoint("TOPLEFT", Panels.RightChatBG, "TOPRIGHT", 6, 0)

			Panels.RightChatToggle = Button
		end

		Button:SetTemplate()
		Button:CreateShadow()
		Button:SetAlpha(0)
		Button.Texture = Button:CreateTexture(nil, "OVERLAY", 8)
		Button.Texture:Size(14)
		Button.Texture:Point("CENTER")
		Button.Texture:SetTexture(C.Medias.ArrowDown)
		Button.id = i
		Button.state = "show"

		Button:SetScript("OnClick", self.ToggleChat)
		Button:SetScript("OnEnter", function(self) self:SetAlpha(1) end)
		Button:SetScript("OnLeave", function(self) self:SetAlpha(0) end)
	end
end

function TukuiChat:Setup()
	for i = 1, NUM_CHAT_WINDOWS do
		local Frame = _G["ChatFrame"..i]
		local Tab = _G["ChatFrame"..i.."Tab"]

		Tab.noMouseAlpha = 0
		Tab:SetAlpha(0)
		Tab:HookScript("OnClick", self.SwitchSpokenDialect)

		self:StyleFrame(Frame)

		if i == 2 then
			CombatLogQuickButtonFrame_Custom:StripTextures()
		else
			if C.Chat.ShortChannelName then
				Frame.DefaultAddMessage = Frame.AddMessage
				Frame.AddMessage = TukuiChat.AddMessage
			end
		end
	end

	local CubeLeft = T["Panels"].CubeLeft
	local LeftBG = T["Panels"].LeftChatBG
	local RightBG = T["Panels"].RightChatBG
	local BGR, BGG, BGB = LeftBG.Backdrop:GetBackdropColor()

	LeftBG.Backdrop:SetBackdropColor(BGR, BGG, BGB, C.Chat.BackgroundAlpha / 100)
	RightBG.Backdrop:SetBackdropColor(BGR, BGG, BGB, C.Chat.BackgroundAlpha / 100)

	ChatConfigFrameDefaultButton:Kill()
	ChatFrameMenuButton:Kill()

	ChatMenu:ClearAllPoints()
	ChatMenu:SetPoint("BOTTOMLEFT", T.Panels.LeftChatBG, "TOPLEFT", -1, 16)

	VoiceChatPromptActivateChannel:SetTemplate()
	VoiceChatPromptActivateChannel:CreateShadow()
	VoiceChatPromptActivateChannel.AcceptButton:SkinButton()
	VoiceChatPromptActivateChannel.CloseButton:SkinCloseButton()
	VoiceChatPromptActivateChannel:SetPoint(unpack(TukuiChat.VoiceAlertPosition))
	VoiceChatPromptActivateChannel.ClearAllPoints = Noop
	VoiceChatPromptActivateChannel.SetPoint = Noop

	-- Remember last channel
	ChatTypeInfo.WHISPER.sticky = 1
	ChatTypeInfo.BN_WHISPER.sticky = 1
	ChatTypeInfo.OFFICER.sticky = 1
	ChatTypeInfo.RAID_WARNING.sticky = 1
	ChatTypeInfo.CHANNEL.sticky = 1

	-- Enable nicknames classcolor
	SetCVar("chatClassColorOverride", 0)

	-- Short Channel Names
	if C.Chat.ShortChannelName then
		--guild
		CHAT_GUILD_GET = "|Hchannel:GUILD|hG|h %s "
		CHAT_OFFICER_GET = "|Hchannel:OFFICER|hO|h %s "

		--raid
		CHAT_RAID_GET = "|Hchannel:RAID|hR|h %s "
		CHAT_RAID_WARNING_GET = "RW %s "
		CHAT_RAID_LEADER_GET = "|Hchannel:RAID|hRL|h %s "

		--party
		CHAT_PARTY_GET = "|Hchannel:PARTY|hP|h %s "
		CHAT_PARTY_LEADER_GET ="|Hchannel:PARTY|hPL|h %s "
		CHAT_PARTY_GUIDE_GET ="|Hchannel:PARTY|hPG|h %s "

		--bg
		CHAT_BATTLEGROUND_GET = "|Hchannel:BATTLEGROUND|hB|h %s "
		CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:BATTLEGROUND|hBL|h %s "

		--whisper
		CHAT_WHISPER_INFORM_GET = "to %s "
		CHAT_WHISPER_GET = "from %s "
		CHAT_BN_WHISPER_INFORM_GET = "to %s "
		CHAT_BN_WHISPER_GET = "from %s "

		--say / yell
		CHAT_SAY_GET = "%s "
		CHAT_YELL_GET = "%s "

		--flags
		CHAT_FLAG_AFK = "[AFK] "
		CHAT_FLAG_DND = "[DND] "
		CHAT_FLAG_GM = "[GM] "
	end

	self:AddToggles()

	if C.General.Themes.Value == "Tukui 18" then
		local Data = TukuiData[T.MyRealm][T.MyName]

		if Data.ChatLeftHidden then
			-- Need to delay this one, because of docked tabs
			T.Delay(5, function() TukuiChat.ToggleChat(T.Panels.LeftChatToggle) end)
		end

		if Data.ChatRightHidden then
			TukuiChat.ToggleChat(T.Panels.RightChatToggle)
		end
	end
end

function TukuiChat:AddHooks()
	hooksecurefunc("ChatEdit_UpdateHeader", TukuiChat.UpdateEditBoxColor)
	hooksecurefunc("FCF_OpenTemporaryWindow", TukuiChat.StyleTempFrame)
	hooksecurefunc("FCF_RestorePositionAndDimensions", TukuiChat.SetChatFramePosition)
	hooksecurefunc("FCF_SavePositionAndDimensions", TukuiChat.SaveChatFramePositionAndDimensions)
	hooksecurefunc("FCFTab_UpdateAlpha", TukuiChat.NoMouseAlpha)
end

function TukuiChat:OverwriteFunctions()
	-- Nickname color in chat, because altering RAID_CLASS_COLOR taint, so we overwrite GetColoredName() and use our own table.
	function GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
		local chatType = strsub(event, 10)

		if (strsub(chatType, 1, 7) == "WHISPER") then
			chatType = "WHISPER"
		end

		if (strsub(chatType, 1, 7) == "CHANNEL") then
			chatType = "CHANNEL"..arg8
		end

		local info = ChatTypeInfo[chatType]

		if (chatType == "GUILD") then
			arg2 = Ambiguate(arg2, "guild")
		else
			arg2 = Ambiguate(arg2, "none")
		end

		if (arg12 and info and Chat_ShouldColorChatByClass(info)) then
			local localizedClass, englishClass, localizedRace, englishRace, sex = GetPlayerInfoByGUID(arg12)

			if (englishClass) then
				local R, G, B = unpack(T.Colors.class[englishClass])

				if (not R) then
					return arg2
				end

				return string.format("\124cff%.2x%.2x%.2x", R * 255, G * 255, B * 255)..arg2.."\124r"
			end
		end

		return arg2
	end
end