--[[
	WindUI — 92 Workspaces Stress & Virtual Desktop Showcase
	- Spawns 92 independent macOS NewForm Hubs simultaneously (18 Themes × 4 NavBar Edges!)
	- Hub #1 opens immediately while Hubs #2..#92 load smoothly in the background (AutoFocus = false, zero flicker)
	- Badge on ⌘ displays "92" · Workspace Switcher streams cards progressively with zero lag
	- Spotlight Search (🔍 / Ctrl+K) searches elements across ALL 92 Hubs in milliseconds!

	Try searching in Spotlight (🔍 / Ctrl+K) or Workspace Switcher (⌘):
	- "92" or "omega"   -> jumps straight to Hub #92 (Omega Citadel #92)
	- "vault" or "69"   -> jumps straight to Hub #69 Secret Vault
	- "hyper" or "42"   -> jumps straight to Hub #42 Hyper Speed
	- "crimson" / "top" -> filters hubs by theme or name
]]

local TOTAL_HUBS = 92

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

local THEMES = {
	"MacOS",
	"MacOSLight",
	"Crimson",
	"Emerald",
	"Midnight",
	"Rose",
	"Indigo",
	"Amber",
	"Violet",
	"Sky",
	"Plant",
	"Red",
	"Dark",
	"Light",
	"Monokai Pro",
	"Cotton Candy",
	"Mellowsi",
	"Rainbow",
}

local EDGES = { "Bottom", "Top", "Left", "Right" }

local ARCHETYPES = {
	{ Prefix = "Sequoia",  Role = "Control",   Icon = "sfsymbols:sparkles",        Tab1 = "Main",     Tab2 = "Tools" },
	{ Prefix = "Daylight", Role = "Studio",    Icon = "sfsymbols:sunMaxFill",      Tab1 = "Studio",   Tab2 = "Palette" },
	{ Prefix = "Obsidian", Role = "Combat",    Icon = "sfsymbols:flameFill",       Tab1 = "Combat",   Tab2 = "Aimbot" },
	{ Prefix = "Emerald",  Role = "Farm",      Icon = "sfsymbols:leafFill",        Tab1 = "AutoFarm", Tab2 = "Quests" },
	{ Prefix = "Midnight", Role = "Visuals",   Icon = "sfsymbols:moonStarsFill",   Tab1 = "ESP",      Tab2 = "Radar" },
	{ Prefix = "Crimson",  Role = "Raid",      Icon = "sfsymbols:boltFill",        Tab1 = "Bosses",   Tab2 = "Drops" },
	{ Prefix = "Indigo",   Role = "DevTools",  Icon = "sfsymbols:terminalFill",    Tab1 = "Console",  Tab2 = "Remotes" },
	{ Prefix = "Amber",    Role = "Market",    Icon = "sfsymbols:tagFill",         Tab1 = "Trading",  Tab2 = "Snipe" },
	{ Prefix = "Violet",   Role = "Macro",     Icon = "sfsymbols:waveform",        Tab1 = "Recorder", Tab2 = "Replay" },
	{ Prefix = "Cobalt",   Role = "Movement",  Icon = "sfsymbols:wind",            Tab1 = "Speed",    Tab2 = "Teleports" },
	{ Prefix = "Aurora",   Role = "Camera",    Icon = "sfsymbols:cameraFill",      Tab1 = "FreeCam",  Tab2 = "FOV" },
	{ Prefix = "Titanium", Role = "Physics",   Icon = "sfsymbols:cubeFill",        Tab1 = "Gravity",  Tab2 = "Hitbox" },
	{ Prefix = "Quartz",   Role = "Inventory", Icon = "sfsymbols:trayFullFill",    Tab1 = "Items",    Tab2 = "AutoSell" },
	{ Prefix = "Nebula",   Role = "Dungeon",   Icon = "sfsymbols:mapFill",         Tab1 = "Waves",    Tab2 = "Pathing" },
	{ Prefix = "Solar",    Role = "Lighting",  Icon = "sfsymbols:lightMax",        Tab1 = "Shaders",  Tab2 = "Atmosphere" },
	{ Prefix = "Pulse",    Role = "Network",   Icon = "sfsymbols:antennaRadiowavesLeftAndRight", Tab1 = "Ping", Tab2 = "Server" },
}

local windows = {}
local tStart = os.clock()

-- =========================================================================
-- HUB #1 — SEQUOIA MASTER CONTROL (Opens immediately on Frame 1!)
-- =========================================================================
local W1 = loadWindUI()
W1:SetNotificationStyle("DynamicIsland")
W1:SetNotificationPosition("TopCenter")

local Win1 = W1:CreateWindow({
	Title = "Sequoia Control #1",
	Desc = "Master Hub • Spawning 92 Simultaneous Workspaces",
	Author = "WindUI 92-Hub Test",
	Version = "v1.6.66",
	Icon = "sfsymbols:sparkles",
	Folder = "WindUI_92Hubs",
	Theme = "MacOS",
	LayoutMode = "NewForm",
	Size = UDim2.fromOffset(600, 392),
	ToggleKey = Enum.KeyCode.RightShift,
	Intro = false,
	Welcome = false,
	NavBar = {
		Position = "Bottom",
		GlassTransparency = 0,
		LiquidOil = true,
		LiquidGlassLens = true,
	},
})
windows[1] = Win1

Win1:Tag({ Title = "92 Workspaces", Color = Color3.fromHex("#0A84FF") })
Win1:Tag({ Title = "0% Idle CPU", Color = Color3.fromHex("#30D158") })

local OverviewTab = Win1:Tab({ Title = "92 Hubs", Icon = "sfsymbols:squareStack3dUp" })
local QuickTab = Win1:Tab({ Title = "Controls", Icon = "sfsymbols:sliderHorizontal3" })
local LogTab = Win1:Tab({ Title = "Logs", Icon = "sfsymbols:terminalFill" })

local StatusSec = OverviewTab:Section({
	Title = "92-Workspace Live Monitor",
	Desc = "Background hubs pause rendering at 0% UI CPU while keeping full state",
	Opened = true,
})

local LiveStats = StatusSec:StatCard({
	Title = "Cluster Status",
	Columns = 2,
	Items = {
		{ Title = "Workspaces", Value = "1 / 92", Subtitle = "Loading...", Color = "#0A84FF" },
		{ Title = "NavBar Edges", Value = "4 Directions", Subtitle = "Bottom/Top/Left/Right", Color = "#30D158" },
		{ Title = "Themes", Value = "18 Themes", Subtitle = "Dark & Light", Color = "#BF5AF2" },
		{ Title = "Boot Time", Value = "...", Subtitle = "Streaming", Color = "#FF9F0A" },
	},
})

local LoadBar = StatusSec:ProgressBar({
	Title = "Workspace Spawn Progress",
	Value = { Min = 0, Max = TOTAL_HUBS, Default = 1 },
})

StatusSec:Segmented({
	Title = "Hub #1 NavBar Edge",
	Values = { "Bottom", "Top", "Left", "Right" },
	Value = "Bottom",
	Callback = function(edge)
		Win1:SetNavBarPosition(edge, true)
	end,
})

local ActionsRow1 = StatusSec:Group()
ActionsRow1:Button({
	Title = "Workspace Switcher (92)",
	Variant = "Primary",
	Icon = "sfsymbols:command",
	Callback = function()
		Win1:ToggleWorkspaceSwitcher()
	end,
})
ActionsRow1:Button({
	Title = "Spotlight Search (Ctrl+K)",
	Variant = "Secondary",
	Icon = "sfsymbols:magnifyingglass",
	Callback = function()
		Win1:OpenSearch()
	end,
})

local JumpSec = OverviewTab:Section({
	Title = "Instant Cross-Workspace Jumps",
	Opened = true,
})

local JumpRow = JumpSec:Group()
JumpRow:Button({
	Title = "Jump -> Hub #42",
	Variant = "Secondary",
	Callback = function()
		if windows[42] and not windows[42].Destroyed then
			Win1:SwitchWorkspace(windows[42].Title)
		end
	end,
})
JumpRow:Button({
	Title = "Jump -> Hub #69",
	Variant = "Secondary",
	Callback = function()
		if windows[69] and not windows[69].Destroyed then
			Win1:SwitchWorkspace(windows[69].Title)
		end
	end,
})
JumpRow:Button({
	Title = "Jump -> Hub #92",
	Variant = "Primary",
	Callback = function()
		if windows[92] and not windows[92].Destroyed then
			Win1:SwitchWorkspace(windows[92].Title)
		end
	end,
})

JumpSec:Button({
	Title = "Destroy All 92 Workspaces",
	Desc = "Tap twice to cleanly unload every single hub",
	Variant = "Destructive",
	Confirm = true,
	ConfirmTitle = "Tap again to destroy all 92 hubs",
	ConfirmDuration = 4,
	Callback = function()
		for i = #windows, 1, -1 do
			local w = windows[i]
			if w and not w.Destroyed and w.Destroy then
				pcall(function()
					w:Destroy()
				end)
			end
		end
	end,
})

-- Tab 2: Quick interactive controls in Hub #1
local CtrlSec = QuickTab:Section({ Title = "Hub #1 Controls", Opened = true })
CtrlSec:Toggle({ Title = "Master Boost #1", Value = true, Callback = function() end })
CtrlSec:Slider({ Title = "Global Speed", Step = 1, Value = { Min = 16, Max = 200, Default = 60 }, Callback = function() end })
CtrlSec:RangeSlider({ Title = "Target Distance", Value = { Min = 0, Max = 500, Default = { 40, 280 } }, Callback = function() end })
CtrlSec:Dropdown({ Title = "Cluster Profile", Values = { "Balanced", "Performance", "Stealth" }, Value = "Performance", Callback = function() end })
CtrlSec:Colorpicker({ Title = "Accent Preview", Default = Color3.fromHex("#0A84FF"), Callback = function() end })

-- Tab 3: Live spawn logs
local LogSec = LogTab:Section({ Title = "Cluster Boot Log", Opened = true })
local BootConsole = LogSec:Console({ Title = "92-Hub Diagnostics", Height = 150 })
BootConsole:Info("Hub #1 ready immediately! Spawning Hubs #2..#92 in background...")

Win1:CreateSettingsTab({ Title = "Settings" })
OverviewTab:Select()

local progressNotif = W1:Notify({
	Title = "Spawning 92 Workspaces",
	Content = "1 / 92 ready (Hub #1 active)...",
	Icon = "sfsymbols:squareStack3dUp",
	Style = "DynamicIsland",
	Duration = 12,
})

-- =========================================================================
-- SPAWN HUBS #2 .. #92 IN SILENT BACKGROUND BATCHES (ZERO FLICKER / ZERO FREEZE)
-- =========================================================================
task.spawn(function()
	for i = 2, TOTAL_HUBS do
		if Win1.Destroyed then
			return
		end

		local theme = THEMES[((i - 1) % #THEMES) + 1]
		local edge = EDGES[((i - 1) % #EDGES) + 1]
		local arch = ARCHETYPES[((i - 1) % #ARCHETYPES) + 1]

		local title = string.format("%s %s #%d", arch.Prefix, arch.Role, i)
		if i == 42 then
			title = "Hyper Nebula #42"
		elseif i == 69 then
			title = "Secret Vault #69"
		elseif i == 92 then
			title = "Omega Citadel #92"
		end

		local W = loadWindUI()
		local Win = W:CreateWindow({
			Title = title,
			Desc = string.format("Workspace #%d / %d • Theme: %s • NavBar: %s", i, TOTAL_HUBS, theme, edge),
			Author = "WindUI 92-Hub Cluster",
			Icon = arch.Icon,
			Folder = "WindUI_92Hubs",
			Theme = theme,
			LayoutMode = "NewForm",
			Size = UDim2.fromOffset(560, 354),
			Intro = false,
			Welcome = false,
			Workspace = {
				AutoFocus = false, -- Keep Hub #1 focused while #2..#92 register silently!
			},
			NavBar = {
				Position = edge,
				GlassTransparency = 0,
			},
		})

		local T1 = Win:Tab({ Title = arch.Tab1, Icon = arch.Icon })
		-- Omit icon on every 4th Left/Right hub's 2nd tab to showcase crisp vertical Monogram fallback!
		local T2 = Win:Tab({
			Title = arch.Tab2,
			Icon = ((edge == "Left" or edge == "Right") and (i % 4 == 0)) and nil or "sfsymbols:sliderHorizontal3",
		})

		local Sec = T1:Section({
			Title = string.format("%s (%s NavBar)", title, edge),
			Opened = true,
		})

		local specialToggleTitle = string.format("Auto %s #%d", arch.Tab1, i)
		if i == 42 then
			specialToggleTitle = "Hub #42 Hyper Speed"
		elseif i == 69 then
			specialToggleTitle = "Hub #69 Secret Vault Key"
		elseif i == 92 then
			specialToggleTitle = "Hub #92 Final Boss ESP"
		end

		Sec:Toggle({
			Title = specialToggleTitle,
			Desc = string.format("Theme: %s • Edge: %s", theme, edge),
			Value = (i % 2 == 1),
			Callback = function() end,
		})

		Sec:Slider({
			Title = string.format("Power #%d", i),
			Step = 1,
			Value = { Min = 1, Max = 100, Default = 10 + (i % 85) },
			Callback = function() end,
		})

		Sec:Segmented({
			Title = "NavBar Edge",
			Values = { "Bottom", "Top", "Left", "Right" },
			Value = edge,
			Callback = function(nextEdge)
				Win:SetNavBarPosition(nextEdge, true)
			end,
		})

		local BackRow = Sec:Group()
		BackRow:Button({
			Title = "Back to Hub #1",
			Variant = "Primary",
			Callback = function()
				Win:SwitchWorkspace("Sequoia Control #1")
			end,
		})
		BackRow:Button({
			Title = "Switcher (92)",
			Variant = "Secondary",
			Callback = function()
				Win:ToggleWorkspaceSwitcher()
			end,
		})

		local SubSec = T2:Section({ Title = arch.Tab2 .. " #" .. i, Opened = true })
		SubSec:Toggle({ Title = "Enable " .. arch.Tab2, Value = true, Callback = function() end })
		SubSec:Button({
			Title = "Destroy Hub #" .. i,
			Variant = "Destructive",
			Callback = function()
				Win:Destroy()
			end,
		})

		T1:Select()
		windows[i] = Win

		-- Yield smoothly every 4 hubs so mobile Roblox stays responsive and updates progress live
		if i % 4 == 0 or i == TOTAL_HUBS then
			LoadBar:Set(i)
			LiveStats:SetItem(1, {
				Value = string.format("%d / %d", i, TOTAL_HUBS),
				Subtitle = (i == TOTAL_HUBS) and "All Active" or "Loading...",
			})
			if progressNotif and progressNotif.SetContent then
				pcall(function()
					progressNotif:SetContent(string.format("%d / %d workspaces ready...", i, TOTAL_HUBS))
					if progressNotif.SetProgress then
						progressNotif:SetProgress(i / TOTAL_HUBS)
					end
				end)
			end
			if i == 24 or i == 48 or i == 72 then
				BootConsole:Info(string.format("Spawned %d / %d hubs (%.2fs)", i, TOTAL_HUBS, os.clock() - tStart))
			end
			task.wait()
		end
	end

	local totalSec = os.clock() - tStart
	LiveStats:SetItem(4, {
		Value = string.format("%.2fs", totalSec),
		Subtitle = "92 Hubs Live",
	})
	BootConsole:Success(string.format("All %d Workspaces ready in %.2fs! Tap ⌘ or Ctrl+K.", TOTAL_HUBS, totalSec))

	W1:Notify({
		Title = "92 Workspaces Ready!",
		Content = string.format("Loaded 92 Hubs in %.2fs • Tap ⌘ to browse or 🔍 to search all 92!", totalSec),
		Icon = "sfsymbols:checkmarkCircleFill",
		Style = "MacOS",
		Duration = 5,
	})
end)
