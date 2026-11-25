--[[
	WindUI — Example 3: Studio Utility & Appearance Toolbox (100% NewForm)
	- LayoutMode = "NewForm" + live Background Image URL switcher + live Glass & Theme controls
	- First-load Welcome Tab (re-playable anytime via Window:ShowWelcome())
	- Showcases Code snippet card, Paragraph actions, side-by-side Group buttons, Prompt modal & Config Profiles
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

local Window = WindUI:CreateWindow({
	Title = "Studio Toolbox",
	Author = "Utility & Appearance • 100% NewForm",
	Icon = "sfsymbols:paintbrushFill",
	Folder = "StudioToolboxHub",
	Style = "MacOS",
	Theme = "MacOS",
	LayoutMode = "NewForm",
	Size = UDim2.fromOffset(600, 390),
	ToggleKey = Enum.KeyCode.RightShift,
	Intro = false,
	NavBar = {
		LiquidOil = true,
		LiquidGlassLens = true,
		GlassTransparency = 0.74,
	},
	Welcome = {
		Enabled = true,
		TabTitle = "Welcome",
		Icon = "sfsymbols:sparkles",
		Greeting = "hello",
		Badge = "STUDIO TOOLBOX • 100% NEWFORM",
		Title = "Studio Toolbox",
		Subtitle = "Live Wallpapers • Profiles • Developer Tools",
		Description = "Customize your window wallpaper in real time, switch between Dark and Light clear glass, test snippets, and manage saved profiles effortlessly.",
		Highlights = {
			{ Icon = "sfsymbols:photo", Text = "Live URL & Asset Background Switcher" },
			{ Icon = "sfsymbols:appleTerminalFill", Text = "Code Snippets, Prompts & Quick Actions" },
			{ Icon = "sfsymbols:folderFill", Text = "One-Tap Config Profile Management" },
		},
		ButtonText = "Open Toolbox",
		HideTopbar = true,
	},
})

-- =========================================================================
-- TAB 1: APPEARANCE & WALLPAPER
-- =========================================================================
local AppearTab = Window:Tab({
	Title = "Appearance",
	Icon = "sfsymbols:paintbrushFill",
})

local BgSec = AppearTab:Section({
	Title = "Background Image & Clear Glass",
	Opened = true,
})

local bgUrlValue = ""
BgSec:Input({
	Title = "Background Image Link",
	Desc = "Paste any https:// PNG/JPG URL or rbxassetid://",
	Placeholder = "https://example.com/wallpaper.png",
	ClearButton = true,
	Callback = function(val)
		bgUrlValue = val
	end,
})

local BgGroup = BgSec:Group()
BgGroup:Button({
	Title = "Apply Wallpaper",
	Variant = "Primary",
	Callback = function()
		if bgUrlValue ~= "" then
			Window:SetBackgroundImage(bgUrlValue, 0.25)
			if Window.WelcomeTab then
				Window.WelcomeTab:SetBackground(bgUrlValue, 0)
			end
			WindUI:Notify({
				Title = "Background Updated",
				Content = "Applied wallpaper to Window & Welcome Tab.",
				Icon = "sfsymbols:photo",
				Duration = 3,
			})
		end
	end,
})
BgGroup:Button({
	Title = "Clear Wallpaper",
	Variant = "Secondary",
	Callback = function()
		Window:SetBackgroundImage("")
		WindUI:Notify({
			Title = "Background Cleared",
			Content = "Restored clean macOS glass backdrop.",
			Icon = "sfsymbols:xmark",
			Duration = 2.5,
		})
	end,
})

BgSec:Slider({
	Title = "Wallpaper Opacity",
	Desc = "Controls background image transparency",
	Step = 5,
	Value = { Min = 0, Max = 100, Default = 75 },
	Callback = function(pct)
		Window:SetBackgroundImageTransparency(1 - (pct / 100))
	end,
})

BgSec:Segmented({
	Title = "Appearance Mode",
	Values = { "Dark", "Light" },
	Value = "Dark",
	Callback = function(mode)
		WindUI:SetTheme(mode == "Light" and "MacOSLight" or "MacOS")
	end,
})

BgSec:Toggle({
	Title = "NavBar Organic Liquid Drift",
	Desc = "Toggle 60 FPS monochrome random-walk glass drift",
	Value = true,
	Callback = function(enabled)
		if Window.NavBar then
			Window.NavBar:SetLiquidOil(enabled)
		end
	end,
})

BgSec:Button({
	Title = "Replay Welcome Screen",
	Desc = "Return to Welcome Tab and replay the iPadOS 'hello' animation",
	Variant = "Secondary",
	Callback = function()
		Window:ShowWelcome()
	end,
})

-- =========================================================================
-- TAB 2: WORKSPACE & TOOLS
-- =========================================================================
local ToolsTab = Window:Tab({
	Title = "Workspace",
	Icon = "sfsymbols:appleTerminalFill",
})

local SnippetSec = ToolsTab:Section({
	Title = "Quick Loadstring & Actions",
	Opened = true,
})

SnippetSec:Code({
	Title = "WindUI Loader",
	Code = 'local WindUI = loadstring(game:HttpGet(\n    "https://raw.githubusercontent.com/darkfantasyisreal/Macos-Windui/refs/heads/main/main.luau"\n))()',
})

local ToolLog = SnippetSec:Console({
	Title = "Toolbox Output",
	Height = 88,
})
ToolLog:Info("Ready. All 100% NewForm modules mounted.")

SnippetSec:Paragraph({
	Title = "Interactive Prompt Modal",
	Desc = "Test native macOS input dialogs directly from any NewForm card.",
	Buttons = {
		{
			Title = "Open Prompt",
			Variant = "Primary",
			Callback = function()
				Window:Prompt({
					Title = "Quick Note",
					Content = "Enter a message to log into the Toolbox console:",
					Placeholder = "Hello from macOS Sequoia...",
					ConfirmText = "Log",
					Callback = function(text)
						ToolLog:Success("Prompt input: " .. tostring(text))
					end,
				})
			end,
		},
	},
})

-- =========================================================================
-- TAB 3: PROFILES
-- =========================================================================
local ProfilesTab = Window:Tab({
	Title = "Profiles",
	Icon = "sfsymbols:folderFill",
})

local ProfileSec = ProfilesTab:Section({
	Title = "Configuration Manager",
	Opened = true,
})

local profileName = "default"
ProfileSec:Input({
	Title = "Profile Name",
	Value = "default",
	Placeholder = "Enter profile name...",
	ClearButton = true,
	Callback = function(v)
		profileName = (v ~= "" and v) or "default"
	end,
})

local ProfileDropdown = ProfileSec:Dropdown({
	Title = "Saved Profiles",
	Values = { "default", "legit", "rage", "afk" },
	Value = "default",
	Callback = function(v)
		profileName = tostring(v)
	end,
})

local ProfActions = ProfileSec:Group()
ProfActions:Button({
	Title = "Save Profile",
	Variant = "Primary",
	Callback = function()
		ToolLog:Success("Saved profile '" .. profileName .. "'")
		WindUI:Notify({
			Title = "Profile Saved",
			Content = "Saved configuration: " .. profileName,
			Icon = "sfsymbols:checkmarkCircleFill",
			Duration = 2.5,
		})
	end,
})
ProfActions:Button({
	Title = "Load Profile",
	Variant = "Secondary",
	Callback = function()
		ToolLog:Info("Loaded profile '" .. profileName .. "'")
		WindUI:Notify({
			Title = "Profile Loaded",
			Content = "Active profile: " .. profileName,
			Icon = "sfsymbols:folderFill",
			Duration = 2.5,
		})
	end,
})

ProfileSec:Button({
	Title = "Delete Selected Profile",
	Variant = "Destructive",
	Confirm = true,
	ConfirmTitle = "Confirm Delete",
	Callback = function()
		ToolLog:Warn("Deleted profile '" .. profileName .. "'")
		ProfileDropdown:Select("default", true)
	end,
})

Window:CreateSettingsTab({
	Title = "Hub Settings",
	Icon = "sfsymbols:gearshapeFill",
})
