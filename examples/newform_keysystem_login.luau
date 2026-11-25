--[[
	WindUI — Cinematic macOS Sequoia Key System Login + 100% NewForm Showcase
	Full boot choreography:
	  1. Key System Wallpaper Card + 60 FPS iPadOS "hello" + "Hello {PlayerName}" writing intro
	  2. Smooth morph into macOS Sequoia Login User (Avatar, Frosted Key Pill, Get Key + Sign In)
	  3. Unlock animation -> Hub Boot Intro (Icon + Divider + Shimmering Wordmark + Boot Pill)
	  4. 100% NewForm Window landing on Welcome Stage (Welcome hidden from bottom NavBar!)
	Demo Key: MACOS-2026 (or SEQUOIA)
]]

local WindUI
do
	local loadedLocal = false
	if readfile and isfile then
		for _, fname in ipairs({ "main.luau", "main.lua" }) do
			if isfile(fname) then
				local ok, fn = pcall(function()
					return loadstring(readfile(fname))
				end)
				if ok and type(fn) == "function" then
					WindUI = fn()
					loadedLocal = true
					break
				end
			end
		end
	end
	if not loadedLocal then
		WindUI = loadstring(
			game:HttpGet("https://raw.githubusercontent.com/darkfantasyisreal/Macos-Windui/refs/heads/main/main.luau")
		)()
	end
end

WindUI:SetNotificationStyle("MacOS")
WindUI:SetNotificationPosition("TopRight")

local STUDIO_WALLPAPER =
	"https://raw.githubusercontent.com/darkfantasyisreal/Macos-Windui/refs/heads/main/assets/welcome_bg.png"

local Window = WindUI:CreateWindow({
	Title = "Sequoia Login Hub",
	SubTitle = "macOS Sequoia Auth + NewForm",
	Author = "Key System Login • Clear Monochrome Glass",
	Icon = "sfsymbols:sparkles",
	Folder = "SequoiaKeyDemo",
	Style = "MacOS",
	Theme = "MacOS",
	LayoutMode = "NewForm",
	Size = UDim2.fromOffset(600, 395),
	ToggleKey = Enum.KeyCode.RightShift,
	BackgroundImage = STUDIO_WALLPAPER,
	BackgroundImageTransparency = 0.74,

	-- Stage 1: Cinematic macOS Sequoia Lock/Login Key System
	KeySystem = {
		Title = "Sequoia Login Hub",
		IntroSubtitle = "Authenticating macOS Sequoia Workspace",
		Note = "Demo Key: <b>MACOS-2026</b>",
		Background = STUDIO_WALLPAPER,
		URL = "https://github.com/darkfantasyisreal/Macos-Windui",
		Key = { "MACOS-2026", "SEQUOIA" },
		Placeholder = "Enter Key (MACOS-2026)...",
		GetKeyTitle = "Get Key",
		SubmitTitle = "Sign In",
		IntroDuration = 1.95,
		PlayIntroAfterLogin = true, -- Automatically chains into the macOS Hub Boot Intro right after Sign In!
		SaveKey = false,
	},

	-- Stage 2: macOS Hub Boot Intro (automatically plays right after Key System login!)
	Intro = {
		Title = "Sequoia Login Hub",
		Subtitle = "Signed in • Loading 100% NewForm Workspace",
		Icon = "sfsymbols:sparkles",
	},

	-- Stage 3: First-load Welcome stage (hidden cleanly from the bottom NewForm NavBar!)
	Welcome = {
		Enabled = true,
		ShowInNavBar = false, -- Hidden in NewForm NavBar by default!
		Background = STUDIO_WALLPAPER,
		Greeting = "hello",
		GreetingCaption = "Signed in • Tap to replay",
		Badge = "AUTHENTICATED • 100% NEWFORM",
		Title = "Sequoia Login Hub",
		Subtitle = "macOS Sequoia Key System + Clear Liquid Glass",
		Description = "Đăng nhập thành công! Welcome Tab được tự động ẩn khỏi thanh NavBar để chừa chỗ gọn gàng cho các tab chính của Hub.",
		Highlights = {
			{ Icon = "sfsymbols:lockOpenFill", Text = "Verified via macOS Sequoia Login Screen" },
			{ Icon = "sfsymbols:sparkles", Text = "60 FPS Clear Liquid Glass Bottom NavBar" },
			{ Icon = "sfsymbols:sliderHorizontal3", Text = "Welcome Tab Hidden Cleanly in NewForm" },
		},
		ButtonText = "Enter Hub",
		HideTopbar = true,
	},

	NavBar = {
		LiquidOil = true,
		LiquidGlassLens = true,
		GlassTransparency = 0.72,
	},
})

if not Window then
	return
end

local MainTab = Window:Tab({
	Title = "Dashboard",
	Icon = "sfsymbols:sparkles",
})

local MainSec = MainTab:Section({
	Title = "Authenticated Session",
	Desc = "Test replaying the macOS Login KeySystem, Boot Intro, or Welcome screen anytime",
	Opened = true,
})

local ReplayGrp = MainSec:Group()
ReplayGrp:Button({
	Title = "Replay KeySystem + Intro",
	Variant = "Primary",
	Callback = function()
		WindUI:OpenKeySystem({
			Title = "Sequoia Login Hub",
			Note = "Demo Key: <b>MACOS-2026</b>",
			Background = STUDIO_WALLPAPER,
			URL = "https://github.com/darkfantasyisreal/Macos-Windui",
			Key = { "MACOS-2026", "SEQUOIA" },
			Default = "MACOS-2026",
			GetKeyTitle = "Get Key",
			SubmitTitle = "Sign In",
			PlayIntroAfterLogin = true,
			ReplayWelcomeOnLogin = true,
			SaveKey = false,
		})
	end,
})
ReplayGrp:Button({
	Title = "Show Welcome Stage",
	Variant = "Secondary",
	Callback = function()
		Window:ShowWelcome()
	end,
})

local ControlsTab = Window:Tab({
	Title = "Controls",
	Icon = "sfsymbols:sliderHorizontal3",
})

local CtrlSec = ControlsTab:Section({
	Title = "Quick Features",
	Opened = true,
})

CtrlSec:Toggle({
	Title = "Auto Boost Performance",
	Value = true,
	Callback = function(v)
		WindUI:Notify({
			Title = "Performance",
			Content = v and "Enabled" or "Disabled",
			Icon = "sfsymbols:boltFill",
			Duration = 2,
		})
	end,
})

CtrlSec:Slider({
	Title = "WalkSpeed Multiplier",
	Step = 1,
	Value = { Min = 16, Max = 120, Default = 32 },
	Callback = function() end,
})

Window:CreateSettingsTab({
	Title = "Settings",
	Icon = "sfsymbols:gearshapeFill",
})
