--[[
	WindUI — Advanced macOS System Settings + Custom macOS Cursor + Tahoe 26 Liquid Glass Toggle Demo
	- Opens directly into Advanced System Settings with live interactive Display Previews:
	  1. Display Theme Preview Gallery (click miniature macOS desktop cards to live-switch themes)
	  2. Layout, Topbar & 4-Direction Navigate Bar live-morphing Display Stage
	  3. Notification Style (macOS Banner vs Dynamic Island) + 6-Anchor Screen Position Map
	  4. Pointer & Custom Cursor (default retina macOS Arrow + White + Crosshair + Glass Ring + Custom URL/Asset)
	  5. Upgraded macOS Tahoe 26 Liquid Glass Toggle (crystal droplet tap pulse + live drag color bloom)
]]

local loadWindUI
do
	if readfile and isfile then
		for _, fname in ipairs({ "main.luau", "main.lua" }) do
			if isfile(fname) then
				local ok, fn = pcall(function()
					return loadstring(readfile(fname), "@" .. fname)
				end)
				if ok and type(fn) == "function" then
					loadWindUI = fn
					break
				end
			end
		end
	end
	if not loadWindUI then
		local src = game:HttpGet("https://raw.githubusercontent.com/darkfantasyisreal/Macos-Windui/main/main.luau")
		loadWindUI = assert(loadstring(src, "@WindUI_Main"))
	end
end

local WindUI = loadWindUI()

local Window = WindUI:CreateWindow({
	Title = "Sequoia Super Settings",
	Desc = "Advanced System Settings • macOS Cursor • Tahoe 26 Liquid Glass",
	Author = "WindUI macOS",
	Version = "v1.6.66",
	Icon = "sfsymbols:gearshapeFill",
	Folder = "WindUI_SuperSettings",
	Theme = "MacOS",
	LayoutMode = "NewForm",
	ToggleStyle = "LiquidGlass", -- "LiquidGlass" (macOS Tahoe 26) | "Classic" (Sequoia)
	Size = UDim2.fromOffset(600, 405),
	ToggleKey = Enum.KeyCode.RightShift,
	Intro = false,
	Welcome = false,
	NavBar = {
		Position = "Bottom",
		GlassTransparency = 0,
	},
	-- Enable native macOS Arrow cursor by default (auto-pauses on touch / FPS LockCenter!)
	Cursor = {
		Enabled = true,
		Preset = "MacOS", -- "MacOS" | "MacOSWhite" | "Crosshair" | "Ring" | "Custom"
		Size = 24,
		OnlyOverUI = false,
	},
})

-- Tab 1: Playground to feel the upgraded macOS Tahoe 26 Liquid Glass Toggles!
local PlaygroundTab = Window:Tab({
	Title = "Liquid Toggle",
	Icon = "sfsymbols:switch2",
})

local ToggleSec = PlaygroundTab:Section({
	Title = "macOS Tahoe 26 Liquid Glass Switches",
	Desc = "Tap for crystal droplet pulse or drag slowly to see live refraction & track color bloom",
	Opened = true,
})

ToggleSec:Toggle({
	Title = "Liquid Glass Refraction",
	Desc = "Porcelain white at rest -> dissolves to clear crystal droplet in motion",
	Value = true,
	Callback = function() end,
})

ToggleSec:Toggle({
	Title = "Smooth Drag Bloom",
	Desc = "Hold & slide halfway across to watch the green track refract underneath",
	Value = false,
	Callback = function() end,
})

ToggleSec:Toggle({
	Title = "Icon Inside Droplet",
	Desc = "Supports SF Symbol icon centered inside the glass capsule",
	Icon = "sfsymbols:sparkles",
	Value = true,
	Callback = function() end,
})

ToggleSec:Segmented({
	Title = "Switch Toggle Style Live",
	Values = { "LiquidGlass", "Classic" },
	Value = "LiquidGlass",
	Callback = function(style)
		Window:SetToggleStyle(style)
	end,
})

-- Advanced macOS System Settings Tab (opens automatically so you see all live previews immediately!)
local SettingsTab = Window:CreateSettingsTab({
	Title = "Settings",
})
SettingsTab:Select()
