local T, C, L = select(2, ...):unpack()

local DataText = T["DataTexts"]
local GetNetStats = GetNetStats
local GetFramerate = GetFramerate
local format = format
local floor = floor
local select = select
local tslu = 1
local MAINMENUBAR_LATENCY_LABEL = MAINMENUBAR_LATENCY_LABEL

local Update = function(self, t)
	tslu = tslu - t

	if (tslu > 0) then
		return
	end

	local MS = select(3, GetNetStats())
	local Rate = floor(GetFramerate())

	if (MS == 0) then
		MS = "0"
	end

	self.Text:SetFormattedText("%s %s %s %s", DataText.ValueColor .. Rate .. "|r", DataText.NameColor .. L.DataText.FPS .. "|r", DataText.ValueColor .. MS .. "|r", DataText.NameColor .. L.DataText.MS .. "|r")
	tslu = 1
end

local Enable = function(self)
	self:SetScript("OnUpdate", Update)
	self:SetScript("OnLeave", GameTooltip_Hide)
	self:Update(1)
end

local Disable = function(self)
	self.Text:SetText("")
	self:SetScript("OnUpdate", nil)
	self:SetScript("OnLeave", nil)
end

DataText:Register("FPS & MS", Enable, Disable, Update)
