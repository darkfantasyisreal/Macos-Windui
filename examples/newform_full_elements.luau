--[[
	WindUI — Full Elements & Custom Welcome Tab Showcase (100% NewForm)
	Tests EVERY single WindUI element, layout container, modal, notification style,
	live Background Image API, and heavily customized Apple iPadOS "hello" Welcome Tab!
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

local DEFAULT_WELCOME_BG =
	"https://raw.githubusercontent.com/darkfantasyisreal/Macos-Windui/refs/heads/main/assets/welcome_bg.png"

-- =========================================================================
-- WINDOW WITH 100% NEWFORM + CUSTOM WELCOME TAB + CLEAR MONOCHROME GLASS
-- =========================================================================
local Window = WindUI:CreateWindow({
	Title = "Sequoia Studio",
	SubTitle = "Full Elements Kitchen Sink",
	Author = "100% NewForm • All 22+ Controls • Custom Welcome",
	Icon = "sfsymbols:sparkles",
	Folder = "SequoiaFullTest",
	Style = "MacOS",
	Theme = "MacOS",
	LayoutMode = "NewForm",
	Size = UDim2.fromOffset(620, 410),
	ToggleKey = Enum.KeyCode.RightShift,
	HideSearchBar = false,
	Intro = false,

	-- Global Window Background Image (supports https:// URL or rbxassetid://)
	BackgroundImage = DEFAULT_WELCOME_BG,
	BackgroundImageTransparency = 0.72,

	-- 60 FPS Pure Monochrome Clear Liquid Glass NavBar (0.65 - 0.85 transparency)
	NavBar = {
		LiquidOil = true,
		LiquidGlassLens = true,
		GlassTransparency = 0.72,
		OilIntensity = 1,
	},

	-- Draggable Keybind HUD Overlay
	KeybindMenu = {
		Enabled = true,
		Visible = false,
		Title = "Active Keybinds",
	},

	-- Heavily Customized First-Load Welcome Tab (iPadOS "hello" calligraphy + left Hub intro + hidden Topbar keeping 3 buttons)
	Welcome = {
		Enabled = true,
		TabTitle = "Welcome",
		Icon = "sfsymbols:sparkles",
		Background = DEFAULT_WELCOME_BG,
		BackgroundTransparency = 0,
		Greeting = "hello", -- Genuine 60 FPS iPadOS cursive "hello" stroke-drawing calligraphy!
		GreetingCaption = "Sequoia Studio • Tap to replay",
		DrawDuration = 1.70,
		Badge = "FULL ELEMENTS • 100% NEWFORM",
		Title = "Sequoia Studio Hub",
		Subtitle = "Every Element • Clear Monochrome Liquid Glass",
		Description = "Chào mừng đến với bản test đầy đủ tất cả Element của WindUI macOS Sequoia. Trải nghiệm thanh điều hướng kính trong suốt 60 FPS, hiệu ứng vẽ chữ kiểu iPadOS và toàn bộ control chuẩn macOS.",
		Highlights = {
			{ Icon = "sfsymbols:sliderHorizontal3", Text = "All 22+ Native macOS NewForm Elements" },
			{ Icon = "sfsymbols:sparkles", Text = "60 FPS Clear Liquid Glass & Zero-Jerk Scrub" },
			{ Icon = "sfsymbols:photo", Text = "Live Background Image & Custom Welcome API" },
		},
		ButtonText = "Explore Elements",
		HideTopbar = true, -- Tạm ẩn Topbar khi ở Welcome, vẫn giữ 3 nút Đóng / Thu nhỏ / Phóng to!
		ReplayOnSelect = true,
		OnContinue = function()
			WindUI:Notify({
				Title = "Welcome Complete",
				SubTitle = "Full Elements Mode",
				Content = "Topbar restored! Swipe or tap tabs below to test every element.",
				Icon = "sfsymbols:checkmarkCircleFill",
				Duration = 3.5,
			})
		end,
	},
})

-- Topbar Status Tags (appear automatically after leaving Welcome Tab!)
Window:Tag({
	Title = "NewForm 100%",
	Color = Color3.fromHex("#FFFFFF"),
})
Window:Tag({
	Title = "22+ Elements",
	Color = Color3.fromHex("#30D158"),
})

-- =========================================================================
-- TAB 1: CORE CONTROLS (Button, Toggle, Checkbox, Slider, RangeSlider, Segmented, Keybind)
-- =========================================================================
local ControlsTab = Window:Tab({
	Title = "Controls",
	Icon = "sfsymbols:sliderHorizontal3",
})

local ToggleSec = ControlsTab:Section({
	Title = "Toggles & Checkboxes",
	Desc = "Liquid Glass switches, checkboxes, and floating quick-pin support",
	Opened = true,
})

local MainSwitch = ToggleSec:Toggle({
	Title = "Liquid Glass Switch",
	Desc = "Standard macOS Sequoia animated droplet toggle",
	Flag = "Full_MainSwitch",
	Value = true,
	Callback = function(v)
		print("[FullTest] Switch:", v)
	end,
})

ToggleSec:Toggle({
	Title = "Native macOS Checkbox",
	Desc = "Compact SF Symbol checkmark box variant",
	Type = "Checkbox",
	Flag = "Full_Checkbox",
	Value = true,
	Callback = function(v)
		print("[FullTest] Checkbox:", v)
	end,
})

local pinnedQuickBtn = nil
ToggleSec:Button({
	Title = "Pin / Unpin Floating Switch",
	Desc = "Demonstrates Toggle:PinButton() draggable floating action pill",
	Variant = "Secondary",
	Callback = function()
		if pinnedQuickBtn and pinnedQuickBtn.Destroy then
			pinnedQuickBtn:Destroy()
			pinnedQuickBtn = nil
		elseif MainSwitch.PinButton then
			pinnedQuickBtn = MainSwitch:PinButton({
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
	Title = "Integer Slider (With Desc)",
	Desc = "Drag the Liquid Glass capsule thumb smoothly",
	Step = 1,
	Flag = "Full_IntSlider",
	Value = { Min = 0, Max = 100, Default = 64 },
	Callback = function() end,
})

SliderSec:Slider({
	Title = "Precision Decimal Slider",
	Step = 0.05,
	Flag = "Full_DecSlider",
	Value = { Min = 0, Max = 1, Default = 0.35 },
	Callback = function() end,
})

SliderSec:RangeSlider({
	Title = "Dual-Thumb RangeSlider",
	Desc = "Adjust lower and upper bounds independently",
	Flag = "Full_RangeSlider",
	Value = { Min = 0, Max = 500, Default = { 80, 340 } },
	Callback = function() end,
})

local ModeSegmented = SliderSec:Segmented({
	Title = "Segmented Control (NSSegmentedControl)",
	Values = { "Low", "Medium", "High", "Ultra" },
	Value = "High",
	Flag = "Full_Segmented",
	Callback = function(mode)
		WindUI:Notify({
			Title = "Quality Mode",
			Content = "Switched preset to: " .. tostring(mode),
			Icon = "sfsymbols:sliderHorizontal3",
			Duration = 2,
		})
	end,
})

local ButtonSec = ControlsTab:Section({
	Title = "Button Variants & Keybinds",
	Opened = true,
})

ButtonSec:Button({
	Title = "Primary Action Button",
	Desc = "Standard macOS accent button",
	Variant = "Primary",
	Icon = "sfsymbols:boltFill",
	Callback = function()
		WindUI:Notify({
			Title = "Primary Clicked",
			Content = "Button callback executed cleanly.",
			Icon = "sfsymbols:boltFill",
			Duration = 2.5,
		})
	end,
})

ButtonSec:Button({
	Title = "Secondary Button",
	Variant = "Secondary",
	Callback = function() end,
})

ButtonSec:Button({
	Title = "Tertiary Disclosure Row",
	Desc = "Subtle borderless macOS settings row",
	Variant = "Tertiary",
	Callback = function() end,
})

ButtonSec:Button({
	Title = "White Monochrome Pill",
	Variant = "White",
	Justify = "Center",
	Callback = function() end,
})

ButtonSec:Button({
	Title = "Destructive Confirm Button",
	Desc = "Requires two taps to prevent accidental triggers",
	Variant = "Destructive",
	Confirm = true,
	ConfirmTitle = "Tap again to confirm",
	ConfirmDuration = 3,
	Callback = function()
		WindUI:Notify({
			Title = "Confirmed",
			Content = "Destructive action confirmed.",
			Icon = "sfsymbols:trash",
			Duration = 2.5,
		})
	end,
})

ButtonSec:Keybind({
	Title = "Toggle Switch Hotkey",
	Desc = "Synced automatically with Keybind Menu HUD",
	Value = "G",
	Mode = "Toggle",
	Flag = "Full_KeybindToggle",
	Callback = function()
		MainSwitch:Set(not MainSwitch.Value)
	end,
})

ButtonSec:Keybind({
	Title = "Hold Action Hotkey",
	Value = "LeftAlt",
	Mode = "Hold",
	Flag = "Full_KeybindHold",
	Callback = function() end,
})

-- =========================================================================
-- TAB 2: INPUTS, DROPDOWNS & COLORPICKERS
-- =========================================================================
local InputsTab = Window:Tab({
	Title = "Inputs",
	Icon = "sfsymbols:characterTextbox",
})

local InputSec = InputsTab:Section({
	Title = "Text Fields, Steppers & Textarea",
	Opened = true,
})

InputSec:Input({
	Title = "Standard Input",
	Desc = "Includes live focus ring and quick clear button",
	Placeholder = "Type anything here...",
	Value = "WindUI macOS Sequoia",
	ClearButton = true,
	Flag = "Full_TextInput",
	Callback = function() end,
})

InputSec:Input({
	Title = "Password / Masked Input",
	Placeholder = "Enter secret token...",
	Masked = true,
	ClearButton = true,
	Flag = "Full_Password",
	Callback = function() end,
})

InputSec:Input({
	Title = "Numeric Stepper (NSStepper)",
	Desc = "Increment or decrement with +/- buttons",
	Numeric = true,
	Stepper = true,
	Min = 1,
	Max = 120,
	Step = 5,
	Value = 30,
	Flag = "Full_Stepper",
	Callback = function() end,
})

InputSec:Input({
	Title = "Multi-Line Textarea",
	Type = "Textarea",
	Placeholder = "Write multi-line notes or custom scripts...",
	Value = "Line 1: macOS Sequoia NewForm\nLine 2: Deterministic height (zero overlap!)",
	Flag = "Full_Textarea",
	Callback = function() end,
})

local PickerSec = InputsTab:Section({
	Title = "Dropdowns & NSColorPanel",
	Opened = true,
})

local SingleDrop = PickerSec:Dropdown({
	Title = "Single Select Dropdown",
	Desc = "NSPopUpButton popover with SF Symbol checkmarks",
	Values = { "macOS Sequoia", "iOS 26 Liquid Glass", "iPadOS Hello", "visionOS Clear" },
	Value = "iOS 26 Liquid Glass",
	Flag = "Full_SingleDrop",
	Callback = function() end,
})

PickerSec:Dropdown({
	Title = "Multi-Select Dropdown",
	Desc = "Supports Select All, Clear Selection, and KeepOpen",
	Values = { "Bosses", "Mobs", "Chests", "Players", "Events", "NPCs" },
	Value = { "Bosses", "Chests" },
	Multi = true,
	AllowNone = true,
	KeepOpen = true,
	Flag = "Full_MultiDrop",
	Callback = function() end,
})

PickerSec:Button({
	Title = "Refresh Dropdown & Segmented",
	Desc = "Dynamically updates option lists without recreating elements",
	Variant = "Secondary",
	Callback = function()
		SingleDrop:Refresh({ "Refreshed A", "Refreshed B", "Refreshed C" }, true)
		ModeSegmented:Refresh({ "Eco", "Balanced", "Turbo" }, "Balanced")
		WindUI:Notify({
			Title = "Refreshed",
			Content = "Updated Dropdown & Segmented values live.",
			Icon = "sfsymbols:arrowClockwise",
			Duration = 2.5,
		})
	end,
})

PickerSec:Divider()
PickerSec:Space({ Columns = 1 })

PickerSec:Colorpicker({
	Title = "Accent Colorpicker (With Opacity)",
	Desc = "HSV Map, RGB sliders, Eyedropper & 9 Saved Color slots",
	Default = Color3.fromHex("#0A84FF"),
	Transparency = 0.15,
	Flag = "Full_ColorAccent",
	Callback = function() end,
})

PickerSec:Colorpicker({
	Title = "Solid Colorpicker",
	Default = Color3.fromHex("#30D158"),
	Flag = "Full_ColorSolid",
	Callback = function() end,
})

-- =========================================================================
-- TAB 3: DATA, TELEMETRY, CODE & MEDIA (StatCard, ProgressBar, Console, Paragraph, Code, Image, Viewport)
-- =========================================================================
local MediaTab = Window:Tab({
	Title = "Data & Media",
	Icon = "sfsymbols:chartBarFill",
})

local TelemetrySec = MediaTab:Section({
	Title = "Telemetry & Progress",
	Opened = true,
})

local LiveStatCard = TelemetrySec:StatCard({
	Title = "System Metrics",
	Columns = 2,
	Items = {
		{ Title = "Framerate", Value = "60 FPS", Subtitle = "VSync Locked", Color = "#30D158" },
		{ Title = "Memory", Value = "42.6 MB", Subtitle = "Zero Leaks", Color = "#0A84FF" },
		{ Title = "Ping", Value = "28 ms", Subtitle = "Singapore", Color = "#FF9F0A" },
		{ Title = "Elements", Value = "22 / 22", Subtitle = "All Loaded", Color = "#BF5AF2" },
	},
})

local LiveProgress = TelemetrySec:ProgressBar({
	Title = "Asset Sync Progress",
	Value = { Min = 0, Max = 100, Default = 65 },
})

local ConsoleSec = MediaTab:Section({
	Title = "Live Console & Code Block",
	Opened = true,
})

local MainConsole = ConsoleSec:Console({
	Title = "Runtime Diagnostics",
	Height = 105,
})
MainConsole:Log("WindUI Full Elements Kitchen Sink initialized.")
MainConsole:Info("LayoutMode = NewForm (100% sidebar-less).")
MainConsole:Success("Welcome Tab & 60 FPS Clear Liquid Glass NavBar active.")
MainConsole:Warn("Sample warning log with crisp macOS amber color.")
MainConsole:Error("Sample error log with crisp macOS red color.")

local progVal = 65
local ProgGroup = TelemetrySec:Group()
ProgGroup:Button({
	Title = "+15% Progress",
	Variant = "Primary",
	Callback = function()
		progVal = (progVal + 15) > 100 and 10 or (progVal + 15)
		LiveProgress:Set(progVal)
		LiveStatCard:SetItem(1, { Value = tostring(58 + math.random(0, 4)) .. " FPS" })
		MainConsole:Success("Progress updated -> " .. tostring(progVal) .. "%")
	end,
})
ProgGroup:Button({
	Title = "Add Console Logs",
	Variant = "Secondary",
	Callback = function()
		MainConsole:Info("Ping check at " .. os.date("%H:%M:%S"))
	end,
})

ConsoleSec:Code({
	Title = "Custom Welcome Tab Snippet",
	Code = [[Window = WindUI:CreateWindow({
    Title = "Sequoia Studio",
    LayoutMode = "NewForm",
    Welcome = {
        Greeting = "hello",
        Title = "Sequoia Studio Hub",
        HideTopbar = true,
    },
})]],
})

local RichSec = MediaTab:Section({
	Title = "Paragraph, Image & 3D Viewport",
	Opened = true,
})

RichSec:Paragraph({
	Title = "Rich Paragraph Card",
	Desc = "Displays structured info, icons/URL thumbnails, and inline macOS action buttons cleanly without height clipping.",
	Image = "sfsymbols:sparkles",
	Buttons = {
		{
			Title = "Notify (macOS)",
			Variant = "Primary",
			Callback = function()
				WindUI:Notify({
					Title = "Paragraph Action",
					SubTitle = "macOS Banner",
					Content = "Notification Center banner triggered cleanly.",
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
				WindUI:Notify({
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
	Image = DEFAULT_WELCOME_BG,
	AspectRatio = "16:9",
	Radius = 10,
})

-- 3D Interactive Viewport Preview (rotating neon-free titanium cube)
local demoPart = Instance.new("Part")
demoPart.Size = Vector3.new(2.4, 2.4, 2.4)
demoPart.Color = Color3.fromRGB(220, 224, 232)
demoPart.Material = Enum.Material.SmoothPlastic
demoPart.CFrame = CFrame.Angles(math.rad(24), math.rad(38), 0)

RichSec:Viewport({
	Object = demoPart,
	Interactive = true,
	Height = 140,
})

-- =========================================================================
-- TAB 4: LAYOUTS & MODALS (Group, HStack, VStack, Dialog, Prompt, Popup, FloatingButton, KeySystem, Intro)
-- =========================================================================
local LayoutTab = Window:Tab({
	Title = "Layouts",
	Icon = "sfsymbols:squareGrid2x2",
})

local StackSec = LayoutTab:Section({
	Title = "Group, HStack & VStack Containers",
	Desc = "Deterministic side-by-side and vertical layout containers",
	Opened = true,
})

local DemoGroup = StackSec:Group()
DemoGroup:Button({
	Title = "Group Left",
	Variant = "Primary",
	Callback = function()
		MainConsole:Info("Clicked Group Left")
	end,
})
DemoGroup:Button({
	Title = "Group Right",
	Variant = "Secondary",
	Callback = function()
		MainConsole:Info("Clicked Group Right")
	end,
})

local DemoHStack = LayoutTab:HStack()
local LeftColSec = DemoHStack:Section({
	Title = "HStack Left Card",
	Opened = true,
})
LeftColSec:Toggle({
	Title = "Left Option",
	Value = true,
	Callback = function() end,
})
LeftColSec:Button({
	Title = "Left Action",
	Variant = "Secondary",
	Callback = function() end,
})

local RightColSec = DemoHStack:Section({
	Title = "HStack Right Card",
	Opened = true,
})
RightColSec:Toggle({
	Title = "Right Option A",
	Value = false,
	Callback = function() end,
})
RightColSec:Toggle({
	Title = "Right Option B",
	Type = "Checkbox",
	Value = true,
	Callback = function() end,
})

local DemoVStack = LayoutTab:VStack()
local VStackSec = DemoVStack:Section({
	Title = "VStack Nested Section",
	Opened = true,
})
VStackSec:Paragraph({
	Title = "Inside VStack",
	Desc = "VStack groups sections or rows vertically with consistent gap spacing.",
})

local ModalSec = LayoutTab:Section({
	Title = "Dialogs, Prompts, Popups & Overlays",
	Opened = true,
})

local ModalGroup1 = ModalSec:Group()
ModalGroup1:Button({
	Title = "NSAlert Dialog",
	Variant = "Primary",
	Callback = function()
		Window:Dialog({
			Title = "macOS NSAlert",
			Content = "Native confirmation modal with Primary & Secondary actions.",
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
ModalGroup1:Button({
	Title = "Input Prompt",
	Variant = "Secondary",
	Callback = function()
		Window:Prompt({
			Title = "Rename Hub",
			Content = "Enter a new custom Hub title:",
			Placeholder = "My Sequoia Hub",
			ConfirmText = "Apply",
			Callback = function(txt)
				if txt and txt ~= "" then
					MainConsole:Success("Prompt entered: " .. txt)
				end
			end,
		})
	end,
})

local ModalGroup2 = ModalSec:Group()
ModalGroup2:Button({
	Title = "Standalone Popup",
	Variant = "Secondary",
	Callback = function()
		WindUI:Popup({
			Title = "WindUI Popup",
			Icon = "sfsymbols:bellFill",
			Content = "Standalone modal overlay outside the main window.",
			Buttons = {
				{ Title = "Dismiss", Variant = "Primary", Callback = function() end },
			},
		})
	end,
})
ModalGroup2:Button({
	Title = "Floating Action Pill",
	Variant = "Secondary",
	Callback = function()
		WindUI:CreateFloatingButton({
			Title = "Quick Toggle",
			Icon = "sfsymbols:boltFill",
			InitialState = true,
			Callback = function(state)
				MainConsole:Info("FloatingButton -> " .. tostring(state))
			end,
		})
	end,
})

local ModalGroup3 = ModalSec:Group()
ModalGroup3:Button({
	Title = "Preview KeySystem",
	Variant = "Tertiary",
	Callback = function()
		WindUI:OpenKeySystem({
			Title = "Sequoia Studio",
			Note = "Demo Key: <b>MACOS-2026</b>",
			Key = { "MACOS-2026", "SEQUOIA" },
			Default = "MACOS-2026",
			SaveKey = false,
		}, function(ok)
			MainConsole:Info("KeySystem unlocked: " .. tostring(ok))
		end)
	end,
})
ModalGroup3:Button({
	Title = "Replay Boot Intro",
	Variant = "Tertiary",
	Callback = function()
		WindUI:PlayIntro({
			Title = "Sequoia Studio",
			Subtitle = "Full Elements 100% NewForm",
			Icon = "sfsymbols:sparkles",
		}, false)
	end,
})

-- =========================================================================
-- TAB 5: CUSTOM WELCOME & BACKGROUND PLAYGROUND
-- =========================================================================
local WelcomePlayTab = Window:Tab({
	Title = "Welcome & BG",
	Icon = "sfsymbols:photo",
})

local WelcomeCustomSec = WelcomePlayTab:Section({
	Title = "Live Custom Welcome Tab & Wallpaper Tester",
	Desc = "Test changing Background Image, Theme, Glass, and replaying the iPadOS 'hello' animation",
	Opened = true,
})

local customBgInput = DEFAULT_WELCOME_BG
WelcomeCustomSec:Input({
	Title = "Custom Background URL / rbxassetid",
	Placeholder = "https://...png / .jpg or rbxassetid://...",
	Value = DEFAULT_WELCOME_BG,
	ClearButton = true,
	Callback = function(url)
		customBgInput = url
	end,
})

local BgBtnGroup = WelcomeCustomSec:Group()
BgBtnGroup:Button({
	Title = "Apply to Welcome & Window",
	Variant = "Primary",
	Callback = function()
		Window:SetBackgroundImage(customBgInput, 0.70)
		if Window.WelcomeTab then
			Window.WelcomeTab:SetBackground(customBgInput, 0)
		end
		WindUI:Notify({
			Title = "Wallpaper Applied",
			Content = "Updated both Window & Welcome Background Image.",
			Icon = "sfsymbols:photo",
			Duration = 2.5,
		})
	end,
})
BgBtnGroup:Button({
	Title = "Open & Replay Welcome",
	Variant = "Secondary",
	Callback = function()
		Window:ShowWelcome()
	end,
})

WelcomeCustomSec:Slider({
	Title = "Window Background Transparency",
	Desc = "0.00 = opaque wallpaper, 1.00 = hidden wallpaper",
	Step = 0.05,
	Value = { Min = 0, Max = 1, Default = 0.72 },
	Callback = function(t)
		Window:SetBackgroundImageTransparency(t)
	end,
})

WelcomeCustomSec:Segmented({
	Title = "Live Theme",
	Values = { "Dark", "Light" },
	Value = "Dark",
	Callback = function(m)
		WindUI:SetTheme(m == "Light" and "MacOSLight" or "MacOS")
	end,
})

WelcomeCustomSec:Segmented({
	Title = "Layout Mode",
	Values = { "NewForm", "Classic" },
	Value = "NewForm",
	Callback = function(m)
		Window:SetLayoutMode(m, true)
	end,
})

WelcomeCustomSec:Toggle({
	Title = "NavBar Organic Liquid Drift",
	Value = true,
	Callback = function(state)
		if Window.NavBar then
			Window.NavBar:SetLiquidOil(state)
		end
	end,
})

-- Native Hub Settings Tab (bound automatically to left NavBar Settings gear!)
Window:CreateSettingsTab({
	Title = "Hub Settings",
	Icon = "sfsymbols:gearshapeFill",
})
