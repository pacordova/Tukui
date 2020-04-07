local T, C, L = select(2, ...):unpack()

local TukuiChat = CreateFrame("Frame")

function TukuiChat:Enable()
	if (not C.Chat.Enable) then
		return
	end

	self:Setup()
	self:SkinToastFrame()
	self:EnableURL()
	self:CreateCopyFrame()
	self:CreateCopyButtons()
	self:MoveAudioButtons()
	self:AddHooks()
	self:OverwriteFunctions()

	for i = 1, 10 do
		local ChatFrame = _G["ChatFrame"..i]

		self.SetChatFramePosition(ChatFrame)
		self.SetChatFont(ChatFrame)
	end

	FCF_UpdateButtonSide = function() end

	if C.General.Themes.Value == "Tukui 18" then
		FCF_ToggleLock = self.LockChat
		FCF_ToggleLockOnDockedFrame = self.LockChat
	end

	if (not C.Chat.WhisperSound) then
		return
	end

	local Whisper = CreateFrame("Frame")
	Whisper:RegisterEvent("CHAT_MSG_WHISPER")
	Whisper:RegisterEvent("CHAT_MSG_BN_WHISPER")
	Whisper:SetScript("OnEvent", function(self, event)
		TukuiChat:PlayWhisperSound()
	end)
end

T["Chat"] = TukuiChat
