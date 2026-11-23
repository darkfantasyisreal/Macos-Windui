local RunService = game:GetService("RunService")
--[[

    WindUI Example (wip)
    
]]

local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local HttpService = cloneref(game:GetService("HttpService"))

local WindUI

do
	local loadedLocal = false
	if readfile and isfile then
		if isfile("main.luau") then
			local ok, fn = pcall(function()
				return loadstring(readfile("main.luau"))
			end)
			if ok and type(fn) == "function" then
				WindUI = fn()
				loadedLocal = true
			end
		elseif isfile("main.lua") then
			local ok, fn = pcall(function()
				return loadstring(readfile("main.lua"))
			end)
			if ok and type(fn) == "function" then
				WindUI = fn()
				loadedLocal = true
			end
		end
	end
	if not loadedLocal then
		WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/darkfantasyisreal/Macos-Windui/refs/heads/main/main.luau"))()
	end
end

--[[

WindUI.Creator.AddIcons("solar", {
    ["CheckSquareBold"] = "rbxassetid://132438947521974",
    ["CursorSquareBold"] = "rbxassetid://120306472146156",
    ["FileTextBold"] = "rbxassetid://89294979831077",
    ["FolderWithFilesBold"] = "rbxassetid://74631950400584",
    ["HamburgerMenuBold"] = "rbxassetid://134384554225463",
    ["Home2Bold"] = "rbxassetid://92190299966310",
    ["InfoSquareBold"] = "rbxassetid://119096461016615",
    ["PasswordMinimalisticInputBold"] = "rbxassetid://109919668957167",
    ["SolarSquareTransferHorizontalBold"] = "rbxassetid://125444491429160",
})--]]

function createPopup()
	return WindUI:Popup({
		Title = "Welcome to the WindUI!",
		Icon = "bird",
		Content = "Hello!",
		Buttons = {
			{
				Title = "Hahaha",
				Icon = "bird",
				Variant = "Tertiary",
			},
			{
				Title = "Hahaha",
				Icon = "bird",
				Variant = "Tertiary",
			},
			{
				Title = "Hahaha",
				Icon = "bird",
				Variant = "Tertiary",
			},
		},
	})
end

-- */  Window  /* --
WindUI:SetNotificationStyle("MacOS")
WindUI:SetNotificationPosition("TopRight")

local Window = WindUI:CreateWindow({
	Title = "WindUI macOS Sequoia",
	SubTitle = "System Settings",
	Author = "macOS UI • Notification Center • Keybind HUD",
	Folder = "ftgshub",
	Icon = "sfsymbols:folderFill",
	Style = "MacOS",
	Theme = "MacOS",
	NewElements = false,
	KeybindMenu = {
		Enabled = true,
		Visible = true,
		ShowOnlyActive = false,
		Title = "Keybinds",
	},
	ToggleKey = Enum.KeyCode.RightShift,

	HideSearchBar = false,

	OpenButton = {
		Title = "WindUI",
		Enabled = true,
		Draggable = true,
		OnlyMobile = false,
		SearchButton = true,
		Scale = 1,
	},
	Topbar = {
		Height = 44,
		ButtonsType = "Mac", -- Default or Mac
	},
	KeySystem = {
		Title = "WindUI",
		Note = "Enter your access key to continue. Demo key: <b>MACOS-2026</b>",
		Key = { "MACOS-2026", "SEQUOIA", "1234" },
		Default = "MACOS-2026",
		URL = "https://discord.gg/ftgs-development-hub-1300692552005189632",
		SaveKey = false,
	},
})

if not Window then
	return
end

--createPopup()

--Window:SetUIScale(.8)

-- */  Tags  /* --
do
	Window:Tag({
		Title = "v" .. WindUI.Version,
		Icon = "github",
		Color = Color3.fromHex("#1c1c1c"),
		Border = true,
	})
end

-- */  Colors  /* --
local Purple = Color3.fromHex("#7775F2")
local Yellow = Color3.fromHex("#ECA201")
local Green = Color3.fromHex("#10C550")
local Grey = Color3.fromHex("#83889E")
local Blue = Color3.fromHex("#257AF7")
local Red = Color3.fromHex("#EF4F1D")

-- */ Other Functions /* --
local function parseJSON(luau_table, indent, level, visited)
	indent = indent or 2
	level = level or 0
	visited = visited or {}

	local currentIndent = string.rep(" ", level * indent)
	local nextIndent = string.rep(" ", (level + 1) * indent)

	if luau_table == nil then
		return "null"
	end

	local dataType = type(luau_table)

	if dataType == "table" then
		if visited[luau_table] then
			return '"[Circular Reference]"'
		end

		visited[luau_table] = true

		local isArray = true
		local maxIndex = 0

		for k, _ in pairs(luau_table) do
			if type(k) == "number" and k > maxIndex then
				maxIndex = k
			end
			if type(k) ~= "number" or k <= 0 or math.floor(k) ~= k then
				isArray = false
				break
			end
		end

		local count = 0
		for _ in pairs(luau_table) do
			count = count + 1
		end
		if count ~= maxIndex and isArray then
			isArray = false
		end

		if count == 0 then
			return "{}"
		end

		if isArray then
			if count == 0 then
				return "[]"
			end

			local result = "[\n"

			for i = 1, maxIndex do
				result = result .. nextIndent .. parseJSON(luau_table[i], indent, level + 1, visited)
				if i < maxIndex then
					result = result .. ","
				end
				result = result .. "\n"
			end

			result = result .. currentIndent .. "]"
			return result
		else
			local result = "{\n"
			local first = true

			local keys = {}
			for k in pairs(luau_table) do
				table.insert(keys, k)
			end
			table.sort(keys, function(a, b)
				if type(a) == type(b) then
					return tostring(a) < tostring(b)
				else
					return type(a) < type(b)
				end
			end)

			for _, k in ipairs(keys) do
				local v = luau_table[k]
				if not first then
					result = result .. ",\n"
				else
					first = false
				end

				if type(k) == "string" then
					result = result .. nextIndent .. '"' .. k .. '": '
				else
					result = result .. nextIndent .. '"' .. tostring(k) .. '": '
				end

				result = result .. parseJSON(v, indent, level + 1, visited)
			end

			result = result .. "\n" .. currentIndent .. "}"
			return result
		end
	elseif dataType == "string" then
		local escaped = luau_table:gsub("\\", "\\\\")
		escaped = escaped:gsub('"', '\\"')
		escaped = escaped:gsub("\n", "\\n")
		escaped = escaped:gsub("\r", "\\r")
		escaped = escaped:gsub("\t", "\\t")

		return '"' .. escaped .. '"'
	elseif dataType == "number" then
		return tostring(luau_table)
	elseif dataType == "boolean" then
		return luau_table and "true" or "false"
	elseif dataType == "function" then
		return '"function"'
	else
		return '"' .. dataType .. '"'
	end
end

local function tableToClipboard(luau_table, indent)
	indent = indent or 4
	local jsonString = parseJSON(luau_table, indent)
	setclipboard(jsonString)
	return jsonString
end

-- */  About Tab  /* --
do
	local AboutTab = Window:Tab({
		Title = "About WindUI",
		Desc = "Description Example",
		Icon = "solar:info-square-bold",
		IconColor = Grey,
		IconShape = "Square",
		Border = true,
	})

	local AboutSection = AboutTab:Section({
		Title = "About WindUI",
	})

	AboutSection:Image({
		Image = "https://repository-images.githubusercontent.com/880118829/22c020eb-d1b1-4b34-ac4d-e33fd88db38d",
		AspectRatio = "16:9",
		Radius = 9,
	})

	AboutSection:Space({ Columns = 3 })

	AboutSection:Section({
		Title = "What is WindUI?",
		TextSize = 24,
		FontWeight = Enum.FontWeight.SemiBold,
	})

	AboutSection:Space()

	AboutSection:Section({
		Title = "WindUI is a stylish, open-source UI (User Interface) library specifically designed for Roblox Script Hubs.\nDeveloped by Footagesus (.ftgs, Footages).\nIt aims to provide developers with a modern, customizable, and easy-to-use toolkit for creating visually appealing interfaces within Roblox.\nThe project is primarily written in Lua (Luau), the scripting language used in Roblox.",
		TextSize = 18,
		TextTransparency = 0.35,
		FontWeight = Enum.FontWeight.Medium,
	})

	AboutTab:Space({ Columns = 4 })

	-- Default buttons

	AboutTab:Button({
		Title = "Export WindUI JSON (copy)",
		Color = Color3.fromHex("#a2ff30"),
		Justify = "Center",
		IconAlign = "Left",
		Icon = "", -- removing icon
		Callback = function()
			tableToClipboard(WindUI)
			WindUI:Notify({
				Title = "WindUI JSON",
				Content = "Copied to Clipboard!",
			})
		end,
	})
	AboutTab:Space({ Columns = 1 })

	AboutTab:Button({
		Title = "Destroy Window",
		Color = Color3.fromHex("#ff4830"),
		Justify = "Center",
		Icon = "shredder",
		IconAlign = "Left",
		Callback = function()
			Window:Destroy()
		end,
	})
end

-- */  Elements Section  /* --
local ElementsSection = Window:Section({
	Title = "Elements",
})
local ConfigUsageSection = Window:Section({
	Title = "Config Usage",
})
local OtherSection = Window:Section({
	Title = "Other",
})

-- */  Overview Tab  /* --
do
	local OverviewTab = ElementsSection:Tab({
		Title = "Overview",
		Icon = "solar:home-2-bold",
		IconColor = Grey,
		IconShape = "Square",
		Border = true,
	})

	local OverviewSection1 = OverviewTab:Section({
		Title = "Group's Example",
	})

	local OverviewGroup1 = OverviewTab:Group({})

	OverviewGroup1:Button({
		Title = "Button 1",
		Justify = "Center",
		Icon = "",
		Callback = function()
			print("clicked button 1")
		end,
	})
	OverviewGroup1:Space()
	OverviewGroup1:Button({
		Title = "Button 2",
		Justify = "Center",
		Icon = "",
		Callback = function()
			print("clicked button 2")
		end,
	})

	OverviewTab:Space()

	local OverviewGroup2 = OverviewTab:Group({})

	OverviewGroup2:Button({
		Title = "Button 1",
		Justify = "Center",
		Icon = "",
		Callback = function()
			print("clicked button 1")
		end,
	})
	OverviewGroup2:Space()
	OverviewGroup2:Toggle({
		Title = "Toggle 2",
		Callback = function(v)
			print("clicked toggle 2:", v)
		end,
	})
	OverviewGroup2:Space()
	OverviewGroup2:Colorpicker({
		Title = "Colorpicker 3",
		Default = Color3.fromHex("#30ff6a"),
		Callback = function(color)
			print(color)
		end,
	})

	OverviewTab:Space()

	local OverviewGroup3 = OverviewTab:Group({})

	local OverviewSection1 = OverviewGroup3:Section({
		Title = "Section 1",
		Desc = "Section exampleee",
		Box = true,
		BoxBorder = true,
		Opened = true,
	})
	OverviewSection1:Button({
		Title = "Button 1",
		Justify = "Center",
		Icon = "",
		Callback = function()
			print("clicked button 1")
		end,
	})
	OverviewSection1:Space()
	OverviewSection1:Toggle({
		Title = "Toggle 2",
		Callback = function(v)
			print("clicked toggle 2:", v)
		end,
	})

	OverviewGroup3:Space()

	local OverviewSection2 = OverviewGroup3:Section({
		Title = "Section 2",
		Box = true,
		BoxBorder = true,
		Opened = true,
	})
	OverviewSection2:Button({
		Title = "Button 1",
		Justify = "Center",
		Icon = "",
		Callback = function()
			print("clicked button 1")
		end,
	})
	OverviewSection2:Space()
	OverviewSection2:Button({
		Title = "Button 2",
		Justify = "Center",
		Icon = "",
		Callback = function()
			print("clicked button 2")
		end,
	})

	--OverviewTab:Space()
end

-- */  Toggle Tab  /* --
do
	local ToggleTab = ElementsSection:Tab({
		Title = "Toggle",
		Icon = "solar:check-square-bold",
		IconColor = Green,
		IconShape = "Square",
		Border = true,
	})

	ToggleTab:Toggle({
		Title = "Toggle",
	})

	ToggleTab:Space()

	ToggleTab:Toggle({
		Title = "Toggle",
		Desc = "Toggle example",
	})

	ToggleTab:Space()

	local ToggleGroup1 = ToggleTab:Group()
	ToggleGroup1:Toggle({})
	ToggleGroup1:Space()
	ToggleGroup1:Toggle({})

	ToggleTab:Space()

	ToggleTab:Toggle({
		Title = "Checkbox",
		Type = "Checkbox",
	})

	ToggleTab:Space()

	ToggleTab:Toggle({
		Title = "Checkbox",
		Desc = "Checkbox example",
		Type = "Checkbox",
	})

	ToggleTab:Space()

	ToggleTab:Toggle({
		Title = "Toggle",
		Locked = true,
		LockedTitle = "This element is locked",
	})

	ToggleTab:Toggle({
		Title = "Toggle",
		Desc = "Toggle example",
		Locked = true,
		LockedTitle = "This element is locked",
	})
end

-- */  Button Tab  /* --
do
	local ButtonTab = ElementsSection:Tab({
		Title = "Button",
		Icon = "solar:cursor-square-bold",
		IconColor = Blue,
		IconShape = "Square",
		Border = true,
	})

	local HighlightButton
	HighlightButton = ButtonTab:Button({
		Title = "Highlight Button",
		Icon = "mouse",
		Callback = function()
			print("clicked highlight")
			HighlightButton:Highlight()
		end,
	})

	ButtonTab:Space()

	ButtonTab:Button({
		Title = "Blue Button",
		Color = Color3.fromHex("#305dff"),
		Icon = "",
		Callback = function() end,
	})

	ButtonTab:Space()

	ButtonTab:Button({
		Title = "Blue Button",
		Desc = "With description",
		Color = Color3.fromHex("#305dff"),
		Icon = "",
		Callback = function() end,
	})

	ButtonTab:Space()

	ButtonTab:Button({
		Title = "Notify Button",
		--Desc = "Button example",
		Callback = function()
			WindUI:Notify({
				Title = "Hello",
				Content = "Welcome to the WindUI Example!",
				Icon = "solar:bell-bold",
				Duration = 5,
				CanClose = false,
			})
		end,
	})

	ButtonTab:Button({
		Title = "Notify Button 2",
		--Desc = "Button example",
		Callback = function()
			WindUI:Notify({
				Title = "Hello",
				Content = "Welcome to the WindUI Example!",
				--Icon = "solar:bell-bold",
				Duration = 5,
				CanClose = false,
			})
		end,
	})

	ButtonTab:Space()

	ButtonTab:Button({
		Title = "Button",
		Locked = true,
		LockedTitle = "This element is locked",
	})

	ButtonTab:Button({
		Title = "Button",
		Desc = "Button example",
		Locked = true,
		LockedTitle = "This element is locked",
	})
end

-- */  Input Tab  /* --
do
	local InputTab = ElementsSection:Tab({
		Title = "Input",
		Icon = "solar:password-minimalistic-input-bold",
		IconColor = Purple,
		IconShape = "Square",
		Border = true,
	})

	InputTab:Input({
		Title = "Input",
		Icon = "mouse",
	})

	InputTab:Space()

	InputTab:Input({
		Title = "Input Textarea",
		Type = "Textarea",
		Icon = "mouse",
	})

	InputTab:Space()

	InputTab:Input({
		Title = "Input Textarea",
		Type = "Textarea",
		--Icon = "mouse",
	})

	InputTab:Space()

	InputTab:Input({
		Title = "Input",
		Desc = "Input example",
	})

	InputTab:Space()

	InputTab:Input({
		Title = "Input Textarea",
		Desc = "Input example",
		Type = "Textarea",
	})

	InputTab:Space()

	InputTab:Input({
		Title = "Input",
		Locked = true,
		LockedTitle = "This element is locked",
	})

	InputTab:Input({
		Title = "Input",
		Desc = "Input example",
		Locked = true,
		LockedTitle = "This element is locked",
	})
end

-- */  Slider Tab  /* --
do
	local SliderTab = ElementsSection:Tab({
		Title = "Slider",
		Icon = "solar:square-transfer-horizontal-bold",
		IconColor = Green,
		IconShape = "Square",
		Border = true,
	})

	SliderTab:Section({
		Title = "Default Slider with Tooltip and without textbox",
		TextSize = 14,
	})

	SliderTab:Slider({
		Title = "Slider Example",
		Desc = "Hahahahaha hello",
		IsTooltip = true,
		IsTextbox = false,
		Width = 200,
		Step = 1,
		Value = {
			Min = 0,
			Max = 200,
			Default = 100,
		},
		Callback = function(value)
			print(value)
		end,
	})

	SliderTab:Space()

	SliderTab:Section({
		Title = "Slider without description",
		TextSize = 14,
	})

	SliderTab:Slider({
		Title = "Slider Example",
		Step = 1,
		Width = 200,
		Value = {
			Min = 0,
			Max = 200,
			Default = 100,
		},
		Callback = function(value)
			print(value)
		end,
	})

	SliderTab:Space()

	SliderTab:Section({
		Title = "Slider without titles",
		TextSize = 14,
	})

	SliderTab:Slider({
		IsTooltip = true,
		Step = 1,
		Value = {
			Min = 0,
			Max = 200,
			Default = 100,
		},
		Callback = function(value)
			print(value)
		end,
	})

	SliderTab:Space()

	SliderTab:Section({
		Title = "Slider with icons ('from' only)",
		TextSize = 14,
	})

	SliderTab:Slider({
		IsTooltip = true,
		Step = 1,
		Value = {
			Min = 0,
			Max = 200,
			Default = 100,
		},
		Icons = {
			From = "sfsymbols:sunMinFill",
			--To = "sfsymbols:sunMaxFill",
		},
		Callback = function(value)
			print(value)
		end,
	})

	SliderTab:Space()

	SliderTab:Section({
		Title = "Slider with icons (from & to)",
		TextSize = 14,
	})

	SliderTab:Slider({
		IsTooltip = true,
		Step = 1,
		Value = {
			Min = 0,
			Max = 100,
			Default = 50,
		},
		Icons = {
			From = "sfsymbols:sunMinFill",
			To = "sfsymbols:sunMaxFill",
		},
		Callback = function(value)
			print(value)
		end,
	})
end

-- */  Dropdown Tab  /* --
do
	local DropdownTab = ElementsSection:Tab({
		Title = "Dropdown",
		Icon = "solar:hamburger-menu-bold",
		IconColor = Yellow,
		IconShape = "Square",
		Border = true,
	})

	DropdownTab:Dropdown({
		Title = "Advanced Dropdown (example)",
		Values = {
			{
				Title = "New file",
				Desc = "Create a new file",
				Icon = "file-plus",
				Callback = function()
					print("Clicked 'New File'")
				end,
			},
			{
				Title = "Copy link",
				Desc = "Copy the file link",
				Icon = "copy",
				Callback = function()
					print("Clicked 'Copy link'")
				end,
			},
			{
				Title = "Edit file",
				Desc = "Allows you to edit the file",
				Icon = "file-pen",
				Callback = function()
					print("Clicked 'Edit file'")
				end,
			},
			{
				Type = "Divider",
			},
			{
				Title = "Delete file",
				Desc = "Permanently delete the file",
				Icon = "trash",
				Callback = function()
					print("Clicked 'Delete file'")
				end,
			},
		},
	})

	DropdownTab:Space()

	DropdownTab:Dropdown({
		Title = "Multi Dropdown",
		Values = {
			"Привет",
			"Hello",
			"Сәлем",
			"Bonjour",
		},
		Value = nil,
		AllowNone = true,
		Multi = true,
		Callback = function(selectedValue)
			print("Selected: " .. selectedValue)
		end,
	})

	DropdownTab:Space()

	DropdownTab:Dropdown({
		Title = "No Multi Dropdown (default",
		Values = {
			"Привет",
			"Hello",
			"Сәлем",
			"Bonjour",
		},
		Value = 1,
		--AllowNone = true,
		Callback = function(selectedValue)
			print("Selected: " .. selectedValue)
		end,
	})

	DropdownTab:Space()
end

-- */  Config Usage  /* --
if not RunService:IsStudio() and writefile and printidentity() then
	do -- config elements
		local ConfigElementsTab = ConfigUsageSection:Tab({
			Title = "Config Elements",
			Icon = "solar:file-text-bold",
			IconColor = Blue,
			IconShape = nil,
			Border = true,
		})

		-- All elements are taken from the official documentation: https://footagesus.github.io/WindUI-Docs/docs

		-- Saving elements to the config using `Flag`

		ConfigElementsTab:Colorpicker({
			Flag = "ColorpickerTest",
			Title = "Colorpicker",
			Desc = "Colorpicker Description",
			Default = Color3.fromRGB(0, 255, 0),
			Transparency = 0,
			Locked = false,
			Callback = function(color)
				print("Background color: " .. tostring(color))
			end,
		})

		ConfigElementsTab:Space()

		ConfigElementsTab:Dropdown({
			Flag = "DropdownTest",
			Title = "Advanced Dropdown",
			Values = {
				{
					Title = "Category A",
					Icon = "bird",
				},
				{
					Title = "Category B",
					Icon = "house",
				},
				{
					Title = "Category C",
					Icon = "droplet",
				},
			},
			Value = "Category A",
			Callback = function(option)
				print("Category selected: " .. option.Title .. " with icon " .. option.Icon)
			end,
		})
		ConfigElementsTab:Dropdown({
			Flag = "DropdownTest2",
			Title = "Advanced Dropdown 2",
			Values = {
				{
					Title = "Category A",
					Icon = "bird",
				},
				{
					Title = "Category B",
					Icon = "house",
				},
				{
					Title = "Category C",
					Icon = "droplet",
					Locked = true,
				},
			},
			Value = "Category A",
			Multi = true,
			Callback = function(options)
				local titles = {}
				for _, v in ipairs(options) do
					table.insert(titles, v.Title)
				end
				print("Selected: " .. table.concat(titles, ", "))
			end,
		})

		ConfigElementsTab:Space()

		ConfigElementsTab:Input({
			Flag = "InputTest",
			Title = "Input",
			Desc = "Input Description",
			Value = "Default value",
			InputIcon = "bird",
			Type = "Input", -- or "Textarea"
			Placeholder = "Enter text...",
			Callback = function(input)
				print("Text entered: " .. input)
			end,
		})

		ConfigElementsTab:Space()

		ConfigElementsTab:Keybind({
			Flag = "KeybindTest",
			Title = "Keybind",
			Desc = "Keybind to open ui",
			Value = "G",
			Callback = function(v)
				Window:SetToggleKey(Enum.KeyCode[v])
			end,
		})

		ConfigElementsTab:Space()

		ConfigElementsTab:Slider({
			Flag = "SliderTest",
			Title = "Slider",
			Step = 1,
			Value = {
				Min = 20,
				Max = 120,
				Default = 70,
			},
			Callback = function(value)
				print(value)
			end,
		})
		ConfigElementsTab:Slider({
			Flag = "SliderTest2",
			--Title = "Slider",
			Icons = {
				From = "sfsymbols:sunMinFill",
				To = "sfsymbols:sunMaxFill",
			},
			Step = 1,
			IsTooltip = true,
			Value = {
				Min = 0,
				Max = 100,
				Default = 50,
			},
			Callback = function(value)
				print(value)
			end,
		})

		ConfigElementsTab:Space()

		ConfigElementsTab:Toggle({
			Flag = "ToggleTest",
			Title = "Toggle Panel Background",
			--Desc = "Toggle Description",
			--Icon = "house",
			--Type = "Checkbox",
			Value = not Window.HidePanelBackground,
			Callback = function(state)
				Window:SetPanelBackground(state)
			end,
		})

		ConfigElementsTab:Toggle({
			Flag = "ToggleTest",
			Title = "Toggle",
			Desc = "Toggle Description",
			--Icon = "house",
			--Type = "Checkbox",
			Value = false,
			Callback = function(state)
				print("Toggle Activated" .. tostring(state))
			end,
		})
	end

	do -- config panel
		local ConfigTab = ConfigUsageSection:Tab({
			Title = "Config Usage",
			Icon = "solar:folder-with-files-bold",
			IconColor = Purple,
			IconShape = nil,
			Border = true,
		})

		local ConfigManager = Window.ConfigManager
		local ConfigName = "default"

		local ConfigNameInput = ConfigTab:Input({
			Title = "Config Name",
			Icon = "file-cog",
			Callback = function(value)
				ConfigName = value
			end,
		})

		ConfigTab:Space()

		-- local AutoLoadToggle = ConfigTab:Toggle({
		--     Title = "Enable Auto Load to Selected Config",
		--     Value = false,
		--     Callback = function(v)
		--         Window.CurrentConfig:SetAutoLoad(v)
		--     end
		-- })

		-- ConfigTab:Space()

		local AllConfigs = ConfigManager:AllConfigs()
		local DefaultValue = table.find(AllConfigs, ConfigName) and ConfigName or nil

		local AllConfigsDropdown = ConfigTab:Dropdown({
			Title = "All Configs",
			Desc = "Select existing configs",
			Values = AllConfigs,
			Value = DefaultValue,
			Callback = function(value)
				ConfigName = value
				ConfigNameInput:Set(value)

				--AutoLoadToggle:Set(ConfigManager:GetConfig(ConfigName).AutoLoad or false)
			end,
		})

		ConfigTab:Space()

		ConfigTab:Button({
			Title = "Save Config",
			Icon = "",
			Justify = "Center",
			Callback = function()
				Window.CurrentConfig = ConfigManager:Config(ConfigName)
				if Window.CurrentConfig:Save() then
					WindUI:Notify({
						Title = "Config Saved",
						Desc = "Config '" .. ConfigName .. "' saved",
						Icon = "check",
					})
				end

				AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
			end,
		})

		ConfigTab:Space()

		ConfigTab:Button({
			Title = "Load Config",
			Icon = "",
			Justify = "Center",
			Callback = function()
				Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
				if Window.CurrentConfig:Load() then
					WindUI:Notify({
						Title = "Config Loaded",
						Desc = "Config '" .. ConfigName .. "' loaded",
						Icon = "refresh-cw",
					})
				end
			end,
		})

		ConfigTab:Space()

		ConfigTab:Button({
			Title = "Print AutoLoad Configs",
			Icon = "",
			Justify = "Center",
			Callback = function()
				print(HttpService:JSONDecode(ConfigManager:GetAutoLoadConfigs()))
			end,
		})
	end
end

-- */  Other  /* --
do
	local InviteCode = "ftgs-development-hub-1300692552005189632"
	local DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"

	local Response = WindUI.cloneref(game:GetService("HttpService"))
		:JSONDecode(WindUI.Creator.Request and WindUI.Creator.Request({
			Url = DiscordAPI,
			Method = "GET",
			Headers = {
				["User-Agent"] = "WindUI/Example",
				["Accept"] = "application/json",
			},
		}).Body or "{}")

	local DiscordTab = OtherSection:Tab({
		Title = "Discord",
		Border = true,
	})

	if Response and Response.guild then
		DiscordTab:Section({
			Title = "Join our Discord server!",
			TextSize = 20,
		})
		local DiscordServerParagraph = DiscordTab:Paragraph({
			Title = tostring(Response.guild.name),
			Desc = tostring(Response.guild.description),
			Image = "https://cdn.discordapp.com/icons/"
				.. Response.guild.id
				.. "/"
				.. Response.guild.icon
				.. ".png?size=1024",
			Thumbnail = "https://cdn.discordapp.com/banners/1300692552005189632/35981388401406a4b7dffd6f447a64c4.png?size=512",
			ImageSize = 48,
			Buttons = {
				{
					Title = "Copy link",
					Icon = "link",
					Callback = function()
						setclipboard("https://discord.gg/" .. InviteCode)
					end,
				},
			},
		})
	elseif RunService:IsStudio() or not writefile then
		DiscordTab:Paragraph({
			Title = "Discord API is not available in Studio mode.",
			TextSize = 20,
			Justify = "Center",
			Image = "solar:info-circle-bold",
			Color = "Red",
			Buttons = {
				{
					Title = "Get/Copy Invite Link",
					Icon = "link",
					Callback = function()
						if setclipboard then
							setclipboard("https://discord.gg/" .. InviteCode)
						else
							WindUI:Notify({
								Title = "Discord Invite Link",
								Content = "https://discord.gg/" .. InviteCode,
							})
						end
					end,
				},
			},
		})
	else
		DiscordTab:Paragraph({
			Title = "Failed to fetch Discord server info.",
			TextSize = 20,
			Justify = "Center",
			Image = "solar:info-circle-bold",
			Color = "Red",
		})
	end
end

local Tabs = {
	ExampleTab = Window:Tab({
		Title = "Example Tab",
		Icon = "bird",
	}),
}

local dropdownA

local LargeListA = {
	"All",
	"Item A2",
	"Item A3",
	"Item A4",
	"Item A5",
	"Item A6",
	"Item A7",
	"Item A8",
	"Item A9",
	"Item A10",
	"Item A11",
	"Item A12",
	"Item A13",
	"Item A14",
	"Item A15",
	"Item A16",
	"Item A17",
	"Item A18",
	"Item A19",
	"Item A20",
	"Item A21",
	"Item A22",
	"Item A23",
	"Item A24",
	"Item A25",
	"Item A26",
	"Item A27",
	"Item A28",
	"Item A29",
	"Item A30",
	"Item A31",
	"Item A32",
	"Item A33",
	"Item A34",
	"Item A35",
	"Item A36",
	"Item A37",
	"Item A38",
	"Item A39",
	"Item A40",
	"Item A41",
	"Item A42",
	"Item A43",
	"Item A44",
	"Item A45",
	"Item A46",
	"Item A47",
	"Item A48",
	"Item A49",
	"Item A50",
	"Item A51",
	"Item A52",
	"Item A53",
	"Item A54",
	"Item A55",
	"Item A56",
	"Item A57",
	"Item A58",
	"Item A59",
	"Item A60",
	"Item A61",
	"Item A62",
	"Item A63",
	"Item A64",
	"Item A65",
	"Item A66",
	"Item A67",
	"Item A68",
	"Item A69",
	"Item A70",
	"Item A71",
	"Item A72",
	"Item A73",
	"Item A74",
	"Item A75",
	"Item A76",
	"Item A77",
	"Item A78",
	"Item A79",
	"Item A80",
	"Item A81",
	"Item A82",
	"Item A83",
	"Item A84",
	"Item A85",
	"Item A86",
	"Item A87",
	"Item A88",
	"Item A89",
	"Item A90",
	"Item A91",
	"Item A92",
	"Item A93",
	"Item A94",
	"Item A95",
	"Item A96",
	"Item A97",
	"Item A98",
	"Item A99",
	"Item A100",
}

local LargeListB = {
	"Data B1",
	"Data B2",
	"Data B3",
	"Data B4",
	"Data B5",
	"Data B6",
	"Data B7",
	"Data B8",
	"Data B9",
	"Data B10",
}

Tabs.ExampleTab:Dropdown({
	Title = "Main Category",
	Values = { "All", "Other Option" },
	Value = "All",
	Callback = function(option)
		if dropdownA then
			task.spawn(function()
				if option == "All" then
					dropdownA:Refresh(LargeListA)
				else
					dropdownA:Refresh(LargeListB)
				end

				dropdownA:Select({ "All" })
			end)
		end
	end,
})

dropdownA = Tabs.ExampleTab:Dropdown({
	Title = "Target",
	Values = LargeListA,
	Multi = true,
	Value = { "All" },
	Callback = function(option) end,
})


-- */  macOS Sequoia + Notification Center + Keybind Menu Showcase Tab  /* --
do
	local UpgradeTab = Window:Tab({
		Title = "macOS Sequoia",
		Icon = "sparkles",
	})
	UpgradeTab:SetBadge("MAC")

	local Stats = UpgradeTab:StatCard({
		Title = "Live Hub Metrics",
		Columns = 3,
		Items = {
			{ Title = "Theme", Value = "MacOS", Color = "#0A84FF", Subtitle = "Sequoia Dark" },
			{ Title = "Notify", Value = "MacOS Banner", Color = "#30D158", Subtitle = "TopRight" },
			{ Title = "Mode", Value = "Sword", Subtitle = "Combat" },
		},
	})

	local LogConsole = UpgradeTab:Console({
		Title = "Live Activity Console",
		Desc = "RichText log viewer with Copy & Clear",
		Height = 140,
		MaxLines = 150,
		AutoScroll = true,
	})
	LogConsole:Info("Loaded local main.luau (macOS Sequoia UI + Notification Center Banner + Keybind HUD)")

	local NotifySec = UpgradeTab:Section({
		Title = "macOS Notification Center & Dynamic Island",
		Desc = "Hover a banner to pause countdown & reveal top-left (×) close pill, or swipe horizontally to dismiss",
		Opened = true,
	})

	NotifySec:Segmented({
		Title = "Notification Style",
		Values = { "MacOS", "DynamicIsland" },
		Value = "MacOS",
		Callback = function(style)
			WindUI:SetNotificationStyle(style)
			if style == "MacOS" then
				WindUI:SetNotificationPosition("TopRight")
			else
				WindUI:SetNotificationPosition("BottomCenter")
			end
			Stats:SetItem("Notify", style == "MacOS" and "MacOS Banner" or "Dynamic Island")
			WindUI:Notify({
				Title = style == "MacOS" and "Notification Center" or "Dynamic Island",
				SubTitle = "Style Updated",
				Content = style == "MacOS"
					and "macOS Sequoia floating banner with app squircle, timestamp & top-left hover close pill."
					or "Dynamic Island morphing pill notification active.",
				Type = "Info",
				Duration = 4,
			})
		end,
	})

	NotifySec:Segmented({
		Title = "Banner Position",
		Values = { "TopRight", "TopCenter", "TopLeft", "BottomRight", "BottomCenter" },
		Value = "TopRight",
		Width = 300,
		Callback = function(pos)
			WindUI:SetNotificationPosition(pos)
			WindUI:Notify({
				Title = "Notification Position",
				SubTitle = pos,
				Content = "Notifications now anchor to " .. pos .. ".",
				Type = "Info",
				Duration = 3.5,
			})
		end,
	})

	local NotifyRow = NotifySec:HStack({ AutoSpace = false })
	NotifyRow:Button({
		Title = "macOS Banner + Actions",
		Icon = "bell",
		Variant = "Primary",
		Callback = function()
			WindUI:Notify({
				Title = "Software Update",
				SubTitle = "macOS Sequoia 15.2",
				Content = "Ready to install. Hover to pause timer or click the top-left (×) pill to dismiss.",
				Icon = "sparkles",
				Style = "MacOS",
				Duration = 6,
				Buttons = {
					{
						Title = "Install Now",
						Variant = "Primary",
						Callback = function()
							LogConsole:Success("Clicked macOS Banner: Install Now")
						end,
					},
					{
						Title = "Later",
						Callback = function()
							LogConsole:Info("Clicked macOS Banner: Later")
						end,
					},
				},
			})
		end,
	})
	NotifyRow:Button({
		Title = "Dynamic Island Pill",
		Icon = "sparkles",
		Variant = "Secondary",
		Callback = function()
			WindUI:Notify({
				Title = "AirPods Pro Connected",
				Content = "Noise Cancellation • 98% Battery",
				Type = "Success",
				DynamicIsland = true,
				Duration = 4,
			})
		end,
	})

	local KeybindSec = UpgradeTab:Section({
		Title = "Complete Keybind Menu System",
		Opened = true,
	})

	local AutoFarmToggle = KeybindSec:Toggle({
		Title = "Auto Farm (Synced Keybind + Floating Pill)",
		Desc = "Press [G] or tap inside the Keybind Menu HUD to toggle",
		Flag = "UpgradeAutoFarm",
		Value = false,
		Keybind = "G",
		KeybindMode = "Toggle",
		Callback = function(state)
			LogConsole:Log("Auto Farm: " .. tostring(state), state and "Success" or "Warn")
		end,
	})
	AutoFarmToggle:PinButton({
		Title = "Auto Farm",
		Icon = "zap",
	})

	KeybindSec:Keybind({
		Title = "Speed Boost (Hold Mode)",
		Desc = "Click mode pill (HLD) or right-click to switch Toggle/Hold/Always",
		Flag = "SpeedBoostKey",
		Value = "LeftShift",
		Mode = "Hold",
		Callback = function(key, active)
			LogConsole:Log("Speed Boost [" .. tostring(key) .. "] -> " .. tostring(active), active and "Success" or "Info")
		end,
	})

	KeybindSec:Keybind({
		Title = "ESP Overlay (Always Mode)",
		Desc = "Shows live active status in the macOS Keybind Menu HUD",
		Flag = "EspAlwaysKey",
		Value = "V",
		Mode = "Always",
		Callback = function(key, active)
			LogConsole:Info("ESP Keybind [" .. tostring(key) .. "] active=" .. tostring(active))
		end,
	})

	KeybindSec:Button({
		Title = "Toggle Keybind Menu HUD",
		Desc = "Or click the Keyboard icon on the macOS titlebar",
		Icon = "keyboard",
		Callback = function()
			Window:ToggleKeybindMenu()
		end,
	})

	local MacSec = UpgradeTab:Section({
		Title = "macOS UI Controls & Extra Elements",
		Opened = true,
	})

	MacSec:Segmented({
		Title = "macOS Appearance",
		Values = { "MacOS", "MacOSLight", "Dark" },
		Value = "MacOS",
		Callback = function(themeName)
			WindUI:SetTheme(themeName)
			Stats:SetItem("Theme", themeName)
		end,
	})

	MacSec:Segmented({
		Title = "Combat Mode",
		Flag = "UpgradeCombatMode",
		Values = { "Melee", "Sword", "Gun", "Fruit" },
		Value = "Sword",
		Callback = function(v)
			Stats:SetItem("Mode", tostring(v))
			LogConsole:Info("Combat Mode -> " .. tostring(v))
		end,
	})

	MacSec:RangeSlider({
		Title = "Attack Distance Range",
		Flag = "UpgradeRangeSlider",
		Step = 5,
		Value = { Min = 0, Max = 100, Default = { 20, 75 } },
	})

	MacSec:Input({
		Title = "Speed Multiplier (Stepper)",
		Flag = "UpgradeStepperInput",
		Stepper = true,
		Min = 1,
		Max = 25,
		Step = 1,
		Value = 5,
	})

	MacSec:Input({
		Title = "Secret Key (Masked + Clear)",
		Flag = "UpgradeSecretInput",
		Placeholder = "Enter secret token...",
		Value = "secret-key-123",
		Masked = true,
		ClearButton = true,
	})

	MacSec:Dropdown({
		Title = "Target Filters (MultiActions)",
		Flag = "UpgradeMultiDropdown",
		Values = { "Bosses", "Elites", "Chests", "Materials", "Events" },
		Multi = true,
		MultiActions = true,
		Value = { "Bosses", "Chests" },
	})

	MacSec:Segmented({
		Title = "macOS Layout Form",
		Desc = "Switch between Classic Sidebar and macOS New Form (SF Symbols bottom Navigate Bar, Hide UI, -15% scale)",
		Values = { "Classic", "New Form" },
		Value = "Classic",
		Callback = function(form)
			Window:SetLayoutMode(form == "New Form" and "NewForm" or "Classic")
		end,
	})

	MacSec:Segmented({
		Title = "Sidebar Tab Mode",
		Desc = "Switch between Full, compact Icon Only rail, or Collapsed curved edge handle",
		Values = { "Full", "Icon Only", "Collapsed" },
		Value = "Full",
		Callback = function(mode)
			if mode == "Collapsed" then
				Window:SetSidebarCollapsed(true)
			else
				Window:SetSidebarMode(mode == "Icon Only" and "IconOnly" or "Full")
			end
		end,
	})

	MacSec:Colorpicker({
		Title = "Accent Tint (macOS Color Panel)",
		Flag = "UpgradeMacColorpicker",
		Default = Color3.fromHex("#0A84FF"),
		Transparency = 0.15,
		Callback = function(color, transparency)
			LogConsole:Info("Color -> #" .. color:ToHex():upper() .. " (alpha=" .. tostring(math.floor((1 - (transparency or 0)) * 100 + 0.5)) .. "%)")
		end,
	})

	MacSec:Button({
		Title = "Replay Intro",
		Icon = "play",
		Variant = "Primary",
		Callback = function()
			WindUI:PlayIntro({
				Title = "WindUI",
				Subtitle = "macOS Sequoia",
				Icon = "sfsymbols:folderFill",
			}, false)
		end,
	})

	MacSec:Button({
		Title = "Open Key System",
		Icon = "sfsymbols:keyFill",
		Variant = "Secondary",
		Callback = function()
			WindUI:OpenKeySystem({
				Title = "WindUI",
				Note = "Enter your access key to continue. Demo key: <b>MACOS-2026</b>",
				Key = { "MACOS-2026", "SEQUOIA", "1234" },
				Default = "MACOS-2026",
				URL = "https://discord.gg/ftgs-development-hub-1300692552005189632",
				SaveKey = false,
			}, function(unlocked)
				LogConsole:Log("Key System result: " .. tostring(unlocked), unlocked and "Success" or "Warn")
			end)
		end,
	})

	Window:CreateSettingsTab({
		Title = "Hub Settings",
		Icon = "sfsymbols:gearshapeFill",
	})

	WindUI:Notify({
		Title = "WindUI macOS Sequoia",
		SubTitle = "Notification Center",
		Content = "macOS A-Z UI + Apple SF Symbols + New Form Navigate Bar active.",
		Icon = "sfsymbols:bellFill",
		Type = "Success",
		Duration = 5,
	})
end
