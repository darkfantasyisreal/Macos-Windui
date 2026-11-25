--[[
	WindUI — Example 1: Obsidian Combat & Movement Hub (100% NewForm)
	- LayoutMode = "NewForm" (sidebar-less + 60 FPS Clear Monochrome Liquid Glass NavBar)
	- First-load Welcome Tab (60 FPS Apple iPadOS "hello" stroke animation + full-bleed BG + hidden Topbar keeping 3 buttons)
	- Native macOS Sequoia grouped inset sections, Liquid Glass toggles/sliders, Keybind HUD, Pinned Floating Button & Colorpickers
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
	Title = "Obsidian Combat",
	Author = "100% NewForm • Clear Liquid Glass",
	Icon = "sfsymbols:scope",
	Folder = "ObsidianCombatHub",
	Style = "MacOS",
	Theme = "MacOS",
	LayoutMode = "NewForm",
	Size = UDim2.fromOffset(600, 390),
	ToggleKey = Enum.KeyCode.RightShift,
	Intro = false,
	NavBar = {
		LiquidOil = true,
		LiquidGlassLens = true,
		GlassTransparency = 0.72,
		OilIntensity = 1,
	},
	KeybindMenu = {
		Enabled = true,
		Visible = false,
		Title = "Combat Keybinds",
	},
	Welcome = {
		Enabled = true,
		TabTitle = "Welcome",
		Icon = "sfsymbols:sparkles",
		Greeting = "hello",
		Badge = "OBSIDIAN • NEWFORM 100%",
		Title = "Obsidian Combat",
		Subtitle = "Precision Controls • Zero Clutter",
		Description = "Built exclusively for macOS Sequoia NewForm. Enjoy crisp clear-glass navigation, low-latency targeting sliders, and instant keybind management.",
		Highlights = {
			{ Icon = "sfsymbols:scope", Text = "Smooth Legit & Snappy Aim Tuning" },
			{ Icon = "sfsymbols:figureRun", Text = "Responsive Movement & Physics" },
			{ Icon = "sfsymbols:eyeFill", Text = "Clean Monochrome Visual Overlays" },
		},
		ButtonText = "Enter Combat Hub",
		HideTopbar = true,
	},
})

Window:Tag({
	Title = "v1.6",
	Color = Color3.fromHex("#FFFFFF"),
})

-- =========================================================================
-- TAB 1: COMBAT
-- =========================================================================
local CombatTab = Window:Tab({
	Title = "Combat",
	Icon = "sfsymbols:scope",
})

local AimSec = CombatTab:Section({
	Title = "Targeting & Assist",
	Opened = true,
})

local SilentAimToggle = AimSec:Toggle({
	Title = "Silent Aim",
	Desc = "Redirects projectiles smoothly inside the active FOV ring",
	Flag = "Combat_SilentAim",
	Value = false,
	Callback = function(state)
		WindUI:Notify({
			Title = "Silent Aim",
			Content = state and "Enabled" or "Disabled",
			Icon = "sfsymbols:scope",
			Duration = 2.5,
		})
	end,
})

AimSec:Toggle({
	Title = "Visibility & Wall Check",
	Desc = "Ignore targets obstructed behind solid map geometry",
	Flag = "Combat_WallCheck",
	Value = true,
	Callback = function() end,
})

AimSec:Toggle({
	Title = "Team Check",
	Type = "Checkbox",
	Flag = "Combat_TeamCheck",
	Value = true,
	Callback = function() end,
})

AimSec:Segmented({
	Title = "Assist Profile",
	Values = { "Legit", "Smooth", "Snappy" },
	Value = "Smooth",
	Flag = "Combat_Profile",
	Callback = function() end,
})

AimSec:Slider({
	Title = "FOV Radius",
	Desc = "Targeting cone radius in screen pixels",
	Step = 5,
	Flag = "Combat_FOV",
	Value = { Min = 30, Max = 360, Default = 140 },
	Callback = function() end,
})

AimSec:RangeSlider({
	Title = "Engagement Distance",
	Desc = "Minimum and maximum lock-on range (studs)",
	Flag = "Combat_Range",
	Value = { Min = 10, Max = 400, Default = { 20, 220 } },
	Callback = function() end,
})

AimSec:Dropdown({
	Title = "Hitbox Priority",
	Values = { "Head", "UpperTorso", "HumanoidRootPart", "Nearest Bone" },
	Value = "Head",
	Flag = "Combat_Hitbox",
	Callback = function() end,
})

local WeaponSec = CombatTab:Section({
	Title = "Weapon Tuning",
	Opened = true,
})

WeaponSec:Toggle({
	Title = "Recoil Stabilizer",
	Flag = "Combat_NoRecoil",
	Value = true,
	Callback = function() end,
})

WeaponSec:Slider({
	Title = "Smoothing Factor",
	Step = 0.05,
	Flag = "Combat_Smooth",
	Value = { Min = 0.05, Max = 1.0, Default = 0.25 },
	Callback = function() end,
})

WeaponSec:Keybind({
	Title = "Toggle Silent Aim",
	Value = "Q",
	Mode = "Toggle",
	Flag = "Combat_AimKey",
	Callback = function()
		SilentAimToggle:Set(not SilentAimToggle.Value)
	end,
})

-- =========================================================================
-- TAB 2: MOVEMENT
-- =========================================================================
local MovementTab = Window:Tab({
	Title = "Movement",
	Icon = "sfsymbols:figureRun",
})

local PhysicsSec = MovementTab:Section({
	Title = "Character Physics",
	Opened = true,
})

local WalkSpeedSlider = PhysicsSec:Slider({
	Title = "Walk Speed",
	Step = 1,
	Flag = "Move_WalkSpeed",
	Value = { Min = 16, Max = 120, Default = 24 },
	Callback = function(val)
		local lp = game:GetService("Players").LocalPlayer
		local hum = lp and lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = val
		end
	end,
})

local JumpSlider = PhysicsSec:Slider({
	Title = "Jump Power",
	Step = 2,
	Flag = "Move_JumpPower",
	Value = { Min = 50, Max = 180, Default = 50 },
	Callback = function(val)
		local lp = game:GetService("Players").LocalPlayer
		local hum = lp and lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.JumpPower = val
		end
	end,
})

PhysicsSec:Toggle({
	Title = "Infinite Jump",
	Desc = "Allow mid-air jump chaining",
	Flag = "Move_InfJump",
	Value = false,
	Callback = function() end,
})

PhysicsSec:Keybind({
	Title = "Noclip Hotkey",
	Value = "N",
	Mode = "Toggle",
	Flag = "Move_NoclipKey",
	Callback = function() end,
})

PhysicsSec:Button({
	Title = "Reset Movement Defaults",
	Desc = "Restore WalkSpeed (16) and JumpPower (50)",
	Variant = "Destructive",
	Confirm = true,
	ConfirmTitle = "Tap again to reset",
	Callback = function()
		WalkSpeedSlider:Set(16)
		JumpSlider:Set(50)
	end,
})

-- =========================================================================
-- TAB 3: VISUALS
-- =========================================================================
local VisualsTab = Window:Tab({
	Title = "Visuals",
	Icon = "sfsymbols:eyeFill",
})

local EspSec = VisualsTab:Section({
	Title = "Player Overlays",
	Opened = true,
})

EspSec:Toggle({
	Title = "Bounding Box ESP",
	Flag = "Vis_Box",
	Value = true,
	Callback = function() end,
})

EspSec:Toggle({
	Title = "Health & Name Tags",
	Flag = "Vis_Health",
	Value = true,
	Callback = function() end,
})

EspSec:Colorpicker({
	Title = "Enemy Tint",
	Default = Color3.fromHex("#FF453A"),
	Transparency = 0.15,
	Flag = "Vis_EnemyColor",
	Callback = function() end,
})

EspSec:Colorpicker({
	Title = "Teammate Tint",
	Default = Color3.fromHex("#30D158"),
	Transparency = 0.20,
	Flag = "Vis_TeamColor",
	Callback = function() end,
})

EspSec:Slider({
	Title = "Max Render Distance",
	Step = 25,
	Flag = "Vis_MaxDist",
	Value = { Min = 100, Max = 2000, Default = 750 },
	Callback = function() end,
})

-- Native Settings Tab (linked automatically to left NavBar Settings gear!)
Window:CreateSettingsTab({
	Title = "Hub Settings",
	Icon = "sfsymbols:gearshapeFill",
})
