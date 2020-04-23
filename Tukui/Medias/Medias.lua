local T, C = unpack(select(2, ...))

local Locale = GetLocale()

C["Medias"] = {
	-- Fonts
	--["Font"] = [[Interface\AddOns\Tukui\Medias\Fonts\PtSansNarrow.ttf]],
	--["UnitFrameFont"] = [[Interface\AddOns\Tukui\Medias\Fonts\BigNoodleTitling.ttf]],
	--["PixelFont"] = [=[Interface\AddOns\Tukui\Medias\Fonts\Visitor.ttf]=],
	--["ActionBarFont"] = [[Interface\AddOns\Tukui\Medias\Fonts\Arial.ttf]],
	["Font"] = [[Interface\AddOns\Tukui\Medias\Fonts\fontin.ttf]],
	["UnitFrameFont"] = [[Interface\AddOns\Tukui\Medias\Fonts\BigNoodleTitling.ttf]],
	["PixelFont"] = [[Interface\AddOns\Tukui\Medias\Fonts\iosevka.ttf]],
	["ActionBarFont"] = [[Interface\AddOns\Tukui\Medias\Fonts\iosevka.ttf]],	
	["DamageFont"] = [[Interface\AddOns\Tukui\Medias\Fonts\DieDieDie.ttf]],

	-- Textures
	["Normal"] = [[Interface\AddOns\Tukui\Medias\Textures\Status\Tukui]],
	["Glow"] = [[Interface\AddOns\Tukui\Medias\Textures\Others\Glow]],
	["Bubble"] = [[Interface\AddOns\Tukui\Medias\Textures\Others\Bubble]],
	["Copy"] = [[Interface\AddOns\Tukui\Medias\Textures\Others\Copy]],
	["Blank"] = [[Interface\AddOns\Tukui\Medias\Textures\Others\Blank]],
	["Logo"] = [[Interface\AddOns\Tukui\Medias\Textures\Others\Logo]],
	["Sort"] = [[Interface\AddOns\Tukui\Medias\Textures\Others\Sort]],
	["ArrowUp"] = [[Interface\AddOns\Tukui\Medias\Textures\Others\ArrowUp]],
	["ArrowDown"] = [[Interface\AddOns\Tukui\Medias\Textures\Others\ArrowDown]],

	-- colors
	["BorderColor"] = C.General.BorderColor or { 0, 0, 0 },
	["BackdropColor"] = C.General.BackdropColor or { .1,.1,.1 },

	-- sound
	["Whisper"] = [[Interface\AddOns\Tukui\Medias\Sounds\whisper.mp3]],
	["Warning"] = [[Interface\AddOns\Tukui\Medias\Sounds\warning.mp3]],
}