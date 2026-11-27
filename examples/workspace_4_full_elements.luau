--[[
	WindUI — 4 Workspaces + Full Elements & 4-Direction Navigate Bar Test
	- Workspace #1: Sequoia Hub     (Theme: MacOS Dark  • NavBar: Bottom • ALL 22+ Elements)
	- Workspace #2: Daylight Studio (Theme: MacOSLight  • NavBar: Top    • Light Mode + Controls)
	- Workspace #3: Obsidian PvP    (Theme: Crimson     • NavBar: Left   • Vertical Dock + Monogram Tab)
	- Workspace #4: Emerald Farm    (Theme: Emerald     • NavBar: Right  • Vertical Dock + Farm Controls)

	Tips:
	- Bấm nút ⌘ trên Navigate Bar để mở Workspace Switcher (4 Hub + thanh tìm kiếm inline)
	- Bấm nút 🔍 hoặc nhấn Ctrl+K / Cmd+K để mở Spotlight Search tìm Element xuyên suốt cả 4 Workspace
	- Thử gõ "ws", "fov", "emerald", "exposure" trong Spotlight Search để test nhảy xuyên Workspace & tự mở Section đang đóng!
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

local BG_IMAGE = "https://raw.githubusercontent.com/darkfantasyisreal/Macos-Windui/main/assets/welcome_bg.png"

-- =========================================================================
-- WORKSPACE #1 — SEQUOIA HUB (MacOS Dark • NavBar: Bottom • FULL ELEMENTS)
-- =========================================================================
local W1 = loadWindUI()
W1:SetNotificationStyle("MacOS")
W1:SetNotificationPosition("TopRight")

local Win1 = W1:CreateWindow({
	Title = "Sequoia Hub",
	Desc = "Workspace #1 • Full 22+ Elements • NavBar Bottom",
	Author = "WindUI macOS",
	Version = "v1.6.66",
	Icon = "sfsymbols:sparkles",
	Folder = "WindUI_WS4_Sequoia",
	Theme = "MacOS",
	LayoutMode = "NewForm",
	Size = UDim2.fromOffset(600, 396),
	ToggleKey = Enum.KeyCode.RightShift,
	Intro = false,
	Welcome = false,
	NavBar = {
		Position = "Bottom",
		GlassTransparency = 0,
		LiquidOil = true,
		LiquidGlassLens = true,
	},
	KeybindMenu = {
		Enabled = true,
		Visible = false,
		Title = "Active Keybinds",
	},
})

Win1:Tag({ Title = "4 Workspaces", Color = Color3.fromHex("#0A84FF") })
Win1:Tag({ Title = "Full Elements", Color = Color3.fromHex("#30D158") })

-- TAB 1: CONTROLS (Toggle, Checkbox, PinButton, Slider, RangeSlider, Segmented, Button variants, Keybind)
local ControlsTab = Win1:Tab({
	Title = "Controls",
	Icon = "sfsymbols:sliderHorizontal3",
})

local ToggleSec = ControlsTab:Section({
	Title = "Toggles & Checkboxes",
	Desc = "Liquid Glass switches, checkboxes & floating quick-pin",
	Opened = true,
})

local MainSwitch = ToggleSec:Toggle({
	Title = "Liquid Glass Switch",
	Desc = "macOS Sequoia animated toggle switch",
	Flag = "WS4_MainSwitch",
	Value = true,
	Callback = function() end,
})

ToggleSec:Toggle({
	Title = "macOS Checkbox",
	Desc = "Compact SF Symbol checkmark box",
	Type = "Checkbox",
	Flag = "WS4_Checkbox",
	Value = true,
	Callback = function() end,
})

local pinnedBtn = nil
ToggleSec:Button({
	Title = "Pin / Unpin Floating Switch",
	Desc = "Toggle:PinButton() draggable quick action",
	Variant = "Secondary",
	Callback = function()
		if pinnedBtn and pinnedBtn.Destroy then
			pinnedBtn:Destroy()
			pinnedBtn = nil
		elseif MainSwitch.PinButton then
			pinnedBtn = MainSwitch:PinButton({
				Title = "Liquid Switch",
				Icon = "sfsymbols:sparkles",
			})
		end
	end,
})

local SliderSec = ControlsTab:Section({
	Title = "Sliders, Range & Segmented",
	Opened = true,
})

SliderSec:Slider({
	Title = "Integer Slider",
	Desc = "Drag Liquid Glass capsule thumb",
	Step = 1,
	Flag = "WS4_IntSlider",
	Value = { Min = 0, Max = 100, Default = 64 },
	Callback = function() end,
})

SliderSec:Slider({
	Title = "Decimal Slider",
	Step = 0.05,
	Flag = "WS4_DecSlider",
	Value = { Min = 0, Max = 1, Default = 0.35 },
	Callback = function() end,
})

SliderSec:RangeSlider({
	Title = "Dual-Thumb RangeSlider",
	Desc = "Adjust Min & Max independently",
	Flag = "WS4_RangeSlider",
	Value = { Min = 0, Max = 500, Default = { 80, 340 } },
	Callback = function() end,
})

local PresetSeg = SliderSec:Segmented({
	Title = "Quality Preset",
	Values = { "Low", "Medium", "High", "Ultra" },
	Value = "High",
	Flag = "WS4_Preset",
	Callback = function(v)
		W1:Notify({
			Title = "Quality Preset",
			Content = "Switched to " .. tostring(v),
			Icon = "sfsymbols:sliderHorizontal3",
			Duration = 2,
		})
	end,
})

local BtnSec = ControlsTab:Section({
	Title = "Button Variants & Keybinds",
	Opened = true,
})

BtnSec:Button({
	Title = "Primary Action",
	Desc = "Standard macOS accent button",
	Variant = "Primary",
	Icon = "sfsymbols:boltFill",
	Callback = function()
		W1:Notify({
			Title = "Primary Action",
			Content = "Primary button executed.",
			Icon = "sfsymbols:boltFill",
			Duration = 2,
		})
	end,
})

BtnSec:Button({ Title = "Secondary Button", Variant = "Secondary", Callback = function() end })
BtnSec:Button({ Title = "Tertiary Row", Desc = "Borderless macOS row", Variant = "Tertiary", Callback = function() end })
BtnSec:Button({ Title = "White Pill", Variant = "White", Justify = "Center", Callback = function() end })

BtnSec:Button({
	Title = "Destructive Confirm",
	Desc = "Tap twice to confirm",
	Variant = "Destructive",
	Confirm = true,
	ConfirmTitle = "Tap again to confirm",
	ConfirmDuration = 3,
	Callback = function()
		W1:Notify({
			Title = "Confirmed",
			Content = "Destructive action confirmed.",
			Icon = "sfsymbols:trash",
			Duration = 2,
		})
	end,
})

BtnSec:Keybind({
	Title = "Toggle Switch Keybind",
	Desc = "Synced with Keybind Menu HUD",
	Value = "G",
	Mode = "Toggle",
	Flag = "WS4_KbToggle",
	Callback = function()
		MainSwitch:Set(not MainSwitch.Value)
	end,
})

BtnSec:Keybind({
	Title = "Hold Action Keybind",
	Value = "LeftAlt",
	Mode = "Hold",
	Flag = "WS4_KbHold",
	Callback = function() end,
})

-- TAB 2: INPUTS, DROPDOWNS & COLORPICKERS
local InputsTab = Win1:Tab({
	Title = "Inputs",
	Icon = "sfsymbols:characterTextbox",
})

local InputSec = InputsTab:Section({
	Title = "Text Fields, Steppers & Textarea",
	Opened = true,
})

InputSec:Input({
	Title = "Standard Input",
	Desc = "Focus ring + quick clear button",
	Placeholder = "Type something...",
	Value = "WindUI macOS Sequoia",
	ClearButton = true,
	Flag = "WS4_TextInput",
	Callback = function() end,
})

InputSec:Input({
	Title = "Password Input",
	Placeholder = "Enter secret...",
	Masked = true,
	ClearButton = true,
	Flag = "WS4_Password",
	Callback = function() end,
})

InputSec:Input({
	Title = "Numeric Stepper",
	Desc = "Adjust with +/- buttons",
	Numeric = true,
	Stepper = true,
	Min = 1,
	Max = 120,
	Step = 5,
	Value = 30,
	Flag = "WS4_Stepper",
	Callback = function() end,
})

InputSec:Input({
	Title = "Multi-Line Textarea",
	Type = "Textarea",
	Placeholder = "Notes...",
	Value = "Line 1: macOS NewForm\nLine 2: 4-Direction Navigate Bar",
	Flag = "WS4_Textarea",
	Callback = function() end,
})

local PickerSec = InputsTab:Section({
	Title = "Dropdowns & Colorpickers",
	Opened = true,
})

local SingleDrop = PickerSec:Dropdown({
	Title = "Single Select Dropdown",
	Desc = "NSPopUpButton popover with checkmarks",
	Values = { "macOS Sequoia", "Solid Frosted Dock", "4-Direction NavBar", "Spotlight Search" },
	Value = "4-Direction NavBar",
	Flag = "WS4_SingleDrop",
	Callback = function() end,
})

PickerSec:Dropdown({
	Title = "Multi-Select Dropdown",
	Desc = "Select All / Clear / KeepOpen",
	Values = { "Bosses", "Mobs", "Chests", "Players", "Events" },
	Value = { "Bosses", "Chests" },
	Multi = true,
	AllowNone = true,
	KeepOpen = true,
	Flag = "WS4_MultiDrop",
	Callback = function() end,
})

PickerSec:Button({
	Title = "Refresh Dropdown & Segmented",
	Variant = "Secondary",
	Callback = function()
		SingleDrop:Refresh({ "Option A", "Option B", "Option C" }, true)
		PresetSeg:Refresh({ "Eco", "Balanced", "Turbo" }, "Balanced")
	end,
})

PickerSec:Divider()
PickerSec:Space({ Columns = 1 })

PickerSec:Colorpicker({
	Title = "Accent Color (With Opacity)",
	Desc = "HSV Map, RGB sliders, Eyedropper & Saved Colors",
	Default = Color3.fromHex("#0A84FF"),
	Transparency = 0.15,
	Flag = "WS4_ColorAlpha",
	Callback = function() end,
})

PickerSec:Colorpicker({
	Title = "Solid Color",
	Default = Color3.fromHex("#30D158"),
	Flag = "WS4_ColorSolid",
	Callback = function() end,
})

-- TAB 3: DATA, MEDIA & SEARCH-HIDDEN SECTION
local MediaTab = Win1:Tab({
	Title = "Data & Media",
	Icon = "sfsymbols:chartBarFill",
})

local MetricSec = MediaTab:Section({
	Title = "Telemetry & Progress",
	Opened = true,
})

local StatObj = MetricSec:StatCard({
	Title = "Workspace Metrics",
	Columns = 2,
	Items = {
		{ Title = "Workspaces", Value = "4 Active", Subtitle = "4-Edge NavBars", Color = "#0A84FF" },
		{ Title = "Elements", Value = "22 / 22", Subtitle = "All Loaded", Color = "#30D158" },
		{ Title = "Framerate", Value = "60 FPS", Subtitle = "Adaptive 60/20", Color = "#FF9F0A" },
		{ Title = "Search", Value = "Spotlight", Subtitle = "Ctrl+K Ready", Color = "#BF5AF2" },
	},
})

local ProgressObj = MetricSec:ProgressBar({
	Title = "Sync Progress",
	Value = { Min = 0, Max = 100, Default = 65 },
})

local ConsoleSec = MediaTab:Section({
	Title = "Console & Code",
	Opened = true,
})

local MainConsole = ConsoleSec:Console({
	Title = "Live Diagnostics",
	Height = 100,
})
MainConsole:Log("WindUI 4-Workspace Full Elements Test started.")
MainConsole:Info("NavBar supports Bottom, Top, Left, and Right.")
MainConsole:Success("All 4 Workspaces registered cleanly.")
MainConsole:Warn("Try searching 'ws' in Spotlight to auto-open a collapsed section!")
MainConsole:Error("Sample error log styling.")

local progVal = 65
local ProgBtns = MetricSec:Group()
ProgBtns:Button({
	Title = "+15% Progress",
	Variant = "Primary",
	Callback = function()
		progVal = (progVal + 15) > 100 and 10 or (progVal + 15)
		ProgressObj:Set(progVal)
		StatObj:SetItem(3, { Value = tostring(58 + math.random(0, 4)) .. " FPS" })
		MainConsole:Success("Progress -> " .. tostring(progVal) .. "%")
	end,
})
ProgBtns:Button({
	Title = "Log Timestamp",
	Variant = "Secondary",
	Callback = function()
		MainConsole:Info("Tick @ " .. os.date("%H:%M:%S"))
	end,
})

ConsoleSec:Code({
	Title = "4-Direction NavBar Snippet",
	Code = [[Window:SetNavBarPosition("Left", true) -- "Bottom" | "Top" | "Left" | "Right"
Window:OpenSearch()                    -- Spotlight Search (Ctrl+K)
Window:ToggleWorkspaceSwitcher()       -- Switch across 4 Workspaces]],
})

local RichSec = MediaTab:Section({
	Title = "Paragraph, Image & 3D Viewport",
	Opened = true,
})

RichSec:Paragraph({
	Title = "Notification Styles",
	Desc = "Test both macOS Notification Center banners and Dynamic Island pills.",
	Image = "sfsymbols:bellFill",
	Buttons = {
		{
			Title = "macOS Banner",
			Variant = "Primary",
			Callback = function()
				W1:Notify({
					Title = "macOS Sequoia",
					SubTitle = "Notification Center",
					Content = "Crisp top-right glass notification.",
					Icon = "sfsymbols:bellFill",
					Style = "MacOS",
					Duration = 3,
				})
			end,
		},
		{
			Title = "Dynamic Island",
			Variant = "Secondary",
			Callback = function()
				W1:Notify({
					Title = "Dynamic Island",
					Content = "Compact top-center pill notification!",
					Icon = "sfsymbols:sparkles",
					Style = "DynamicIsland",
					Duration = 3,
				})
			end,
		},
	},
})

RichSec:Image({
	Image = BG_IMAGE,
	AspectRatio = "16:9",
	Radius = 10,
})

local demoPart = Instance.new("Part")
demoPart.Size = Vector3.new(2.2, 2.2, 2.2)
demoPart.Color = Color3.fromRGB(215, 220, 232)
demoPart.Material = Enum.Material.SmoothPlastic
demoPart.CFrame = CFrame.Angles(math.rad(22), math.rad(36), 0)

RichSec:Viewport({
	Object = demoPart,
	Interactive = true,
	Height = 130,
})

-- Collapsed Section specifically for testing Spotlight Search ("ws" -> auto-expands & highlights!)
local HiddenSec = MediaTab:Section({
	Title = "Hidden Movement (Collapsed)",
	Desc = "Search 'ws' in Spotlight to jump straight here!",
	Opened = false,
})
HiddenSec:Toggle({
	Title = "Walk Speed Boost",
	Desc = "Inside a collapsed section — Spotlight auto-expands & highlights this row",
	Flag = "WS4_WalkSpeedBoost",
	Value = false,
	Callback = function(v)
		MainConsole:Info("Walk Speed Boost = " .. tostring(v))
	end,
})

-- TAB 4: NAV 4-DIR, LAYOUTS & MODALS (Group, HStack, VStack, Dialog, Prompt, Search, Switcher)
local LayoutTab = Win1:Tab({
	Title = "Layouts",
	Icon = "sfsymbols:squareGrid2x2",
})

local NavCtrlSec = LayoutTab:Section({
	Title = "4-Direction Navigate Bar & Overlays",
	Desc = "Live edge switching, Spotlight Search, and Workspace Switcher",
	Opened = true,
})

NavCtrlSec:Segmented({
	Title = "Navigate Bar Edge",
	Values = { "Bottom", "Top", "Left", "Right" },
	Value = "Bottom",
	Callback = function(edge)
		Win1:SetNavBarPosition(edge, true)
		MainConsole:Success("NavBar moved -> " .. tostring(edge))
	end,
})

local QuickOverlayRow = NavCtrlSec:Group()
QuickOverlayRow:Button({
	Title = "Spotlight Search",
	Variant = "Primary",
	Icon = "sfsymbols:magnifyingglass",
	Callback = function()
		Win1:OpenSearch()
	end,
})
QuickOverlayRow:Button({
	Title = "Workspace Switcher",
	Variant = "Secondary",
	Icon = "sfsymbols:command",
	Callback = function()
		Win1:ToggleWorkspaceSwitcher()
	end,
})

local LayoutRow = NavCtrlSec:Group()
LayoutRow:Button({
	Title = "Toggle Classic / NewForm",
	Variant = "Secondary",
	Callback = function()
		Win1:ToggleNewForm()
	end,
})
LayoutRow:Button({
	Title = "Keybind Menu HUD",
	Variant = "Secondary",
	Callback = function()
		Win1:ToggleKeybindMenu()
	end,
})

local ModalSec = LayoutTab:Section({
	Title = "Dialogs & Prompts",
	Opened = true,
})

local ModalRow = ModalSec:Group()
ModalRow:Button({
	Title = "NSAlert Dialog",
	Variant = "Primary",
	Callback = function()
		Win1:Dialog({
			Title = "macOS NSAlert",
			Content = "Confirmation modal with Primary & Secondary actions.",
			Icon = "sfsymbols:sparkles",
			Buttons = {
				{ Title = "Cancel", Variant = "Secondary", Callback = function() end },
				{
					Title = "Confirm",
					Variant = "Primary",
					Callback = function()
						MainConsole:Success("Dialog confirmed!")
					end,
				},
			},
		})
	end,
})
ModalRow:Button({
	Title = "Input Prompt",
	Variant = "Secondary",
	Callback = function()
		Win1:Prompt({
			Title = "Rename Workspace",
			Content = "Enter a new Hub title:",
			Placeholder = "Sequoia Hub",
			ConfirmText = "Apply",
			Callback = function(txt)
				if txt and txt ~= "" then
					Win1:SetTitle(txt)
				end
			end,
		})
	end,
})

local HStackDemo = LayoutTab:HStack()
local HLeft = HStackDemo:Section({ Title = "HStack Left", Opened = true })
HLeft:Toggle({ Title = "Left Toggle", Value = true, Callback = function() end })
HLeft:Button({ Title = "Left Button", Variant = "Secondary", Callback = function() end })

local HRight = HStackDemo:Section({ Title = "HStack Right", Opened = true })
HRight:Toggle({ Title = "Right Checkbox", Type = "Checkbox", Value = true, Callback = function() end })
HRight:Button({ Title = "Right Button", Variant = "Secondary", Callback = function() end })

local VStackDemo = LayoutTab:VStack()
local VSec = VStackDemo:Section({ Title = "VStack Container", Opened = true })
VSec:Paragraph({
	Title = "Inside VStack",
	Desc = "Stacks sections or elements vertically with consistent spacing.",
})

Win1:CreateSettingsTab({ Title = "Settings" })
ControlsTab:Select()

-- =========================================================================
-- WORKSPACE #2 — DAYLIGHT STUDIO (MacOSLight • NavBar: Top)
-- =========================================================================
local W2 = loadWindUI()
local Win2 = W2:CreateWindow({
	Title = "Daylight Studio",
	Desc = "Workspace #2 • Light Frosted Theme • NavBar Top",
	Author = "WindUI Light",
	Version = "v1.6.66",
	Icon = "sfsymbols:sunMaxFill",
	Folder = "WindUI_WS4_Daylight",
	Theme = "MacOSLight",
	LayoutMode = "NewForm",
	Size = UDim2.fromOffset(570, 368),
	Intro = false,
	Welcome = false,
	NavBar = {
		Position = "Top",
		GlassTransparency = 0,
	},
})

local LightTab1 = Win2:Tab({ Title = "Studio", Icon = "sfsymbols:sunMaxFill" })
local LightTab2 = Win2:Tab({ Title = "Palette", Icon = "sfsymbols:paintbrush" })

local LightSec = LightTab1:Section({ Title = "Daylight Controls (Top NavBar)", Opened = true })
LightSec:StatCard({
	Title = "Light Frosted Status",
	Columns = 2,
	Items = {
		{ Title = "Theme", Value = "MacOSLight", Subtitle = "Porcelain Dock", Color = "#007AFF" },
		{ Title = "Dock Edge", Value = "Top", Subtitle = "Horizontal", Color = "#34C759" },
	},
})
LightSec:Toggle({
	Title = "Daylight Exposure",
	Desc = "Search 'exposure' from any Workspace to jump here!",
	Value = true,
	Callback = function() end,
})
LightSec:Slider({
	Title = "Ambient Brightness",
	Step = 1,
	Value = { Min = 0, Max = 100, Default = 78 },
	Callback = function() end,
})
LightSec:Segmented({
	Title = "Move Top NavBar",
	Values = { "Bottom", "Top", "Left", "Right" },
	Value = "Top",
	Callback = function(edge)
		Win2:SetNavBarPosition(edge, true)
	end,
})

local PalSec = LightTab2:Section({ Title = "Color & Output", Opened = true })
PalSec:Colorpicker({
	Title = "Light Accent",
	Default = Color3.fromHex("#007AFF"),
	Callback = function() end,
})
PalSec:Dropdown({
	Title = "Lighting Preset",
	Values = { "Morning", "Noon", "Studio Soft", "Clear Sky" },
	Value = "Studio Soft",
	Callback = function() end,
})
local LightCon = PalSec:Console({ Title = "Studio Log", Height = 75 })
LightCon:Info("Daylight Studio running on Top Navigate Bar.")

Win2:CreateSettingsTab({ Title = "Settings" })
LightTab1:Select()

-- =========================================================================
-- WORKSPACE #3 — OBSIDIAN PVP (Crimson • NavBar: Left Vertical Icon Dock)
-- =========================================================================
local W3 = loadWindUI()
local Win3 = W3:CreateWindow({
	Title = "Obsidian PvP",
	Desc = "Workspace #3 • Crimson Theme • NavBar Left (Vertical Dock)",
	Author = "WindUI Combat",
	Version = "v1.6.66",
	Icon = "sfsymbols:flameFill",
	Folder = "WindUI_WS4_Obsidian",
	Theme = "Crimson",
	LayoutMode = "NewForm",
	Size = UDim2.fromOffset(570, 368),
	Intro = false,
	Welcome = false,
	NavBar = {
		Position = "Left",
		GlassTransparency = 0,
	},
})

local PvpTab1 = Win3:Tab({ Title = "Combat", Icon = "sfsymbols:flameFill" })
local PvpTab2 = Win3:Tab({ Title = "Visuals", Icon = "sfsymbols:eye" })
-- Icon-less tab to demonstrate crisp "RA" Monogram + SideTabTooltip in Left/Right vertical dock!
local PvpTab3 = Win3:Tab({ Title = "Radar" })

local PvpSec = PvpTab1:Section({ Title = "Combat Suite (Left Vertical Dock)", Opened = true })
PvpSec:Toggle({
	Title = "Silent Aimbot",
	Desc = "Search 'silent' or 'fov' from any Workspace!",
	Value = true,
	Callback = function() end,
})
PvpSec:RangeSlider({
	Title = "Silent Aim FOV",
	Value = { Min = 10, Max = 360, Default = { 45, 160 } },
	Callback = function() end,
})
PvpSec:Keybind({
	Title = "Lock Target Key",
	Value = "Q",
	Mode = "Hold",
	Callback = function() end,
})
PvpSec:Dropdown({
	Title = "Target Hitbox",
	Values = { "Head", "UpperTorso", "HumanoidRootPart", "Closest" },
	Value = "Head",
	Callback = function() end,
})

local VisSec = PvpTab2:Section({ Title = "ESP Overlays", Opened = true })
VisSec:Toggle({ Title = "Box ESP", Value = true, Callback = function() end })
VisSec:Toggle({ Title = "Tracers", Type = "Checkbox", Value = false, Callback = function() end })

local RadarSec = PvpTab3:Section({ Title = "Radar (Monogram Tab)", Opened = true })
RadarSec:Paragraph({
	Title = "Vertical Monogram Fallback",
	Desc = "Tab 'Radar' has no icon, so in Left/Right dock mode it cleanly shows 'RA' with a hover tooltip.",
})
RadarSec:Segmented({
	Title = "Move Left NavBar",
	Values = { "Bottom", "Top", "Left", "Right" },
	Value = "Left",
	Callback = function(edge)
		Win3:SetNavBarPosition(edge, true)
	end,
})

Win3:CreateSettingsTab({ Title = "Settings" })
PvpTab1:Select()

-- =========================================================================
-- WORKSPACE #4 — EMERALD FARM (Emerald • NavBar: Right Vertical Icon Dock)
-- =========================================================================
local W4 = loadWindUI()
local Win4 = W4:CreateWindow({
	Title = "Emerald Farm",
	Desc = "Workspace #4 • Emerald Theme • NavBar Right (Vertical Dock)",
	Author = "WindUI Utility",
	Version = "v1.6.66",
	Icon = "sfsymbols:leafFill",
	Folder = "WindUI_WS4_Emerald",
	Theme = "Emerald",
	LayoutMode = "NewForm",
	Size = UDim2.fromOffset(570, 368),
	Intro = false,
	Welcome = false,
	NavBar = {
		Position = "Right",
		GlassTransparency = 0,
	},
})

local FarmTab1 = Win4:Tab({ Title = "AutoFarm", Icon = "sfsymbols:leafFill" })
local FarmTab2 = Win4:Tab({ Title = "Quests", Icon = "sfsymbols:listBullet" })

local FarmSec = FarmTab1:Section({ Title = "Automation (Right Vertical Dock)", Opened = true })
FarmSec:Toggle({
	Title = "Emerald Auto Collect",
	Desc = "Search 'emerald' from any Workspace to jump here!",
	Value = true,
	Callback = function() end,
})
FarmSec:Input({
	Title = "Farm Radius",
	Numeric = true,
	Stepper = true,
	Min = 10,
	Max = 250,
	Step = 10,
	Value = 80,
	Callback = function() end,
})
FarmSec:ProgressBar({
	Title = "Quest Mastery",
	Value = { Min = 0, Max = 100, Default = 82 },
})
FarmSec:Slider({
	Title = "Tween Speed",
	Step = 5,
	Value = { Min = 50, Max = 350, Default = 180 },
	Callback = function() end,
})
FarmSec:Segmented({
	Title = "Move Right NavBar",
	Values = { "Bottom", "Top", "Left", "Right" },
	Value = "Right",
	Callback = function(edge)
		Win4:SetNavBarPosition(edge, true)
	end,
})

local QuestSec = FarmTab2:Section({ Title = "Quest Helper", Opened = true })
QuestSec:Toggle({ Title = "Auto Claim Rewards", Value = true, Callback = function() end })
QuestSec:Code({
	Title = "Cross-Workspace Switch",
	Code = [[Window:SwitchWorkspace("Sequoia Hub")
Window:ToggleWorkspaceSwitcher()]],
})
QuestSec:Button({
	Title = "Back to Sequoia Hub (#1)",
	Variant = "Primary",
	Callback = function()
		Win4:SwitchWorkspace("Sequoia Hub")
	end,
})

Win4:CreateSettingsTab({ Title = "Settings" })
FarmTab1:Select()

-- Focus Workspace #1 ("Sequoia Hub") by default; tap ⌘ to switch across all 4!
Win4:SwitchWorkspace("Sequoia Hub")

W1:Notify({
	Title = "4 Workspaces Ready",
	SubTitle = "Bottom • Top • Left • Right",
	Content = "Tap ⌘ to switch 4 Hubs or 🔍 / Ctrl+K to search all elements across workspaces.",
	Icon = "sfsymbols:sparkles",
	Duration = 4.5,
})
