-- macOS WindUI — 9-Workspace 100% NewForm Virtual Desktop Demo
-- Loads local main.luau if present, otherwise fetches from darkfantasyisreal/Macos-Windui.

local RAW_URL = "https://raw.githubusercontent.com/darkfantasyisreal/Macos-Windui/refs/heads/main/main.luau"

local source
if typeof(isfile) == "function" and typeof(readfile) == "function" and isfile("main.luau") then
	source = readfile("main.luau")
else
	source = game:HttpGet(RAW_URL)
end

local loadWindUI = assert(loadstring(source, "@main.luau"))

local hubs = {
	{ Title = "Sequoia Hub",  Theme = "MacOS",      Icon = "sfsymbols:folderFill",    Tab = "Main",     Sub = "Farm" },
	{ Title = "Daylight UI",  Theme = "MacOSLight", Icon = "sfsymbols:sunMaxFill",    Tab = "Studio",   Sub = "Tools" },
	{ Title = "Crimson PvP",  Theme = "Crimson",    Icon = "sfsymbols:flameFill",     Tab = "Combat",   Sub = "Aimbot" },
	{ Title = "Emerald Farm", Theme = "Emerald",    Icon = "sfsymbols:leafFill",      Tab = "AutoFarm", Sub = "Quests" },
	{ Title = "Midnight ESP", Theme = "Midnight",   Icon = "sfsymbols:moonStarsFill", Tab = "Visuals",  Sub = "Radar" },
	{ Title = "Rose Utility", Theme = "Rose",       Icon = "sfsymbols:heartFill",     Tab = "Utility",  Sub = "Teleports" },
	{ Title = "Indigo Dev",   Theme = "Indigo",     Icon = "sfsymbols:terminalFill",  Tab = "Console",  Sub = "Remote" },
	{ Title = "Amber Trade",  Theme = "Amber",      Icon = "sfsymbols:boltFill",      Tab = "Market",   Sub = "Snipe" },
	{ Title = "Violet Macro", Theme = "Violet",     Icon = "sfsymbols:sparkles",      Tab = "Macros",   Sub = "Replay" },
}

local windows = {}
for i, cfg in ipairs(hubs) do
	local WindUI = loadWindUI()
	local Window = WindUI:CreateWindow({
		Title = cfg.Title,
		Desc = string.format("Workspace #%d • Theme: %s • NewForm", i, cfg.Theme),
		Author = "macOS WindUI NewForm",
		Icon = cfg.Icon,
		Folder = "WindUI_WS_" .. i,
		Theme = cfg.Theme,
		LayoutMode = "NewForm",
		Size = UDim2.fromOffset(550, 344),
		Intro = false,
		Welcome = false,
	})

	local MainTab = Window:Tab({ Title = cfg.Tab, Icon = cfg.Icon })
	local SubTab = Window:Tab({ Title = cfg.Sub, Icon = "sfsymbols:sliderHorizontal3" })
	local SettingsTab = Window:Tab({ Title = "Settings", Icon = "sfsymbols:gearshapeFill" })

	local Sec = MainTab:Section({ Title = cfg.Title .. " Controls", Opened = true })
	Sec:Toggle({
		Title = "Enable " .. cfg.Tab,
		Desc = "State & callbacks stay intact while parked in background",
		Value = (i % 2 == 1),
		Callback = function() end,
	})
	Sec:Slider({
		Title = "Power Level",
		Step = 1,
		Value = { Min = 1, Max = 100, Default = 15 + i * 8 },
		Callback = function() end,
	})
	Sec:Dropdown({
		Title = "Mode",
		Values = { "Fast", "Safe", "Silent" },
		Value = "Fast",
		Callback = function() end,
	})

	local SubSec = SubTab:Section({ Title = cfg.Sub, Opened = true })
	SubSec:Toggle({ Title = "Auto " .. cfg.Sub, Value = true, Callback = function() end })
	SubSec:Button({
		Title = "Open Workspace Switcher",
		Callback = function()
			Window:ToggleWorkspaceSwitcher()
		end,
	})

	local SetSec = SettingsTab:Section({ Title = "Workspace", Opened = true })
	SetSec:Button({
		Title = "Destroy This Hub",
		Variant = "Destructive",
		Callback = function()
			Window:Destroy()
		end,
	})

	MainTab:Select()
	windows[i] = Window
end

-- Switch back to Hub #1 ("Sequoia Hub"); tap ⌘ on the NavBar to switch between all 9 Hubs!
if windows[9] then
	windows[9]:SwitchWorkspace("Sequoia Hub")
end
