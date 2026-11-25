--[[
	WindUI — Example 2: Aether RPG Auto-Farm & Telemetry Hub (100% NewForm · Light Clear Glass)
	- LayoutMode = "NewForm" + Theme = "MacOSLight" (crisp frosted clear white glass & ink-dark "hello" calligraphy)
	- First-load Welcome Tab with left-side RPG Hub introduction + hidden Topbar keeping 3 essential buttons
	- Live StatCard telemetry, ProgressBar, Console logs, Multi-Select Dropdown, Numeric Stepper & Dynamic Island alerts
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

WindUI:SetNotificationStyle("DynamicIsland")

local Window = WindUI:CreateWindow({
	Title = "Aether RPG",
	Author = "Light Glass • 100% NewForm",
	Icon = "sfsymbols:boltFill",
	Folder = "AetherRPGHub",
	Style = "MacOS",
	Theme = "MacOSLight",
	LayoutMode = "NewForm",
	Size = UDim2.fromOffset(600, 390),
	ToggleKey = Enum.KeyCode.RightShift,
	Intro = false,
	NavBar = {
		LiquidOil = true,
		LiquidGlassLens = true,
		GlassTransparency = 0.68,
	},
	Welcome = {
		Enabled = true,
		TabTitle = "Welcome",
		Icon = "sfsymbols:sparkles",
		Greeting = "hello",
		Badge = "AETHER RPG • LIGHT GLASS",
		Title = "Aether Auto-Farm",
		Subtitle = "Smart Quests • Boss Hop • Live Telemetry",
		Description = "Clean daylight macOS Sequoia interface designed for long AFK sessions. Monitor XP rates, configure island routines, and receive Discord drop alerts.",
		Highlights = {
			{ Icon = "sfsymbols:chartBarFill", Text = "Real-Time XP & Loot Telemetry" },
			{ Icon = "sfsymbols:boltFill", Text = "Safe Orbit Farming & Boss Rotation" },
			{ Icon = "sfsymbols:bellBadgeFill", Text = "Dynamic Island & Webhook Alerts" },
		},
		ButtonText = "Start Session",
		HideTopbar = true,
	},
})

-- =========================================================================
-- TAB 1: OVERVIEW & TELEMETRY
-- =========================================================================
local OverviewTab = Window:Tab({
	Title = "Overview",
	Icon = "sfsymbols:chartBarFill",
})

local TelemetrySec = OverviewTab:Section({
	Title = "Session Telemetry",
	Opened = true,
})

local Stats = TelemetrySec:StatCard({
	Title = "Live Performance",
	Columns = 2,
	Items = {
		{ Title = "Gold / Hour", Value = "248,500", Subtitle = "+14% vs avg", Color = "#34C759" },
		{ Title = "XP / Minute", Value = "18,400", Subtitle = "2x Boost Active", Color = "#007AFF" },
		{ Title = "Bosses Cleared", Value = "12", Subtitle = "0 deaths", Color = "#AF52DE" },
		{ Title = "Uptime", Value = "01:42:18", Subtitle = "60 FPS stable", Color = "#FF9500" },
	},
})

local LevelBar = TelemetrySec:ProgressBar({
	Title = "Level 2450 Progress",
	Value = { Min = 0, Max = 100, Default = 76 },
})

local FeedSec = OverviewTab:Section({
	Title = "Activity Console",
	Opened = true,
})

local FarmConsole = FeedSec:Console({
	Title = "Routine Log",
	Height = 110,
})
FarmConsole:Success("Aether RPG NewForm engine initialized.")
FarmConsole:Info("Loaded 4 island waypoints and boss timers.")

local clearedCount = 12
local levelPct = 76
TelemetrySec:Button({
	Title = "Simulate Boss Clear",
	Desc = "Updates StatCard, ProgressBar, and Console live",
	Variant = "Primary",
	Callback = function()
		clearedCount += 1
		levelPct = (levelPct + 7) % 100
		Stats:SetItem(3, { Value = tostring(clearedCount), Subtitle = "Just cleared!" })
		LevelBar:Set(levelPct)
		FarmConsole:Success("Defeated Obsidian Guardian (+14,200 XP)")
		WindUI:Notify({
			Title = "Boss Cleared",
			Content = "Obsidian Guardian defeated • Total: " .. tostring(clearedCount),
			Icon = "sfsymbols:boltFill",
			Style = "DynamicIsland",
			Duration = 3,
		})
	end,
})

-- =========================================================================
-- TAB 2: AUTO FARM
-- =========================================================================
local FarmTab = Window:Tab({
	Title = "Auto Farm",
	Icon = "sfsymbols:boltFill",
})

local RoutineSec = FarmTab:Section({
	Title = "Quest & Mob Routine",
	Opened = true,
})

RoutineSec:Toggle({
	Title = "Auto Farm Nearest",
	Desc = "Automatically accepts highest-level quest and clears mobs",
	Flag = "RPG_AutoFarm",
	Value = false,
	Callback = function(v)
		FarmConsole:Info("Auto Farm " .. (v and "started." or "paused."))
	end,
})

RoutineSec:Segmented({
	Title = "Combat Style",
	Values = { "Melee", "Sword", "Fruit", "Gun" },
	Value = "Melee",
	Flag = "RPG_Style",
	Callback = function() end,
})

RoutineSec:Dropdown({
	Title = "Target Island",
	Values = { "Starter Isle", "Sky Citadel", "Obsidian Peak", "Abyssal Core" },
	Value = "Obsidian Peak",
	Flag = "RPG_Island",
	Callback = function(v)
		FarmConsole:Info("Selected island: " .. tostring(v))
	end,
})

RoutineSec:Dropdown({
	Title = "Target Whitelist",
	Values = { "Bosses", "Elite Mobs", "Chests", "Event Spawns" },
	Value = { "Bosses", "Elite Mobs" },
	Multi = true,
	Flag = "RPG_Targets",
	Callback = function() end,
})

RoutineSec:Slider({
	Title = "Tween Flight Speed",
	Step = 10,
	Flag = "RPG_TweenSpeed",
	Value = { Min = 60, Max = 350, Default = 180 },
	Callback = function() end,
})

RoutineSec:RangeSlider({
	Title = "Safe Orbit Altitude",
	Desc = "Hover band above enemies (studs)",
	Flag = "RPG_Orbit",
	Value = { Min = 4, Max = 40, Default = { 10, 18 } },
	Callback = function() end,
})

local ExtrasSec = FarmTab:Section({
	Title = "Bosses & Timing",
	Opened = true,
})

ExtrasSec:Toggle({
	Title = "Auto Boss Server Hop",
	Type = "Checkbox",
	Flag = "RPG_BossHop",
	Value = true,
	Callback = function() end,
})

ExtrasSec:Input({
	Title = "Action Tick Interval (ms)",
	Numeric = true,
	Stepper = true,
	Min = 50,
	Max = 1000,
	Step = 50,
	Value = 150,
	Flag = "RPG_TickMs",
	Callback = function() end,
})

-- =========================================================================
-- TAB 3: WEBHOOK & ALERTS
-- =========================================================================
local WebhookTab = Window:Tab({
	Title = "Webhook",
	Icon = "sfsymbols:bellBadgeFill",
})

local AlertSec = WebhookTab:Section({
	Title = "Discord Notifications",
	Opened = true,
})

AlertSec:Input({
	Title = "Webhook URL",
	Placeholder = "https://discord.com/api/webhooks/...",
	ClearButton = true,
	Flag = "RPG_WebhookUrl",
	Callback = function() end,
})

AlertSec:Toggle({
	Title = "Ping on Mythic Drop",
	Flag = "RPG_PingMythic",
	Value = true,
	Callback = function() end,
})

AlertSec:Button({
	Title = "Send Test Island Alert",
	Variant = "Secondary",
	Callback = function()
		WindUI:Notify({
			Title = "Webhook Ready",
			Content = "Test payload queued successfully.",
			Icon = "sfsymbols:bellBadgeFill",
			Style = "DynamicIsland",
			Duration = 3,
		})
	end,
})

Window:CreateSettingsTab({
	Title = "Hub Settings",
	Icon = "sfsymbols:gearshapeFill",
})
