local ImportGlobals

-- Holds the actual DOM data
local ObjectTree = {
    {
        1,
        "ModuleScript",
        {
            "Icon"
        },
        {
            {
                3,
                "ModuleScript",
                {
                    "Reference"
                }
            },
            {
                2,
                "ModuleScript",
                {
                    "VERSION"
                }
            },
            {
                4,
                "Folder",
                {
                    "Packages"
                },
                {
                    {
                        6,
                        "ModuleScript",
                        {
                            "Janitor"
                        }
                    },
                    {
                        5,
                        "ModuleScript",
                        {
                            "GoodSignal"
                        }
                    }
                }
            },
            {
                15,
                "ModuleScript",
                {
                    "Utility"
                }
            },
            {
                7,
                "Folder",
                {
                    "Elements"
                },
                {
                    {
                        9,
                        "ModuleScript",
                        {
                            "Widget"
                        }
                    },
                    {
                        8,
                        "ModuleScript",
                        {
                            "Container"
                        }
                    },
                    {
                        10,
                        "ModuleScript",
                        {
                            "Dropdown"
                        }
                    },
                    {
                        12,
                        "ModuleScript",
                        {
                            "Caption"
                        }
                    },
                    {
                        11,
                        "ModuleScript",
                        {
                            "Menu"
                        }
                    }
                }
            },
            {
                13,
                "Folder",
                {
                    "Themes"
                },
                {
                    {
                        14,
                        "ModuleScript",
                        {
                            "Default"
                        }
                    }
                }
            }
        }
    }
}

-- Holds direct closure data
local ClosureBindings = {
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(1)-- Explain here the changes in performance, codebase, organisation, readability, modularisation, separation of logic etcf



-- SERVICES
local LocalizationService = game:GetService("LocalizationService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService") -- This is to generate GUIDs
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")



-- REFERENCE HANDLER
-- Multiple Icons packages may exist at runtime (for instance if the developer additionally uses HD Admin)
-- therefore this ensures that the first required package becomes the dominant and only functioning module
local iconModule = script
local Reference = require(iconModule.Reference)
local referenceObject = Reference.getObject()
local leadPackage = referenceObject and referenceObject.Value
if leadPackage and leadPackage ~= iconModule then
	return require(leadPackage)
end
if not referenceObject then
	Reference.addToReplicatedStorage()
end



-- MODULES
--local Controller = require(iconModule.Controller)
local Signal = require(iconModule.Packages.GoodSignal)
local Janitor = require(iconModule.Packages.Janitor)
local Utility = require(iconModule.Utility)
local Icon = {}
Icon.__index = Icon



--- LOCAL
local localPlayer = Players.LocalPlayer
local themes = iconModule.Themes
local defaultTheme = require(themes.Default)
local playerGui = localPlayer:WaitForChild("PlayerGui")
local icons = {}
local anyIconSelected = Signal.new()
local elements = iconModule.Elements
local container = require(elements.Container)()
for _, screenGui in pairs(container) do
	screenGui.Parent = playerGui
end


-- PUBLIC VARIABLES
Icon.container = container



-- CONSTRUCTOR
function Icon.new()
	local self = {}
	setmetatable(self, Icon)

	--- Janitors (for cleanup)
	local janitor = Janitor.new()
	self.janitor = janitor
	self.themesJanitor = janitor:add(Janitor.new())
	self.singleClickJanitor = janitor:add(Janitor.new())
	self.captionJanitor = janitor:add(Janitor.new())
	self.joinJanitor = janitor:add(Janitor.new())
	self.menuJanitor = janitor:add(Janitor.new())
	self.dropdownJanitor = janitor:add(Janitor.new())

	-- Signals (events)
	self.selected = janitor:add(Signal.new())
	self.deselected = janitor:add(Signal.new())
	self.toggled = janitor:add(Signal.new())
	self.hoverStarted = janitor:add(Signal.new())
	self.hoverEnded = janitor:add(Signal.new())
	self.pressStarted = janitor:add(Signal.new())
	self.pressEnded = janitor:add(Signal.new())
	self.stateChanged = janitor:add(Signal.new())
	self.notified = janitor:add(Signal.new())
	self.noticeChanged = janitor:add(Signal.new())
	self.endNotices = janitor:add(Signal.new())
	self.dropdownOpened = janitor:add(Signal.new())
	self.dropdownClosed = janitor:add(Signal.new())
	self.menuOpened = janitor:add(Signal.new())
	self.menuClosed = janitor:add(Signal.new())
	self.toggleKeyAdded = janitor:add(Signal.new())
	self.alignmentChanged = janitor:add(Signal.new())
	self.updateSize = janitor:add(Signal.new())
	self.resizingComplete = janitor:add(Signal.new())
	self.joinedParent = janitor:add(Signal.new())

	-- Properties
	self.Icon = Icon
	self.UID = HttpService:GenerateGUID(true)
	self.isEnabled = true
	self.isSelected = false
	self.isHovering = false
	self.isPressing = false
	self.isDragging = false
	self.joinedFrame = false
	self.parentIcon = false
	self.deselectWhenOtherIconSelected = true
	self.totalNotices = 0
	self.activeState = "Deselected"
	self.alignment = ""
	self.originalAlignment = ""
	self.appliedTheme = {}
	self.cachedInstances = {}
	self.cachedNamesToInstances = {}
	self.cachedCollectives = {}
	self.bindedToggleKeys = {}
	self.customBehaviours = {}
	self.toggleItems = {}
	self.bindedEvents = {}
	self.notices = {}
	self.menuIcons = {}
	self.dropdownIcons = {}
	self.childIconsDict = {}

	-- Widget is the name name for an icon
	local widget = janitor:add(require(elements.Widget)(self))
	self.widget = widget
	self:setAlignment()

	-- This applies the default them
	self:setTheme(defaultTheme)

	-- Button Clicked (for states "Selected" and "Deselected")
	local clickRegion = self:getInstance("ClickRegion")
	local function handleToggle()
		if self.locked then
			return
		end
		if self.isSelected then
			self:deselect(self)
		else
			self:select(self)
		end
	end
	clickRegion.MouseButton1Click:Connect(handleToggle)

	-- Keys can be bound to toggle between Selected and Deselected
	janitor:add(UserInputService.InputBegan:Connect(function(input, touchingAnObject)
		if self.locked then
			return
		end
		if self.bindedToggleKeys[input.KeyCode] and not touchingAnObject then
			handleToggle()
		end
	end))

	-- Button Pressing (for state "Pressing")
	clickRegion.MouseButton1Down:Connect(function()
		if self.locked then
			return
		end
		self:setState("Pressing", self)
	end)

	-- Button Hovering (for state "Hovering")
	local function hoveringStarted()
		if self.locked then
			return
		end
		self.isHovering = true
		self.hoverStarted:Fire(true)
		self:setState("Hovering", self)
	end
	local function hoveringEnded()
		if self.locked then
			return
		end
		self.isHovering = false
		self.hoverEnded:Fire(true)
		self:setState(nil, self)
	end
	self.joinedParent:Connect(function()
		if self.isHovering then
			hoveringEnded()
		end
	end)
	clickRegion.MouseEnter:Connect(hoveringStarted)
	clickRegion.MouseLeave:Connect(hoveringEnded)
	clickRegion.SelectionGained:Connect(hoveringStarted)
	clickRegion.SelectionLost:Connect(hoveringEnded)
	clickRegion.MouseButton1Down:Connect(function()
		if self.isDragging then
			hoveringStarted()
		end
	end)
	if UserInputService.TouchEnabled then
		clickRegion.MouseButton1Up:Connect(function()
			if self.locked then
				return
			end
			if self.hovering then
				hoveringEnded()
			end
		end)
		-- This is used to highlight when a mobile/touch device is dragging their finger accross the screen
		-- this is important for determining the hoverStarted and hoverEnded events on mobile
		local dragCount = 0
		janitor:add(UserInputService.TouchMoved:Connect(function(touch, touchingAnObject)
			if touchingAnObject then
				return
			end
			self.isDragging = true
		end))
		janitor:add(UserInputService.TouchEnded:Connect(function()
			self.isDragging = false
		end))
	end

	-- Handle overlay on hovering
	local iconOverlay = self:getInstance("IconOverlay")
	self.hoverStarted:Connect(function()
		iconOverlay.Visible = not self.overlayDisabled
	end)
	self.hoverEnded:Connect(function()
		iconOverlay.Visible = false
	end)

	-- Deselect when another icon is selected
	janitor:add(anyIconSelected:Connect(function(incomingIcon)
		if incomingIcon ~= self and self.deselectWhenOtherIconSelected and incomingIcon.deselectWhenOtherIconSelected then
			self:deselect()
		end
	end))

	-- This checks if the script calling this module is a descendant of a ScreenGui
	-- with 'ResetOnSpawn' set to true. If it is, then we destroy the icon the
	-- client respawns. This solves one of the most asked about questions on the post
	-- The only caveat this may not work if the player doesn't uniquely name their ScreenGui and the frames
	-- the LocalScript rests within
	local source =  debug.info(2, "s")
	local sourcePath = string.split(source, ".")
	local origin = game
	local originsScreenGui
	for i, sourceName in pairs(sourcePath) do
		origin = origin:FindFirstChild(sourceName)
		if not origin then
			break
		end
		if origin:IsA("ScreenGui") then
			originsScreenGui = origin
		end
	end
	if origin and originsScreenGui and originsScreenGui.ResetOnSpawn == true then
		Utility.localPlayerRespawned(function()
			self:destroy()
		end)
	end
	
	-- Additional notice behaviour
	local noticeLabel = self:getInstance("NoticeLabel")
	self.toggled:Connect(function()
		self.noticeChanged:Fire(self.totalNotices)
		for childIcon, _ in pairs(self.childIconsDict) do
			childIcon.noticeChanged:Fire(childIcon.totalNotices)
		end
	end)
	
	-- Final
	task.defer(function()
		-- We defer so that if a deselected event is binded, the action
		-- inside can now be called to apply the default appearance
		-- We set the state to selected so that calling :deselect()
		-- will now correctly register the state to deselected (therefore
		-- triggering the events we want)
		self.activeState = ""
		self.isSelected = true
		self:deselect()
		self:refresh()
	end)

	return self
end



-- METHODS
function Icon:setName(name)
	self.widget.Name = name
	self.name = name
	return self
end

function Icon:setState(incomingStateName, fromInput)
	-- This is responsible for acknowleding a change in stage (such as from "Deselected" to "Hovering" when
	-- a users mouse enters the widget), then informing other systems of this state change to then act upon
	-- (such as the theme handler applying the theme which corresponds to that state).
	if not incomingStateName then
		incomingStateName = (self.isSelected and "Selected") or "Deselected"
	end
	local stateName = Utility.formatStateName(incomingStateName)
	local previousStateName = self.activeState
	if previousStateName == stateName then
		return
	end
	local currentIsSelected = self.isSelected
	self.activeState = stateName
	if stateName == "Deselected" then
		self.isSelected = false
		if currentIsSelected then
			self.toggled:Fire(false, fromInput)
			self.deselected:Fire(fromInput)
		end
		self:_setToggleItemsVisible(false, fromInput)
	elseif stateName == "Selected" then
		self.isSelected = true
		if not currentIsSelected then
			self.toggled:Fire(true, fromInput)
			self.selected:Fire(fromInput)
			anyIconSelected:Fire(self)
		end
		self:_setToggleItemsVisible(true, fromInput)
	elseif stateName == "Pressing" then
		self.isPressing = true
		self.pressStarted:Fire(fromInput)
	end
	if previousStateName == "Pressing" then
		self.isPressing = false
		self.pressEnded:Fire(fromInput)
	end
	self.stateChanged:Fire(stateName, fromInput)
end

function Icon:getInstance(name)
	-- This enables us to easily retrieve instances located within the icon simply by passing its name.
	-- Every important/significant instance is named uniquely therefore this is no worry of overlap.
	-- We cache the result for more performant retrieval in the future.
	local instance = self.cachedNamesToInstances[name]
	if instance then
		return instance
	end
	local function cacheInstance(childName, child)
		local currentCache = self.cachedInstances[child]
		if not currentCache then
			local collectiveName = child:GetAttribute("Collective")
			local cachedCollective = collectiveName and self.cachedCollectives[collectiveName]
			if cachedCollective then
				table.insert(cachedCollective, child)
			end
			self.cachedNamesToInstances[childName] = child
			self.cachedInstances[child] = true
			child.Destroying:Once(function()
				self.cachedNamesToInstances[childName] = nil
				self.cachedInstances[child] = nil
			end)
		end
	end
	local widget = self.widget
	cacheInstance("Widget", widget)
	if name == "Widget" then
		return widget
	end

	local returnChild
	local function scanChildren(parentInstance)
		for _, child in pairs(parentInstance:GetChildren()) do
			local widgetUID = child:GetAttribute("WidgetUID")
			if widgetUID and widgetUID ~= self.UID then
				-- This prevents instances within other icons from being recorded
				-- (for instance when other icons are added to this icons menu)
				continue
			end
			scanChildren(child)
			if child:IsA("GuiBase") or child:IsA("UIBase") or child:IsA("ValueBase") then
				local childName = child.Name
				cacheInstance(childName, child)
				if childName == name then
					returnChild = child
				end
			end
		end
	end
	scanChildren(widget)
	return returnChild
end

function Icon:getCollective(name)
	-- A collective is an array of instances within the Widget that have been
	-- grouped together based on a given name. This just makes it easy
	-- to act on multiple instances at once which share similar behaviours.
	-- For instance, if we want to change the icons corner size, all corner instances
	-- with the attribute "Collective" and value "WidgetCorner" could be updated
	-- instantly by doing icon:set("WidgetCorner", newSize)
	local collective = self.cachedCollectives[name]
	if collective then
		return collective
	end
	collective = {}
	for instance, _ in pairs(self.cachedInstances) do
		if instance:GetAttribute("Collective") == name then
			table.insert(collective, instance)
		end
	end
	self.cachedCollectives[name] = collective
	return collective
end

function Icon:get(collectiveOrInstanceName)
	-- Similar to :getInstance but also accounts for 'Collectives', such as UICorners and returns
	-- an array of instances instead of a single instance
	local instances = {}
	local instance = self:getInstance(collectiveOrInstanceName)
	if instance then
		table.insert(instances, instance)
	end
	if #instances == 0 then
		instances = self:getCollective(collectiveOrInstanceName)
	end
	return instances
end

function Icon:getValue(instance, property)
	local success, value = pcall(function()
		return instance[property]
	end)
	if not success then
		value = instance:GetAttribute(property)
	end
	return value
end

function Icon:refreshAppearance(instance, property)
	local value = self:getValue(instance, property)
	self:set(instance, property, value, true)
end

function Icon:set(collectiveOrInstanceNameOrInstance, property, value, forceApply)
	-- This is responsible for **applying** appearance changes to instances within the icon
	-- however it IS NOT responsible for updating themes. Use :modifyTheme for that.
	-- This also calls callbacks given by :setBehaviour before applying these property changes
	-- to the given instances
	local instances
	local collectiveOrInstanceName = collectiveOrInstanceNameOrInstance
	if typeof(collectiveOrInstanceNameOrInstance) == "Instance" then
		instances = {collectiveOrInstanceNameOrInstance}
		collectiveOrInstanceName = collectiveOrInstanceNameOrInstance.Name
	else
		instances = self:get(collectiveOrInstanceNameOrInstance)
	end
	local key = collectiveOrInstanceName.."-"..property
	local customBehaviour = self.customBehaviours[key]
	for _, instance in pairs(instances) do
		local currentValue = self:getValue(instance, property)
		if not forceApply and value == currentValue then
			continue
		end
		if customBehaviour then
			local newValue = customBehaviour(value, instance, property)
			if newValue ~= nil then
				value = newValue
			end
		end
		local success = pcall(function()
			instance[property] = value
		end)
		if not success then
			-- If property is not a real property, we set
			-- the value as an attribute instead. This is useful
			-- for instance in :setWidth where we also want to
			-- specify a desired width for every state which can
			-- then be easily read by the widget element
			instance:SetAttribute(property, value)
		end
	end
	return self
end

function Icon:setBehaviour(collectiveOrInstanceName, property, callback, refreshAppearance)
	-- You can specify your own custom callback to handle custom logic just before
	-- an instances property is changed by using :setBehaviour()
	local key = collectiveOrInstanceName.."-"..property
	self.customBehaviours[key] = callback
	if refreshAppearance then
		local instances = self:get(collectiveOrInstanceName)
		for _, instance in pairs(instances) do
			self:refreshAppearance(instance, property)
		end
	end
end

function Icon:getThemeValue(instanceName, property, iconState)
	if not iconState then
		iconState = self.activeState
	end
	local stateGroup = self.appliedTheme[iconState]
	for _, detail in pairs(stateGroup) do
		local checkingInstanceName, checkingPropertyName, checkingValue = unpack(detail)
		if instanceName == checkingInstanceName and property == checkingPropertyName then
			return checkingValue
		end
	end
end

function Icon:modifyTheme(instanceName, property, value, iconState)
	-- This is what the 'old set' used to do (although for clarity that behaviour has now been
	-- split into two methods, :modifyTheme and :set).
	-- modifyTheme is responsible for UPDATING the internal values within a theme for a particular
	-- state, then checking to see if the appearance of the icon needs to be updated.
	-- If no iconState is specified, the change is applied to both Deselected and Selected
	task.spawn(function()
		if iconState == nil then
			-- If no state specified, apply to both Deselected and Selected
			self:modifyTheme(instanceName, property, value, "Selected")
		end
		local chosenState = Utility.formatStateName(iconState or "Deselected")
		local stateGroup = self.appliedTheme[chosenState]
		local function nowSetIt()
			if chosenState == self.activeState then
				self:set(instanceName, property, value)
			end
		end
		for _, detail in pairs(stateGroup) do
			local checkingInstanceName, checkingPropertyName, _ = unpack(detail)
			if instanceName == checkingInstanceName and property == checkingPropertyName then
				detail[3] = value
				nowSetIt()
				return
			end
		end
		local detail = {instanceName, property, value}
		table.insert(stateGroup, detail)
		nowSetIt()
	end)
	return self
end

function Icon:setTheme(theme)
	-- This is responsible for processing the final appearance of a given theme (such as
	-- ensuring missing Pressing values mirror Hovering), saving that internal state,
	-- then checking to see if the appearance of the icon needs to be updated
	local themesJanitor = self.themesJanitor
	themesJanitor:clean()
	if typeof(theme) == "Instance" and theme:IsA("ModuleScript") then
		theme = require(theme)
	end
	local function applyTheme()
		local stateGroup = self.appliedTheme[self.activeState]
		for _, detail in pairs(stateGroup) do
			local instanceName, property, value = unpack(detail)
			self:set(instanceName, property, value)
		end
	end
	local function generateTheme()
		for stateName, defaultStateGroup in pairs(defaultTheme) do
			local finalDetails = {}
			local function updateDetails(group)
				-- This ensures there's always a base 'default' layer
				if not group then
					return
				end
				for _, detail in pairs(group) do
					local key = detail[1].."-"..detail[2]
					finalDetails[key] = detail
				end
			end
			-- This applies themes in layers
			-- The last layers take higher priority as they overwrite
			-- any duplicate earlier applied effects
			if stateName == "Selected" then
				updateDetails(defaultTheme.Deselected)
			end
			if stateName == "Pressing" then
				updateDetails(theme.Hovering)
			end
			updateDetails(theme[stateName])
			local finalStateGroup = {}
			for _, detail in pairs(finalDetails) do
				table.insert(finalStateGroup, detail)
			end
			self.appliedTheme[stateName] = Utility.copyTable(finalStateGroup)
		end
		applyTheme()
	end
	generateTheme()
	themesJanitor:add(self.stateChanged:Connect(applyTheme))
	return self
end

function Icon:setEnabled(bool)
	self.isEnabled = bool
	self.widget.Visible = bool
	return self
end

function Icon:select(fromInput)
	self:setState("Selected", fromInput)
	return self
end

function Icon:deselect(fromInput)
	self:setState("Deselected", fromInput)
	return self
end

function Icon:notify(customClearSignal, noticeId)
	-- Generates a notification which appears in the top right of the icon. Useful for example for prompting
	-- users of changes/updates within your UI such as a Catalog
	-- 'customClearSignal' is a signal object (e.g. icon.deselected) or
	-- Roblox event (e.g. Instance.new("BindableEvent").Event)
	if not customClearSignal then
		customClearSignal = self.deselected
	end
	if self.parentIcon then
		self.parentIcon:notify(customClearSignal)
	end
	local noticeJanitor = self.janitor:add(Janitor.new())
	local noticeComplete = noticeJanitor:add(Signal.new())
	noticeJanitor:add(self.endNotices:Connect(function()
		noticeComplete:Fire()
	end))
	noticeJanitor:add(customClearSignal:Connect(function()
		noticeComplete:Fire()
	end))
	noticeId = noticeId or HttpService:GenerateGUID(true)
	self.notices[noticeId] = {
		completeSignal = noticeComplete,
		clearNoticeEvent = customClearSignal,
	}
	local noticeLabel = self:getInstance("NoticeLabel")
	local function updateNotice()
		self.noticeChanged:Fire(self.totalNotices)
	end
	self.notified:Fire(noticeId)
	self.totalNotices += 1
	updateNotice()
	noticeComplete:Once(function()
		noticeJanitor:destroy()
		self.totalNotices -= 1
		self.notices[noticeId] = nil
		updateNotice()
	end)
	return self
end

function Icon:clearNotices()
	self.endNotices:Fire()
	return self
end

function Icon:disableOverlay(bool)
	self.overlayDisabled = bool
	return self
end
Icon.disableStateOverlay = Icon.disableOverlay

function Icon:setImage(imageId, iconState)
	self:modifyTheme("IconImage", "Image", imageId, iconState)
	return self
end

function Icon:setLabel(text, iconState)
	self:modifyTheme("IconLabel", "Text", text, iconState)
	return self
end

function Icon:setOrder(int, iconState)
	self:modifyTheme("Widget", "LayoutOrder", int, iconState)
	return self
end

function Icon:setCornerRadius(udim, iconState)
	self:modifyTheme("IconCorners", "CornerRadius", udim, iconState)
	return self
end

function Icon:setAlignment(leftMidOrRight, isFromParentIcon)
	-- Determines the side of the screen the icon will be ordered
	local direction = tostring(leftMidOrRight):lower()
	if direction == "mid" or direction == "centre" then
		direction = "center"
	end
	if direction ~= "left" and direction ~= "center" and direction ~= "right" then
		direction = "left"
	end
	local screenGui = (direction == "center" and container.TopbarCentered) or container.TopbarStandard
	local holders = screenGui.Holders
	local finalDirection = string.upper(string.sub(direction, 1, 1))..string.sub(direction, 2)
	if not isFromParentIcon then
		self.originalAlignment = finalDirection
	end
	local joinedFrame = self.joinedFrame
	self.widget.Parent = joinedFrame or holders[finalDirection]
	self.alignment = finalDirection
	self.alignmentChanged:Fire(finalDirection)
	return self
end

function Icon:setLeft()
	self:setAlignment("Left")
	return self
end

function Icon:setMid()
	self:setAlignment("Center")
	return self
end

function Icon:setRight()
	self:setAlignment("Right")
	return self
end

function Icon:setWidth(offsetMinimum, iconState)
	-- This sets a minimum X offset size for the widget, useful
	-- for example if you're constantly changing the label
	-- but don't want the icon to resize every time
	local newSize = UDim2.fromOffset(offsetMinimum, self.widget.Size.Y.Offset)
	self:modifyTheme("Widget", "Size", newSize, iconState)
	self:modifyTheme("Widget", "DesiredWidth", offsetMinimum, iconState)
	return self
end

function Icon:setImageScale(number, iconState)
	self:modifyTheme("IconImageScale", "Value", number, iconState)
	return self
end

function Icon:setImageRatio(number, iconState)
	self:modifyTheme("IconImageRatio", "AspectRatio", number, iconState)
	return self
end

function Icon:setTextSize(number, iconState)
	self:modifyTheme("IconLabel", "TextSize", number, iconState)
	return self
end

function Icon:setTextFont(fontNameOrAssetId, fontWeight, fontStyle, iconState)
	fontWeight = fontWeight or Enum.FontWeight.Regular
	fontStyle = fontStyle or Enum.FontStyle.Normal
	local fontFace = Font.new(fontNameOrAssetId, fontWeight, fontStyle)
	self:modifyTheme("IconLabel", "FontFace", fontFace, iconState)
	return self
end

function Icon:bindToggleItem(guiObjectOrLayerCollector)
	if not guiObjectOrLayerCollector:IsA("GuiObject") and not guiObjectOrLayerCollector:IsA("LayerCollector") then
		error("Toggle item must be a GuiObject or LayerCollector!")
	end
	self.toggleItems[guiObjectOrLayerCollector] = true
	self:_updateSelectionInstances()
	return self
end

function Icon:unbindToggleItem(guiObjectOrLayerCollector)
	self.toggleItems[guiObjectOrLayerCollector] = nil
	self:_updateSelectionInstances()
	return self
end

function Icon:_updateSelectionInstances()
	-- This is to assist with controller navigation and selection
	-- It converts the value true to an array
	for guiObjectOrLayerCollector, _ in pairs(self.toggleItems) do
		local buttonInstancesArray = {}
		for _, instance in pairs(guiObjectOrLayerCollector:GetDescendants()) do
			if (instance:IsA("TextButton") or instance:IsA("ImageButton")) and instance.Active then
				table.insert(buttonInstancesArray, instance)
			end
		end
		self.toggleItems[guiObjectOrLayerCollector] = buttonInstancesArray
	end
end

function Icon:_setToggleItemsVisible(bool, fromInput)
	for toggleItem, _ in pairs(self.toggleItems) do
		if not fromInput or fromInput == self or fromInput.toggleItems[toggleItem] == nil then
			local property = "Visible"
			if toggleItem:IsA("LayerCollector") then
				property = "Enabled"
			end
			toggleItem[property] = bool
		end
	end
end

function Icon:bindEvent(iconEventName, eventFunction)
	local event = self[iconEventName]
	assert(event and typeof(event) == "table" and event.Connect, "argument[1] must be a valid topbarplus icon event name!")
	assert(typeof(eventFunction) == "function", "argument[2] must be a function!")
	self.bindedEvents[iconEventName] = event:Connect(function(...)
		eventFunction(self, ...)
	end)
	return self
end

function Icon:unbindEvent(iconEventName)
	local eventConnection = self.bindedEvents[iconEventName]
	if eventConnection then
		eventConnection:Disconnect()
		self.bindedEvents[iconEventName] = nil
	end
	return self
end

function Icon:bindToggleKey(keyCodeEnum)
	assert(typeof(keyCodeEnum) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
	self.bindedToggleKeys[keyCodeEnum] = true
	self.toggleKeyAdded:Fire(keyCodeEnum)
	return self
end

function Icon:unbindToggleKey(keyCodeEnum)
	assert(typeof(keyCodeEnum) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
	self.bindedToggleKeys[keyCodeEnum] = nil
	return self
end

function Icon:call(callback)
	task.spawn(function()
		callback(self)
	end)
	return self
end

function Icon:addToJanitor(callback)
	self.janitor:add(callback)
	return self
end

function Icon:lock()
	-- This disables all user inputs related to the icon (such as clicking buttons, pressing keys, etc)
	local iconButton = self:getInstance("IconButton")
	iconButton.Active = false
	self.locked = true
	return self
end

function Icon:unlock()
	local iconButton = self:getInstance("IconButton")
	iconButton.Active = true
	self.locked = false
	return self
end

function Icon:debounce(seconds)
	self:lock()
	task.wait(seconds)
	self:unlock()
	return self
end

function Icon:autoDeselect(bool)
	-- When set to true the icon will deselect itself automatically whenever
	-- another icon is selected
	if bool == nil then
		bool = true
	end
	self.deselectWhenOtherIconSelected = bool
	return self
end

function Icon:oneClick(bool)
	-- When set to true the icon will automatically deselect when selected, this creates
	-- the effect of a single click button
	local singleClickJanitor = self.singleClickJanitor
	singleClickJanitor:clean()
	if bool or bool == nil then
		singleClickJanitor:add(self.selected:Connect(function()
			self:deselect()
		end))
	end
	return self
end

function Icon:setCaption(text)
	local captionJanitor = self.captionJanitor
	self.captionJanitor:clean()
	if not text or text == "" then
		self.caption = nil
		self.captionText = nil
		return
	end
	local caption = captionJanitor:add(require(elements.Caption)(self))
	caption:SetAttribute("CaptionText", text)
	self.caption = caption
	self.captionText = text
	return self
end

function Icon:refresh()
	self.updateSize:Fire()
end

function Icon:_join(parentIcon, iconsArray, scrollingFrameOrFrame)
	
	-- This is resonsible for moving the icon under a feature like a dropdown
	local joinJanitor = self.joinJanitor
	joinJanitor:clean()
	if not scrollingFrameOrFrame then
		self:leave()
		return
	end
	self.parentIcon = parentIcon
	self.joinedFrame = scrollingFrameOrFrame
	local function updateAlignent()
		local parentAlignment = parentIcon.alignment
		if parentAlignment == "Center" then
			parentAlignment = "Left"
		end
		self:setAlignment(parentAlignment, true)
	end
	joinJanitor:add(parentIcon.alignmentChanged:Connect(updateAlignent))
	updateAlignent()
	self:setBehaviour("IconButton", "BackgroundTransparency", function()
		if self.joinedFrame then
			return 1
		end
	end, true)
	self.parentIconsArray = iconsArray
	table.insert(iconsArray, self)
	parentIcon:autoDeselect(false)
	parentIcon.childIconsDict[self] = true
	if not parentIcon.isEnabled then
		parentIcon:setEnabled(true)
	end
	self.joinedParent:Fire(parentIcon)
	
	-- This is responsible for removing it from that feature and updating
	-- their parent icon so its informed of the icon leaving it
	joinJanitor:add(function()
		local joinedFrame = self.joinedFrame
		if not joinedFrame then
			return
		end
		local parentIcon = self.parentIcon
		self:setAlignment(self.originalAlignment)
		self.parentIcon = false
		self.joinedFrame = false
		self:setBehaviour("IconButton", "BackgroundTransparency", nil, true)
		local iconsArray = self.parentIconsArray
		local remaining = #iconsArray
		for i, iconToCompare in pairs(iconsArray) do
			if iconToCompare == self then
				table.remove(iconsArray, i)
				remaining -= 1
				break
			end
		end
		if remaining <= 0 then
			parentIcon:setEnabled(false)
		end
		parentIcon.childIconsDict[self] = nil
	end)
	
	return self
end

function Icon:leave()
	local joinJanitor = self.joinJanitor
	joinJanitor:clean()
	return self
end

function Icon:joinMenu(parentIcon)
	self:_join(parentIcon, parentIcon.menuIcons, parentIcon:getInstance("IconHolder"))
end

function Icon:setMenu(arrayOfIcons)
	
	-- Reset any previous icons
	for i, otherIcon in pairs(self.menuIcons) do
		otherIcon:leave()
	end
	
	-- Listen for changes
	local menuJanitor = self.menuJanitor
	menuJanitor:clean()
	menuJanitor:add(self.toggled:Connect(function()
		if #self.menuIcons > 0 then
			self.updateSize:Fire()
		end
	end))
	
	-- Apply new icons
	local totalNewIcons = #arrayOfIcons
	if type(arrayOfIcons) == "table" then
		for i, otherIcon in pairs(arrayOfIcons) do
			otherIcon:joinMenu(self)
		end
	end
	
	-- Apply a close selected image if the user hasn't applied thier own 
	local imageDeselected = self:getThemeValue("IconImage", "Image", "Deselected")
	local imageSelected = self:getThemeValue("IconImage", "Image", "Selected")
	if imageDeselected == imageSelected then
		local fontLink = "rbxasset://fonts/families/FredokaOne.json"
		local fontFace = Font.new(fontLink, Enum.FontWeight.Light, Enum.FontStyle.Normal)
		self:modifyTheme("IconLabel", "FontFace", fontFace, "Selected")
		self:modifyTheme("IconLabel", "Text", "X", "Selected")
		self:modifyTheme("IconLabel", "TextSize", 20, "Selected")
		self:modifyTheme("IconLabel", "TextStrokeTransparency", 0.8, "Selected")
		self:modifyTheme("IconImage", "Image", "", "Selected") --16027684411
	end
	
	-- Change order of spot when alignment changes
	local iconSpot = self:getInstance("IconSpot")
	local menuGap = self:getInstance("MenuGap")
	local function updateAlignent()
		local alignment = self.alignment
		if alignment == "Right" then
			iconSpot.LayoutOrder = 99999
			menuGap.LayoutOrder = 99998
		else
			iconSpot.LayoutOrder = -99999
			menuGap.LayoutOrder = -99998
		end
	end
	menuJanitor:add(self.alignmentChanged:Connect(updateAlignent))
	updateAlignent()
	
	return self
end

function Icon:joinDropdown(parentIcon)
	--!!! only for testing, I'm going to create an additiional feature
	-- to make to easy to apply a temporary theme then to remove it
	local appliedThemeCopy = Utility.copyTable(self.appliedTheme)
	task.defer(function()
		self.joinJanitor:add(function()
			self:setTheme(appliedThemeCopy)
		end)
	end)
	self:modifyTheme("Widget", "BorderSize", 0)
	self:modifyTheme("IconCorners", "CornerRadius", UDim.new(0, 4))
	self:modifyTheme("Widget", "MinimumWidth", 190) --225
	self:modifyTheme("Widget", "MinimumHeight", 56)
	self:modifyTheme("IconLabel", "TextSize", 19)
	self:modifyTheme("PaddingLeft", "Size", UDim2.fromOffset(20, 0))
	--
	self:_join(parentIcon, parentIcon.dropdownIcons, parentIcon:getInstance("DropdownHolder"))
end

function Icon:setDropdown(arrayOfIcons)

	-- Reset any previous icons
	for i, otherIcon in pairs(self.dropdownIcons) do
		otherIcon:leave()
	end
	
	-- Setup janitor
	local dropdownJanitor = self.dropdownJanitor
	dropdownJanitor:clean()

	-- Apply new icons
	local totalNewIcons = #arrayOfIcons
	local dropdown = dropdownJanitor:add(require(elements.Dropdown)(self))
	local holder = dropdown.DropdownHolder
	dropdown.Parent = self.widget
	if type(arrayOfIcons) == "table" then
		for i, otherIcon in pairs(arrayOfIcons) do
			otherIcon:joinDropdown(self)
		end
	end
	
	-- Update visibiliy of dropdown
	local function updateVisibility()
		dropdown.Visible = self.isSelected
	end
	dropdownJanitor:add(self.toggled:Connect(updateVisibility))
	updateVisibility()

	return self
end



-- DESTROY/CLEANUP
function Icon:destroy()
	if self.isDestroyed then
		return
	end
	self:clearNotices()
	if self.parentIcon then
		self:leave()
	end
	self.isDestroyed = true
	self.janitor:clean()
end
Icon.Destroy = Icon.destroy



return Icon end,
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(2)return "v3.0.0" end,
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(3)-- This module enables you to place Icon wherever you like within the data model while
-- still enabling third-party applications (such as HDAdmin/Nanoblox) to locate it
-- This is necessary to prevent two TopbarPlus applications initiating at runtime which would
-- cause icons to overlap with each other

local replicatedStorage = game:GetService("ReplicatedStorage")
local Reference = {}
Reference.objectName = "TopbarPlusReference"

function Reference.addToReplicatedStorage()
	local existingItem = replicatedStorage:FindFirstChild(Reference.objectName)
    if existingItem then
        return false
    end
    local objectValue = Instance.new("ObjectValue")
	objectValue.Name = Reference.objectName
    objectValue.Value = script.Parent
    objectValue.Parent = replicatedStorage
    return objectValue
end

function Reference.getObject()
	local objectValue = replicatedStorage:FindFirstChild(Reference.objectName)
    if objectValue then
        return objectValue
    end
    return false
end

return Reference end,
    [5] = function()local maui,script,require,getfenv,setfenv=ImportGlobals(5)--[[
-------------------------------------
This package was modified by ForeverHD.

PACKAGE MODIFICATIONS:
	1. Added alias ``Signal:Destroy/destroy`` for ``Signal:DisconnectAll``
	2. Removed some warnings/errors
	3. Possibly some additional changes which weren't tracked
	4. Added :ConnectOnce
	5. Added a tracebackString and callFunction which now wraps errors with this traceback message
-------------------------------------
--]]



-- Credit to Stravant for this package:
-- https://devforum.roblox.com/t/lua-signal-class-comparison-optimal-goodsignal-class/1387063

--------------------------------------------------------------------------------
--               Batched Yield-Safe Signal Implementation                     --
-- This is a Signal class which has effectively identical behavior to a       --
-- normal RBXScriptSignal, with the only difference being a couple extra      --
-- stack frames at the bottom of the stack trace when an error is thrown.     --
-- This implementation caches runner coroutines, so the ability to yield in   --
-- the signal handlers comes at minimal extra cost over a naive signal        --
-- implementation that either always or never spawns a thread.                --
--                                                                            --
-- API:                                                                       --
--   local Signal = require(THIS MODULE)                                      --
--   local sig = Signal.new()                                                 --
--   local connection = sig:Connect(function(arg1, arg2, ...) ... end)        --
--   sig:Fire(arg1, arg2, ...)                                                --
--   connection:Disconnect()                                                  --
--   sig:DisconnectAll()                                                      --
--   local arg1, arg2, ... = sig:Wait()                                       --
--                                                                            --
-- Licence:                                                                   --
--   Licenced under the MIT licence.                                          --
--                                                                            --
-- Authors:                                                                   --
--   stravant - July 31st, 2021 - Created the file.                           --
--------------------------------------------------------------------------------

-- The currently idle thread to run the next handler on
local freeRunnerThread = nil
local function callFunction(fn, tracebackString, ...)
	fn(...)
	--[[
	local _, modifiedErrorMessage = xpcall(fn, function(errorMessage)
		local path = errorMessage:split(":")
		local path1 = path and path[1]
		local otherMessage
		if #path == 1 then
			local len = string.find(path1, '"')
			if len then
				otherMessage = string.sub(path1, 1, len-2)
			end
		end
		local moduleName = (path1 and path1:match("[^%.]+$")) or "Unknown"
		if #moduleName > 10 then
			moduleName = tracebackString
		end
		local lineNumber = (path and path[2]) or "?"
		local message = (path and path[3] and path[3]:sub(2)) or otherMessage or "NA" 
		if message == "NA" then
			message = errorMessage
		end
		local newErrorMessage = ("Signal connection threw an error: [%s:%s]: %s"):format(moduleName, lineNumber, message)
		return newErrorMessage
	end, ...)
	if modifiedErrorMessage then
		main.warn(modifiedErrorMessage, tracebackString) -- This needs to include original and after
	end
	--]]
end

-- Function which acquires the currently idle handler runner thread, runs the
-- function fn on it, and then releases the thread, returning it to being the
-- currently idle one.
-- If there was a currently idle runner thread already, that's okay, that old
-- one will just get thrown and eventually GCed.
local function acquireRunnerThreadAndCallEventHandler(fn, tracebackString, ...)
	local acquiredRunnerThread = freeRunnerThread
	freeRunnerThread = nil
	callFunction(fn, tracebackString, ...)
	-- The handler finished running, this runner thread is free again.
	freeRunnerThread = acquiredRunnerThread
end

-- Coroutine runner that we create coroutines of. The coroutine can be 
-- repeatedly resumed with functions to run followed by the argument to run
-- them with.
local function runEventHandlerInFreeThread(...)
	acquireRunnerThreadAndCallEventHandler(...)
	while true do
		acquireRunnerThreadAndCallEventHandler(coroutine.yield())
	end
end

-- Connection class
local Connection = {}
Connection.__index = Connection

function Connection.new(signal, fn)
	return setmetatable({
		_connected = true,
		_signal = signal,
		_fn = fn,
		_next = false,
	}, Connection)
end

function Connection:Disconnect()
	if not self._connected then
		return
	end
	self._connected = false

	-- Unhook the node, but DON'T clear it. That way any fire calls that are
	-- currently sitting on this node will be able to iterate forwards off of
	-- it, but any subsequent fire calls will not hit it, and it will be GCed
	-- when no more fire calls are sitting on it.
	if self._signal._handlerListHead == self then
		self._signal._handlerListHead = self._next
	else
		local prev = self._signal._handlerListHead
		while prev and prev._next ~= self do
			prev = prev._next
		end
		if prev then
			prev._next = self._next
		end
	end
end
Connection.Destroy = Connection.Disconnect

-- Make Connection strict
setmetatable(Connection, {
	__index = function(tb, key)
		error(("Attempt to get Connection::%s (not a valid member)"):format(tostring(key)), 2)
	end,
	__newindex = function(tb, key, value)
		error(("Attempt to set Connection::%s (not a valid member)"):format(tostring(key)), 2)
	end
})

-- Signal class
local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable({
		_handlerListHead = false,	
	}, Signal)
end

function Signal:Connect(fn)
	local connection = Connection.new(self, fn)
	if self._handlerListHead then
		connection._next = self._handlerListHead
		self._handlerListHead = connection
	else
		self._handlerListHead = connection
	end
	return connection
end

function Signal:ConnectOnce(fn)
	local connection
	local newFn = function(...)
		connection:Disconnect()
		fn(...)
	end
	connection = self:Connect(newFn)
	return connection
end
Signal.Once = Signal.ConnectOnce

-- Disconnect all handlers. Since we use a linked list it suffices to clear the
-- reference to the head handler.
function Signal:DisconnectAll()
	self._handlerListHead = false
end
Signal.Destroy = Signal.DisconnectAll
Signal.destroy = Signal.DisconnectAll

-- Signal:Fire(...) implemented by running the handler functions on the
-- coRunnerThread, and any time the resulting thread yielded without returning
-- to us, that means that it yielded to the Roblox scheduler and has been taken
-- over by Roblox scheduling, meaning we have to make a new coroutine runner.
function Signal:_FireBehaviour(isSpecial, ...)
	local tracebackString = table.concat({debug.info(3, "sl")}, " ")
	local item = self._handlerListHead
	local completedSignal = isSpecial and Signal.new()
	local totalItems = 0
	local completedItems = 0
	if isSpecial then
		local itemToCheck = item
		while itemToCheck do
			if itemToCheck._connected then
				totalItems += 1
			end
			itemToCheck = itemToCheck._next
		end
	end
	while item do
		if item._connected then
			if not freeRunnerThread then
				freeRunnerThread = coroutine.create(runEventHandlerInFreeThread)
			end
			local modifiedFunction = function(...)
				callFunction(item._fn, tracebackString, ...)
				if isSpecial then
					completedItems += 1
					if completedItems == totalItems then
						completedSignal:Fire()
						completedSignal:Destroy()
						completedSignal = false
					end
				end
			end
			task.spawn(freeRunnerThread, modifiedFunction, tracebackString, ...)
		end
		item = item._next
	end
	if isSpecial then
		return completedSignal
	end
end

function Signal:Fire(...)
	self:_FireBehaviour(false, ...)
end

function Signal:SpecialFire(...)
	-- 'Special Fires' creates and returns an additional Signal which is called when all the original signals events have
	-- finished calling
	return self:_FireBehaviour(true, ...)
end


-- Implement Signal:Wait() in terms of a temporary connection using
-- a Signal:Connect() which disconnects itself.
function Signal:Wait()
	local waitingCoroutine = coroutine.running()
	local cn;
	cn = self:Connect(function(...)
		cn:Disconnect()
		task.spawn(waitingCoroutine, ...)
	end)
	return coroutine.yield()
end

return Signal end,
    [6] = function()local maui,script,require,getfenv,setfenv=ImportGlobals(6)--[[
-------------------------------------
This package was modified by ForeverHD.

PACKAGE MODIFICATIONS:
	1. Added pascalCase aliases for all methods
	2. Modified behaviour of :add so that it takes both objects and promises (previously only objects)
	3. Slight change to how promises are tracked
	4. Added isAnInstanceBeingDestroyed check to line 228
	5. Added 'OriginalTraceback' to help determine where an error was added to the janitor
	6. Likely some additional changes which weren't record here
-------------------------------------
--]]



-- Janitor
-- Original by Validark
-- Modifications by pobammer
-- roblox-ts support by OverHash and Validark
-- LinkToInstance fixed by Elttob.

local RunService = game:GetService("RunService")
local Heartbeat = RunService.Heartbeat
local function getPromiseReference()
	if RunService:IsRunning() then
		local main = require(game:GetService("ReplicatedStorage").Framework)
		return main.modules.Promise
	end
end

local IndicesReference = newproxy(true)
getmetatable(IndicesReference).__tostring = function()
	return "IndicesReference"
end

local LinkToInstanceIndex = newproxy(true)
getmetatable(LinkToInstanceIndex).__tostring = function()
	return "LinkToInstanceIndex"
end

local METHOD_NOT_FOUND_ERROR = "Object %s doesn't have method %s, are you sure you want to add it? Traceback: %s"
local NOT_A_PROMISE = "Invalid argument #1 to 'Janitor:AddPromise' (Promise expected, got %s (%s))"

local Janitor = {
	IGNORE_MEMORY_DEBUG = true,
	ClassName = "Janitor";
	__index = {
		CurrentlyCleaning = true;
		[IndicesReference] = nil;
	};
}

local TypeDefaults = {
	["function"] = true;
	["Promise"] = "cancel";
	RBXScriptConnection = "Disconnect";
}

--[[**
	Instantiates a new Janitor object.
	@returns [t:Janitor]
**--]]
function Janitor.new()
	return setmetatable({
		CurrentlyCleaning = false;
		[IndicesReference] = nil;
	}, Janitor)
end

--[[**
	Determines if the passed object is a Janitor.
	@param [t:any] Object The object you are checking.
	@returns [t:boolean] Whether or not the object is a Janitor.
**--]]
function Janitor.Is(Object)
	return type(Object) == "table" and getmetatable(Object) == Janitor
end

Janitor.is = Janitor.Is

--[[**
	Adds an `Object` to Janitor for later cleanup, where `MethodName` is the key of the method within `Object` which should be called at cleanup time. If the `MethodName` is `true` the `Object` itself will be called instead. If passed an index it will occupy a namespace which can be `Remove()`d or overwritten. Returns the `Object`.
	@param [t:any] Object The object you want to clean up.
	@param [t:string|true?] MethodName The name of the method that will be used to clean up. If not passed, it will first check if the object's type exists in TypeDefaults, and if that doesn't exist, it assumes `Destroy`.
	@param [t:any?] Index The index that can be used to clean up the object manually.
	@returns [t:any] The object that was passed.
**--]]
function Janitor.__index:Add(Object, MethodName, Index)
	if Index then
		self:Remove(Index)

		local This = self[IndicesReference]
		if not This then
			This = {}
			self[IndicesReference] = This
		end

		This[Index] = Object
	end

	local objectType = typeof(Object)
	if objectType == "table" and string.match(tostring(Object), "Promise") then
		objectType = "Promise"
		--local status = Object:getStatus()
		--print("status =", status, status == "Rejected")
	end
	MethodName = MethodName or TypeDefaults[objectType] or "Destroy"
	if type(Object) ~= "function" and not Object[MethodName] then
		warn(string.format(METHOD_NOT_FOUND_ERROR, tostring(Object), tostring(MethodName), debug.traceback(nil :: any, 2)))
	end

	local OriginalTraceback = debug.traceback("")
	self[Object] = {MethodName, OriginalTraceback}
	return Object
end
Janitor.__index.Give = Janitor.__index.Add

-- My version of Promise has PascalCase, but I converted it to use lowerCamelCase for this release since obviously that's important to do.

--[[**
	Adds a promise to the janitor. If the janitor is cleaned up and the promise is not completed, the promise will be cancelled.
	@param [t:Promise] PromiseObject The promise you want to add to the janitor.
	@returns [t:Promise]
**--]]
function Janitor.__index:AddPromise(PromiseObject)
	local Promise = getPromiseReference()
	if Promise then
		if not Promise.is(PromiseObject) then
			error(string.format(NOT_A_PROMISE, typeof(PromiseObject), tostring(PromiseObject)))
		end
		if PromiseObject:getStatus() == Promise.Status.Started then
			local Id = newproxy(false)
			local NewPromise = self:Add(Promise.new(function(Resolve, _, OnCancel)
				if OnCancel(function()
						PromiseObject:cancel()
					end) then
					return
				end

				Resolve(PromiseObject)
			end), "cancel", Id)

			NewPromise:finallyCall(self.Remove, self, Id)
			return NewPromise
		else
			return PromiseObject
		end
	else
		return PromiseObject
	end
end
Janitor.__index.GivePromise = Janitor.__index.AddPromise

-- This will assume whether or not the object is a Promise or a regular object.
function Janitor.__index:AddObject(Object)
	local Id = newproxy(false)
	local Promise = getPromiseReference()
	if Promise and Promise.is(Object) then
		if Object:getStatus() == Promise.Status.Started then
			local NewPromise = self:Add(Promise.resolve(Object), "cancel", Id)
			NewPromise:finallyCall(self.Remove, self, Id)
			return NewPromise, Id
		else
			return Object
		end
	else
		return self:Add(Object, false, Id), Id
	end
end

Janitor.__index.GiveObject = Janitor.__index.AddObject

--[[**
	Cleans up whatever `Object` was set to this namespace by the 3rd parameter of `:Add()`.
	@param [t:any] Index The index you want to remove.
	@returns [t:Janitor] The same janitor, for chaining reasons.
**--]]
function Janitor.__index:Remove(Index)
	local This = self[IndicesReference]
	if This then
		local Object = This[Index]

		if Object then
			local ObjectDetail = self[Object]
			local MethodName = ObjectDetail and ObjectDetail[1]

			if MethodName then
				if MethodName == true then
					Object()
				else
					local ObjectMethod = Object[MethodName]
					if ObjectMethod then
						ObjectMethod(Object)
					end
				end

				self[Object] = nil
			end

			This[Index] = nil
		end
	end

	return self
end

--[[**
	Gets whatever object is stored with the given index, if it exists. This was added since Maid allows getting the job using `__index`.
	@param [t:any] Index The index that the object is stored under.
	@returns [t:any?] This will return the object if it is found, but it won't return anything if it doesn't exist.
**--]]
function Janitor.__index:Get(Index)
	local This = self[IndicesReference]
	if This then
		return This[Index]
	end
end

--[[**
	Calls each Object's `MethodName` (or calls the Object if `MethodName == true`) and removes them from the Janitor. Also clears the namespace. This function is also called when you call a Janitor Object (so it can be used as a destructor callback).
	@returns [t:void]
**--]]
function Janitor.__index:Cleanup()
	if not self.CurrentlyCleaning then
		self.CurrentlyCleaning = nil
		for Object, ObjectDetail in next, self do
			if Object == IndicesReference then
				continue
			end

			-- Weird decision to rawset directly to the janitor in Agent. This should protect against it though.
			local TypeOf = type(Object)
			if TypeOf == "string" or TypeOf == "number" then
				self[Object] = nil
				continue
			end

			local MethodName = ObjectDetail[1]
			local OriginalTraceback = ObjectDetail[2]
			local function warnUser(warning)
				local cleanupLine = debug.traceback("", 3)--string.gsub(debug.traceback("", 3), "%c", "")
				local addedLine = OriginalTraceback
				warn("-------- Janitor Error --------".."\n"..tostring(warning).."\n"..cleanupLine..""..addedLine)
			end
			if MethodName == true then
				local success, warning = pcall(Object)
				if not success then
					warnUser(warning)
				end
			else
				local ObjectMethod = Object[MethodName]
				if ObjectMethod then
					local success, warning = pcall(ObjectMethod, Object)
					local isAnInstanceBeingDestroyed = typeof(Object) == "Instance" and ObjectMethod == "Destroy"
					if not success and not isAnInstanceBeingDestroyed then
						warnUser(warning)
					end
				end
			end

			self[Object] = nil
		end

		local This = self[IndicesReference]
		if This then
			for Index in next, This do
				This[Index] = nil
			end

			self[IndicesReference] = {}
		end

		self.CurrentlyCleaning = false
	end
end

Janitor.__index.Clean = Janitor.__index.Cleanup

--[[**
	Calls `:Cleanup()` and renders the Janitor unusable.
	@returns [t:void]
**--]]
function Janitor.__index:Destroy()
	self:Cleanup()
	--table.clear(self)
	--setmetatable(self, nil)
end

Janitor.__call = Janitor.__index.Cleanup

--- Makes the Janitor clean up when the instance is destroyed
-- @param Instance Instance The Instance the Janitor will wait for to be Destroyed
-- @returns Disconnectable table to stop Janitor from being cleaned up upon Instance Destroy (automatically cleaned up by Janitor, btw)
-- @author Corecii
local Disconnect = {Connected = true}
Disconnect.__index = Disconnect
function Disconnect:Disconnect()
	if self.Connected then
		self.Connected = false
		self.Connection:Disconnect()
	end
end

function Disconnect:__tostring()
	return "Disconnect<" .. tostring(self.Connected) .. ">"
end

--[[**
	"Links" this Janitor to an Instance, such that the Janitor will `Cleanup` when the Instance is `Destroyed()` and garbage collected. A Janitor may only be linked to one instance at a time, unless `AllowMultiple` is true. When called with a truthy `AllowMultiple` parameter, the Janitor will "link" the Instance without overwriting any previous links, and will also not be overwritable. When called with a falsy `AllowMultiple` parameter, the Janitor will overwrite the previous link which was also called with a falsy `AllowMultiple` parameter, if applicable.
	@param [t:Instance] Object The instance you want to link the Janitor to.
	@param [t:boolean?] AllowMultiple Whether or not to allow multiple links on the same Janitor.
	@returns [t:RbxScriptConnection] A pseudo RBXScriptConnection that can be disconnected.
**--]]
function Janitor.__index:LinkToInstance(Object, AllowMultiple)
	local Connection
	local IndexToUse = AllowMultiple and newproxy(false) or LinkToInstanceIndex
	local IsNilParented = Object.Parent == nil
	local ManualDisconnect = setmetatable({}, Disconnect)

	local function ChangedFunction(_DoNotUse, NewParent)
		if ManualDisconnect.Connected then
			_DoNotUse = nil
			IsNilParented = NewParent == nil

			if IsNilParented then
				coroutine.wrap(function()
					Heartbeat:Wait()
					if not ManualDisconnect.Connected then
						return
					elseif not Connection.Connected then
						self:Cleanup()
					else
						while IsNilParented and Connection.Connected and ManualDisconnect.Connected do
							Heartbeat:Wait()
						end

						if ManualDisconnect.Connected and IsNilParented then
							self:Cleanup()
						end
					end
				end)()
			end
		end
	end

	Connection = Object.AncestryChanged:Connect(ChangedFunction)
	ManualDisconnect.Connection = Connection

	if IsNilParented then
		ChangedFunction(nil, Object.Parent)
	end

	Object = nil
	return self:Add(ManualDisconnect, "Disconnect", IndexToUse)
end

--[[**
	Links several instances to a janitor, which is then returned.
	@param [t:...Instance] ... All the instances you want linked.
	@returns [t:Janitor] A janitor that can be used to manually disconnect all LinkToInstances.
**--]]
function Janitor.__index:LinkToInstances(...)
	local ManualCleanup = Janitor.new()
	for _, Object in ipairs({...}) do
		ManualCleanup:Add(self:LinkToInstance(Object, true), "Disconnect")
	end

	return ManualCleanup
end

for FunctionName, Function in next, Janitor.__index do
	local NewFunctionName = string.sub(string.lower(FunctionName), 1, 1) .. string.sub(FunctionName, 2)
	Janitor.__index[NewFunctionName] = Function
end

return Janitor end,
    [8] = function()local maui,script,require,getfenv,setfenv=ImportGlobals(8)return function()
	
	local container = {}
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "TopbarStandard"
	screenGui.Enabled = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.DisplayOrder = 10 -- We make it 10 so items like Captions appear in front of the chat
	screenGui.IgnoreGuiInset = true
	screenGui.ResetOnSpawn = false
	screenGui.ScreenInsets = Enum.ScreenInsets.TopbarSafeInsets
	container[screenGui.Name] = screenGui

	local holders = Instance.new("Frame")
	holders.Name = "Holders"
	holders.BackgroundTransparency = 1
	holders.Position = UDim2.new(0, 0, 0, 0)
	holders.Size = UDim2.new(1, 0, 1, -1)
	holders.Visible = true
	holders.ZIndex = 1
	holders.Active = false
	holders.Parent = screenGui
	
	local screenGuiCenter = screenGui:Clone()
	local holdersCenter = screenGuiCenter.Holders
	local GuiService = game:GetService("GuiService")
	local function updateCenteredHoldersHeight()
		holdersCenter.Size = UDim2.new(1, 0, 0, GuiService.TopbarInset.Height-1)
	end
	screenGuiCenter.Name = "TopbarCentered"
	screenGuiCenter.ScreenInsets = Enum.ScreenInsets.None
	container[screenGuiCenter.Name] = screenGuiCenter
	GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(updateCenteredHoldersHeight)
	updateCenteredHoldersHeight()
	
	local left = holders:Clone()
	local UIListLayout = Instance.new("UIListLayout")
	local GuiService = game:GetService("GuiService")
	local guiInset = GuiService:GetGuiInset()
	local newOffset = guiInset.Y - (44 + 2)
	local DEFAULT_POSITION = UDim2.fromOffset(12, 0)
	UIListLayout.Padding = UDim.new(0, newOffset)
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	UIListLayout.Parent = left
	left.Name = "Left"
	left.Position = DEFAULT_POSITION
	left.Size = UDim2.new(1, -24, 1, 0)
	left.Parent = holders
	
	local center = left:Clone()
	center.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	center.Name = "Center"
	center.Parent = holdersCenter
	
	local right = left:Clone()
	right.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	right.Name = "Right"
	right.Parent = holders

	return container
end end,
    [9] = function()local maui,script,require,getfenv,setfenv=ImportGlobals(9)-- I named this 'Widget' instead of 'Icon' to make a clear difference between the icon *object* and
-- the icon (aka Widget) instance.
-- This contains the core components of the icon such as the button, image, label and notice. It's
-- also responsible for handling the automatic resizing of the widget (based upon image visibility and text length)

return function(icon)

	local widget = Instance.new("Frame")
	widget:SetAttribute("WidgetUID", icon.UID)
	widget.Name = "Widget"
	widget.BackgroundTransparency = 1
	widget.Visible = true
	widget.ZIndex = 20
	widget.Active = false

	local button = Instance.new("Frame")
	button.Name = "IconButton"
	button.Visible = true
	button.ZIndex = 2
	button.BorderSizePixel = 0
	button.Parent = widget
	button.ClipsDescendants = true
	button.Active = true
	icon.deselected:Connect(function()
		button.ClipsDescendants = true
	end)
	icon.selected:Connect(function()
		task.defer(function()
			icon.resizingComplete:Once(function()
				if icon.isSelected then
					button.ClipsDescendants = false
				end
			end)
		end)
	end)

	local iconCorner = Instance.new("UICorner")
	iconCorner:SetAttribute("Collective", "IconCorners")
	iconCorner.Parent = button
	
	local iconHolder = Instance.new("Frame")
	iconHolder.Name = "IconHolder"
	iconHolder.BackgroundTransparency = 1
	iconHolder.Visible = true
	iconHolder.ZIndex = 1
	iconHolder.Active = false
	iconHolder.Size = UDim2.fromScale(1, 1)
	iconHolder.Parent = button
	
	local Icon = icon.Icon
	local holderUIListLayout = Icon.container.TopbarStandard:FindFirstChild("UIListLayout", true):Clone()
	holderUIListLayout.Name = "MenuUIListLayout"
	holderUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	holderUIListLayout.Parent = iconHolder
	
	local iconSpot = Instance.new("Frame")
	iconSpot.Name = "IconSpot"
	iconSpot.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
	iconSpot.BackgroundTransparency = 0.9
	iconSpot.Visible = true
	iconSpot.AnchorPoint = Vector2.new(0, 0.5)
	iconSpot.ZIndex = 5
	iconSpot.Parent = iconHolder
	
	local menuGap = Instance.new("Frame")
	menuGap.Name = "MenuGap"
	menuGap.BackgroundTransparency = 1
	menuGap.Visible = false
	menuGap.AnchorPoint = Vector2.new(0, 0.5)
	menuGap.ZIndex = 5
	menuGap.Parent = iconHolder
	
	local iconSpotCorner = iconCorner:Clone()
	iconSpotCorner.Parent = iconSpot

	local overlay = iconSpot:Clone()
	overlay.Name = "IconOverlay"
	overlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	overlay.ZIndex = iconSpot.ZIndex + 1
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.Position = UDim2.new(0, 0, 0, 0)
	overlay.AnchorPoint = Vector2.new(0, 0)
	overlay.Visible = false
	overlay.Parent = iconSpot
	
	local clickRegion = Instance.new("TextButton")
	clickRegion.Name = "ClickRegion"
	clickRegion.BackgroundTransparency = 1
	clickRegion.Visible = true
	clickRegion.Text = ""
	clickRegion.ZIndex = 20
	clickRegion.Parent = iconSpot

	local clickRegionCorner = iconCorner:Clone()
	clickRegionCorner.Parent = clickRegion

	local contents = Instance.new("Frame")
	contents.Name = "Contents"
	contents.BackgroundTransparency = 1
	contents.Size = UDim2.fromScale(1, 1)
	contents.Parent = iconSpot

	local ContentsUIListLayout = Instance.new("UIListLayout")
	ContentsUIListLayout.FillDirection = Enum.FillDirection.Horizontal
	ContentsUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	ContentsUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ContentsUIListLayout.VerticalFlex = Enum.UIFlexAlignment.SpaceEvenly
	ContentsUIListLayout.Padding = UDim.new(0, 5)
	ContentsUIListLayout.Parent = contents

	local paddingLeft = Instance.new("Frame")
	paddingLeft.Name = "PaddingLeft"
	paddingLeft.LayoutOrder = 1
	paddingLeft.ZIndex = 5
	paddingLeft.Size = UDim2.new(0, 5, 1, 0)
	paddingLeft.BorderColor3 = Color3.fromRGB(0, 0, 0)
	paddingLeft.BackgroundTransparency = 1
	paddingLeft.BorderSizePixel = 0
	paddingLeft.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	paddingLeft.Parent = contents

	local paddingCenter = Instance.new("Frame")
	paddingCenter.Name = "PaddingCenter"
	paddingCenter.LayoutOrder = 3
	paddingCenter.ZIndex = 5
	paddingCenter.Size = UDim2.new(0, 0, 1, 0)
	paddingCenter.BorderColor3 = Color3.fromRGB(0, 0, 0)
	paddingCenter.BackgroundTransparency = 1
	paddingCenter.BorderSizePixel = 0
	paddingCenter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	paddingCenter.Parent = contents

	local paddingRight = Instance.new("Frame")
	paddingRight.Name = "PaddingRight"
	paddingRight.LayoutOrder = 5
	paddingRight.ZIndex = 5
	paddingRight.Size = UDim2.new(0, 5, 1, 0)
	paddingRight.BorderColor3 = Color3.fromRGB(0, 0, 0)
	paddingRight.BackgroundTransparency = 1
	paddingRight.BorderSizePixel = 0
	paddingRight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	paddingRight.Parent = contents

	local iconLabelContainer = Instance.new("Frame")
	iconLabelContainer.Name = "IconLabelContainer"
	iconLabelContainer.LayoutOrder = 4
	iconLabelContainer.ZIndex = 3
	iconLabelContainer.AnchorPoint = Vector2.new(0, 0.5)
	iconLabelContainer.Size = UDim2.new(0, 0, 0.5, 0)
	iconLabelContainer.BackgroundTransparency = 1
	iconLabelContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
	iconLabelContainer.Parent = contents

	local iconLabel = Instance.new("TextLabel")
	local viewportX = workspace.CurrentCamera.ViewportSize.X+200
	iconLabel.Name = "IconLabel"
	iconLabel.LayoutOrder = 4
	iconLabel.ZIndex = 15
	iconLabel.AnchorPoint = Vector2.new(0, 0)
	iconLabel.Size = UDim2.new(0, viewportX, 1, 0)
	iconLabel.ClipsDescendants = false
	iconLabel.BackgroundTransparency = 1
	iconLabel.Position = UDim2.fromScale(0, 0)
	iconLabel.RichText = true
	iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	iconLabel.TextXAlignment = Enum.TextXAlignment.Left
	iconLabel.Text = ""
	iconLabel.TextWrapped = true
	iconLabel.TextWrap = true
	iconLabel.TextScaled = false
	iconLabel.Active = false
	iconLabel.AutoLocalize = true
	iconLabel.Parent = iconLabelContainer

	local iconImage = Instance.new("ImageLabel")
	iconImage.Name = "IconImage"
	iconImage.LayoutOrder = 2
	iconImage.ZIndex = 15
	iconImage.AnchorPoint = Vector2.new(0, 0.5)
	iconImage.Size = UDim2.new(0, 0, 0.5, 0)
	iconImage.BackgroundTransparency = 1
	iconImage.Position = UDim2.new(0, 11, 0.5, 0)
	iconImage.ScaleType = Enum.ScaleType.Stretch
	iconImage.Active = false
	iconImage.Parent = contents
	
	--
	local iconImageCorner = iconCorner:Clone()
	iconImageCorner.CornerRadius = UDim.new(0, 0)
	iconImageCorner.Name = "IconImageCorner"
	iconImageCorner.Parent = iconImage
	--]]
	
	local TweenService = game:GetService("TweenService")
	local updateCount = 0
	local resizingCount = 0
	local repeating = false
	local function handleLabelAndImageChanges(forceUpdateString)
		
		-- We defer changes by a frame to eliminate all but 1 requests which
		-- could otherwise stack up to 20+ requests in a single frame
		-- We then repeat again once to account for any final changes
		-- Deferring is also essential because properties are set immediately
		-- afterwards (therefore calculations will use the correct values)
		updateCount+= 1
		local myUpdateCount = updateCount
		task.defer(function()
			if updateCount ~= myUpdateCount and forceUpdateString ~= "FORCE_UPDATE" then
				if not repeating then
					repeating = true
					task.delay(0.01, function()
						handleLabelAndImageChanges()
						repeating = false
					end)
				end
				return
			end
			
			local usingText = iconLabel.Text ~= ""
			local usingImage = iconImage.Image ~= "" and iconImage.Image ~= nil
			local alignment = Enum.HorizontalAlignment.Center
			local NORMAL_BUTTON_SIZE = UDim2.fromScale(1, 1)
			local buttonSize = NORMAL_BUTTON_SIZE
			if usingImage and not usingText then
				iconLabelContainer.Visible = false
				iconImage.Visible = true
				paddingCenter.Visible = false
				paddingLeft.Visible = false
				paddingRight.Visible = false
			elseif not usingImage and usingText then
				iconLabelContainer.Visible = true
				iconImage.Visible = false
				paddingCenter.Visible = false
				paddingLeft.Visible = true
				paddingRight.Visible = true
			elseif usingImage and usingText then
				iconLabelContainer.Visible = true
				iconImage.Visible = true
				paddingCenter.Visible = true
				paddingLeft.Visible = true
				paddingRight.Visible = true
				alignment = Enum.HorizontalAlignment.Left
			end
			ContentsUIListLayout.HorizontalAlignment = alignment
			button.Size = buttonSize
			
			local function getItemWidth(item)
				local targetWidth = item:GetAttribute("TargetWidth") or item.AbsoluteSize.X
				return targetWidth
			end
			local initialWidgetWidth = 0
			local textWidth = iconLabel.TextBounds.X
			iconLabelContainer.Size = UDim2.new(0, textWidth, iconLabel.Size.Y.Scale, 0)
			for _, child in pairs(contents:GetChildren()) do
				if child:IsA("GuiObject") and child.Visible == true then
					initialWidgetWidth += getItemWidth(child) + ContentsUIListLayout.Padding.Offset
				end
			end
			local widgetMinimumWidth = widget:GetAttribute("MinimumWidth")
			local widgetMinimumHeight = widget:GetAttribute("MinimumHeight")
			local widgetBorderSize = widget:GetAttribute("BorderSize")
			local widgetWidth = math.clamp(initialWidgetWidth, widgetMinimumWidth, viewportX)
			local menuIcons = icon.menuIcons
			local additionalWidth = 0
			local hasMenu = #menuIcons > 0
			local showMenu = hasMenu and icon.isSelected
			if showMenu then
				for _, frame in pairs(iconHolder:GetChildren()) do
					if frame ~= iconSpot and frame:IsA("GuiObject") and frame.Visible then
						additionalWidth += getItemWidth(frame) + holderUIListLayout.Padding.Offset
					end
				end
				additionalWidth -= widgetBorderSize
				widgetWidth += additionalWidth
			end
			menuGap.Visible = showMenu
			local desiredWidth = widget:GetAttribute("DesiredWidth")
			if desiredWidth and widgetWidth < desiredWidth then
				widgetWidth = desiredWidth
			end
			
			local spotWidth = widgetWidth-additionalWidth-(widgetBorderSize*2)
			local style = Enum.EasingStyle.Quint
			local direction = Enum.EasingDirection.Out
			local spotWidthMax = math.max(spotWidth, getItemWidth(iconSpot), iconSpot.AbsoluteSize.X)
			local widgetWidthMax = math.max(widgetWidth, getItemWidth(widget), widget.AbsoluteSize.X)
			local SPEED = 750
			local spotTweenInfo = TweenInfo.new(spotWidthMax/SPEED, style, direction)
			local widgetTweenInfo = TweenInfo.new(widgetWidthMax/SPEED, style, direction)
			TweenService:Create(iconSpot, spotTweenInfo, {
				Position = UDim2.new(0, widgetBorderSize, 0.5, 0),
				Size = UDim2.new(0, spotWidth, 1, -widgetBorderSize*2),
			}):Play()
			TweenService:Create(clickRegion, spotTweenInfo, {
				Size = UDim2.new(0, spotWidth, 1, 0),
			}):Play()
			local newWidgetSize = UDim2.fromOffset(widgetWidth, widgetMinimumHeight)
			local updateInstantly = widget.Size.Y.Offset ~= widgetMinimumHeight
			if updateInstantly then
				widget.Size = newWidgetSize
			end
			widget:SetAttribute("TargetWidth", newWidgetSize.X.Offset)
			local movingTween = TweenService:Create(widget, widgetTweenInfo, {
				Size = newWidgetSize,
			})
			movingTween:Play()
			resizingCount += 1
			task.delay(widgetTweenInfo.Time-0.2, function()
				resizingCount -= 1
				task.defer(function()
					if resizingCount == 0 then
						icon.resizingComplete:Fire()
					end
				end)
			end)
			
			local parentIcon = icon.parentIcon
			if parentIcon then
				parentIcon.updateSize:Fire()
			end
			
		end)
	end
	local firstTimeSettingFontFace = true
	icon:setBehaviour("IconLabel", "Text", handleLabelAndImageChanges)
	icon:setBehaviour("IconLabel", "FontFace", function(value)
		local previousFontFace = iconLabel.FontFace
		if previousFontFace == value then
			return
		end
		task.spawn(function()
			--[[
			local fontLink = value.Family
			if string.match(fontLink, "rbxassetid://") then
				local ContentProvider = game:GetService("ContentProvider")
				local assets = {fontLink}
				ContentProvider:PreloadAsync(assets)
				print("FONT LOADED!!!")
			end--]]
			
			-- Afaik there's no way to determine when a Font Family has
			-- loaded (even with ContentProvider), so we just have to try
			-- a few times and hope it loads within the refresh period
			handleLabelAndImageChanges()
			if firstTimeSettingFontFace then
				firstTimeSettingFontFace = false
				for i = 1, 10 do
					task.wait(1)
					handleLabelAndImageChanges()
				end
			end
		end)
	end)
	local function updateBorderSize()
		task.defer(function()
			local borderOffset = widget:GetAttribute("BorderSize")
			local alignment = icon.alignment
			local alignmentOffset = (alignment == "Right" and -borderOffset) or borderOffset
			iconHolder.Position = UDim2.new(0, alignmentOffset, 0, 0)
			menuGap.Size = UDim2.fromOffset(borderOffset, 0)
			holderUIListLayout.Padding = UDim.new(0, 0)
			handleLabelAndImageChanges()
		end)
	end
	icon.updateSize:Connect(handleLabelAndImageChanges)
	icon:setBehaviour("Widget", "Visible", handleLabelAndImageChanges)
	icon:setBehaviour("Widget", "DesiredWidth", handleLabelAndImageChanges)
	icon:setBehaviour("Widget", "MinimumWidth", handleLabelAndImageChanges)
	icon:setBehaviour("Widget", "MinimumHeight", handleLabelAndImageChanges)
	icon:setBehaviour("Widget", "BorderSize", updateBorderSize)
	icon:setBehaviour("IconImageRatio", "AspectRatio", handleLabelAndImageChanges)
	icon:setBehaviour("IconImage", "Image", function(value)
		local textureId = (tonumber(value) and "http://www.roblox.com/asset/?id="..value) or value or ""
		if iconImage.Image ~= textureId then
			handleLabelAndImageChanges()
		end
		return textureId
	end)
	icon.alignmentChanged:Connect(function(newAlignment)
		if newAlignment == "Center" then
			newAlignment = "Left"
		end
		holderUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment[newAlignment]
		updateBorderSize()
	end)

	local iconImageScale = Instance.new("NumberValue")
	iconImageScale.Name = "IconImageScale"
	iconImageScale.Parent = iconImage
	iconImageScale:GetPropertyChangedSignal("Value"):Connect(function()
		iconImage.Size = UDim2.new(0, 0, iconImageScale.Value, 0)
	end)

	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	UIAspectRatioConstraint.Name = "IconImageRatio"
	UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize
	UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
	UIAspectRatioConstraint.Parent = iconImage

	local iconGradient = Instance.new("UIGradient")
	iconGradient.Name = "IconGradient"
	iconGradient.Enabled = true
	iconGradient.Parent = button
	
	local iconSpotGradient = Instance.new("UIGradient")
	iconSpotGradient.Name = "IconSpotGradient"
	iconSpotGradient.Enabled = true
	iconSpotGradient.Parent = iconSpot
	
	local notice = Instance.new("Frame")
	notice.Name = "Notice"
	notice.ZIndex = 25
	notice.AutomaticSize = Enum.AutomaticSize.X
	notice.Size = UDim2.new(0, 20, 0, 20)
	notice.BorderColor3 = Color3.fromRGB(0, 0, 0)
	notice.Position = UDim2.new(1, -12, 0, -1)
	notice.BorderSizePixel = 0
	notice.BackgroundTransparency = 0.1
	notice.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	notice.Visible = false
	notice.Parent = widget

	local noticeLabel = Instance.new("TextLabel")
	noticeLabel.Name = "NoticeLabel"
	noticeLabel.ZIndex = 26
	noticeLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	noticeLabel.AutomaticSize = Enum.AutomaticSize.X
	noticeLabel.Size = UDim2.new(1, 0, 1, 0)
	noticeLabel.BackgroundTransparency = 1
	noticeLabel.Position = UDim2.new(0.5, 0, 0.515, 0)
	noticeLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	noticeLabel.FontSize = Enum.FontSize.Size14
	noticeLabel.TextSize = 13
	noticeLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
	noticeLabel.Text = "1"
	noticeLabel.TextWrapped = true
	noticeLabel.TextWrap = true
	noticeLabel.Font = Enum.Font.Arial
	noticeLabel.Parent = notice
	icon.noticeChanged:Connect(function(totalNotices)
		
		-- Notice amount
		if not totalNotices then
			return
		end
		local noticeDisplay = (totalNotices < 100 and totalNotices) or "99+"
		noticeLabel.Text = noticeDisplay
		
		-- Should enable
		local enabled = true
		if totalNotices < 1 then
			enabled = false
		end
		local parentIcon = icon.parentIcon
		local dropdownOrMenuActive = #icon.dropdownIcons > 0 or #icon.menuIcons > 0
		if icon.isSelected and dropdownOrMenuActive then
			enabled = false
		elseif parentIcon and not parentIcon.isSelected then
			enabled = false
		end
		notice.Visible = enabled
		
	end)

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = notice
	
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Parent = notice

	return widget
end end,
    [10] = function()local maui,script,require,getfenv,setfenv=ImportGlobals(10)return function(icon)

	local dropdown = Instance.new("Frame")
	dropdown.Name = "Dropdown"
	dropdown.AutomaticSize = Enum.AutomaticSize.XY
	dropdown.BackgroundTransparency = 1
	dropdown.BorderSizePixel = 0
	dropdown.AnchorPoint = Vector2.new(0.5, 0)
	dropdown.Position = UDim2.new(0.5, 0, 1, 8)
	dropdown.ZIndex = -2
	dropdown.ClipsDescendants = true
	dropdown.Visible = true
	dropdown.Selectable = false
	dropdown.Active = false

	local UICorner = Instance.new("UICorner")
	UICorner.Name = "DropdownCorner"
	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = dropdown

	local dropdownHolder = Instance.new("ScrollingFrame")
	dropdownHolder.Name = "DropdownHolder"
	dropdownHolder.AutomaticSize = Enum.AutomaticSize.XY
	dropdownHolder.BackgroundTransparency = 1
	dropdownHolder.BorderSizePixel = 0
	dropdownHolder.AnchorPoint = Vector2.new(0, 0)
	dropdownHolder.Position = UDim2.new(0, 0, 0, 0)
	dropdownHolder.Size = UDim2.new(1, 0, 1, 0)
	dropdownHolder.ZIndex = -1
	dropdownHolder.ClipsDescendants = false
	dropdownHolder.Visible = true
	dropdownHolder.TopImage = dropdownHolder.MidImage
	dropdownHolder.BottomImage = dropdownHolder.MidImage
	dropdownHolder.VerticalScrollBarInset = Enum.ScrollBarInset.Always
	dropdownHolder.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
	dropdownHolder.Parent = dropdown
	dropdownHolder.Active = false
	dropdownHolder.Selectable = false
	dropdownHolder.ScrollingEnabled = false

	local dropdownList = Instance.new("UIListLayout")
	dropdownList.Name = "DropdownList"
	dropdownList.FillDirection = Enum.FillDirection.Vertical
	dropdownList.SortOrder = Enum.SortOrder.LayoutOrder
	dropdownList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	dropdownList.HorizontalFlex = Enum.UIFlexAlignment.SpaceEvenly
	dropdownList.Parent = dropdownHolder

	local dropdownPadding = Instance.new("UIPadding")
	dropdownPadding.Name = "DropdownPadding"
	dropdownPadding.PaddingTop = UDim.new(0, 8)
	dropdownPadding.PaddingBottom = UDim.new(0, 8)
	dropdownPadding.Parent = dropdownHolder

	local dropdownJanitor = icon.dropdownJanitor
	local function updatePosition()
		-- To complete: this currently does not account for
		-- exceeding the minimum or maximum boundaries of the screen
	end
	dropdownJanitor:add(icon.widget:GetPropertyChangedSignal("AbsolutePosition"):Connect(updatePosition))

	return dropdown
end end,
    [11] = function()local maui,script,require,getfenv,setfenv=ImportGlobals(11)return function(icon)

	local menuContainer = Instance.new("Frame")
	menuContainer.Name = "MenuContainer"
	menuContainer.BackgroundTransparency = 1
	menuContainer.BorderSizePixel = 0
	menuContainer.AnchorPoint = Vector2.new(1, 0)
	menuContainer.Size = UDim2.new(0, 500, 0, 50)
	menuContainer.ZIndex = -2
	menuContainer.ClipsDescendants = true
	menuContainer.Visible = true
	menuContainer.Active = false
	menuContainer.Selectable = false

	local menuFrame = Instance.new("ScrollingFrame")
	menuFrame.Name = "MenuFrame"
	menuFrame.BackgroundTransparency = 1
	menuFrame.BorderSizePixel = 0
	menuFrame.AnchorPoint = Vector2.new(0, 0)
	menuFrame.Position = UDim2.new(0, 0, 0, 0)
	menuFrame.Size = UDim2.new(1, 0, 1, 0)
	menuFrame.ZIndex = -1 + 10
	menuFrame.ClipsDescendants = false
	menuFrame.Visible = true
	menuFrame.TopImage = ""--menuFrame.MidImage
	menuFrame.BottomImage = ""--menuFrame.MidImage
	menuFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.Always
	menuFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	menuFrame.Parent = menuContainer
	menuFrame.Active = false
	menuFrame.Selectable = false
	menuFrame.ScrollingEnabled = false

	local menuList = Instance.new("UIListLayout")
	menuList.Name = "MenuList"
	menuList.FillDirection = Enum.FillDirection.Horizontal
	menuList.HorizontalAlignment = Enum.HorizontalAlignment.Right
	menuList.SortOrder = Enum.SortOrder.LayoutOrder
	menuList.Parent = menuFrame

	local menuInvisBlocker = Instance.new("Frame")
	menuInvisBlocker.Name = "MenuInvisBlocker"
	menuInvisBlocker.BackgroundTransparency = 1
	menuInvisBlocker.Size = UDim2.new(0, -2, 1, 0)
	menuInvisBlocker.Visible = true
	menuInvisBlocker.LayoutOrder = 999999999
	menuInvisBlocker.Parent = menuFrame
	menuInvisBlocker.Active = false
	
	return menuContainer
end end,
    [12] = function()local maui,script,require,getfenv,setfenv=ImportGlobals(12)return function(icon)

	-- Credit to lolmansReturn and Canary Software for
	-- retrieving these values
	local caption = Instance.new("CanvasGroup")
	caption.Name = "Caption"
	caption.AnchorPoint = Vector2.new(0.5, 0)
	caption.AutomaticSize = Enum.AutomaticSize.XY
	caption.BackgroundTransparency = 1
	caption.BorderSizePixel = 0
	caption.GroupTransparency = 1
	caption.Position = UDim2.fromOffset(0, 0)
	caption.Size = UDim2.fromOffset(32, 53)
	caption.Visible = true
	caption.Parent = icon.widget

	local box = Instance.new("Frame")
	box.Name = "Box"
	box.AutomaticSize = Enum.AutomaticSize.XY
	box.BackgroundColor3 = Color3.fromRGB(101, 102, 104)
	box.Position = UDim2.fromOffset(4, 7)
	box.ZIndex = 12
	box.Parent = caption

	local header = Instance.new("TextLabel")
	header.Name = "Header"
	header.FontFace = Font.new(
		"rbxasset://fonts/families/GothamSSm.json",
		Enum.FontWeight.Medium,
		Enum.FontStyle.Normal
	)
	header.Text = "Caption"
	header.TextColor3 = Color3.fromRGB(255, 255, 255)
	header.TextSize = 14
	header.TextTruncate = Enum.TextTruncate.None
	header.TextWrapped = false
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.AutomaticSize = Enum.AutomaticSize.X
	header.BackgroundTransparency = 1
	header.LayoutOrder = 1
	header.Size = UDim2.fromOffset(0, 16)
	header.ZIndex = 18
	header.Parent = box

	local layout = Instance.new("UIListLayout")
	layout.Name = "Layout"
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = box

	local UICorner = Instance.new("UICorner")
	UICorner.Name = "CaptionCorner"
	UICorner.Parent = box

	local padding = Instance.new("UIPadding")
	padding.Name = "Padding"
	padding.PaddingBottom = UDim.new(0, 12)
	padding.PaddingLeft = UDim.new(0, 12)
	padding.PaddingRight = UDim.new(0, 12)
	padding.PaddingTop = UDim.new(0, 12)
	padding.Parent = box

	local hotkeys = Instance.new("Frame")
	hotkeys.Name = "Hotkeys"
	hotkeys.AutomaticSize = Enum.AutomaticSize.Y
	hotkeys.BackgroundTransparency = 1
	hotkeys.LayoutOrder = 3
	hotkeys.Size = UDim2.fromScale(1, 0)
	hotkeys.Visible = false
	hotkeys.Parent = box

	local layout1 = Instance.new("UIListLayout")
	layout1.Name = "Layout1"
	layout1.Padding = UDim.new(0, 6)
	layout1.FillDirection = Enum.FillDirection.Vertical
	layout1.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout1.HorizontalFlex = Enum.UIFlexAlignment.None
	layout1.ItemLineAlignment = Enum.ItemLineAlignment.Automatic
	layout1.VerticalFlex = Enum.UIFlexAlignment.None
	layout1.SortOrder = Enum.SortOrder.LayoutOrder
	layout1.Parent = hotkeys

	local keyTag1 = Instance.new("ImageLabel")
	keyTag1.Name = "Key1"
	keyTag1.Image = "rbxasset://textures/ui/Controls/key_single.png"
	keyTag1.ImageTransparency = 0.7
	keyTag1.ScaleType = Enum.ScaleType.Slice
	keyTag1.SliceCenter = Rect.new(5, 5, 23, 24)
	keyTag1.AutomaticSize = Enum.AutomaticSize.X
	keyTag1.BackgroundTransparency = 1
	keyTag1.LayoutOrder = 1
	keyTag1.Size = UDim2.fromOffset(0, 30)
	keyTag1.ZIndex = 15
	keyTag1.Parent = hotkeys

	local inset = Instance.new("UIPadding")
	inset.Name = "Inset"
	inset.PaddingLeft = UDim.new(0, 8)
	inset.PaddingRight = UDim.new(0, 8)
	inset.Parent = keyTag1

	local labelContent = Instance.new("TextLabel")
	labelContent.Name = "LabelContent"
	labelContent.FontFace = Font.new(
		"rbxasset://fonts/families/GothamSSm.json",
		Enum.FontWeight.Medium,
		Enum.FontStyle.Normal
	)
	labelContent.Text = ""
	labelContent.TextColor3 = Color3.fromRGB(189, 190, 190)
	labelContent.TextSize = 14
	labelContent.AutomaticSize = Enum.AutomaticSize.X
	labelContent.BackgroundTransparency = 1
	labelContent.Position = UDim2.fromOffset(0, -1)
	labelContent.Size = UDim2.fromScale(1, 1)
	labelContent.ZIndex = 16
	labelContent.Parent = keyTag1

	local caret = Instance.new("ImageLabel")
	caret.Name = "Caret"
	caret.Image = "rbxasset://LuaPackages/Packages/_Index/UIBlox/UIBlox/AppImageAtlas/img_set_1x_1.png"
	caret.ImageColor3 = Color3.fromRGB(101, 102, 104)
	caret.ImageRectOffset = Vector2.new(260, 440)
	caret.ImageRectSize = Vector2.new(16, 8)
	caret.AnchorPoint = Vector2.new(0.5, 0.5)
	caret.BackgroundTransparency = 1
	caret.Position = UDim2.new(0.5, 0, 0, 4)
	caret.Rotation = 180
	caret.Size = UDim2.fromOffset(16, 8)
	caret.ZIndex = 12
	caret.Parent = caption

	local dropShadow = Instance.new("ImageLabel")
	dropShadow.Name = "DropShadow"
	dropShadow.Image = "rbxasset://LuaPackages/Packages/_Index/UIBlox/UIBlox/AppImageAtlas/img_set_1x_1.png"
	dropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	dropShadow.ImageRectOffset = Vector2.new(217, 486)
	dropShadow.ImageRectSize = Vector2.new(25, 25)
	dropShadow.ImageTransparency = 0.5
	dropShadow.ScaleType = Enum.ScaleType.Slice
	dropShadow.SliceCenter = Rect.new(12, 12, 13, 13)
	dropShadow.BackgroundTransparency = 1
	dropShadow.Position = UDim2.fromOffset(0, 5)
	dropShadow.Size = UDim2.new(1, 0, 0, 48)
	dropShadow.Parent = caption
	
	-- This handles the appearing/disappearing/positioning of the caption
	local widget = icon.widget
	local captionJanitor = icon.captionJanitor
	local captionHeader = caption.Box.Header
	caption:GetAttributeChangedSignal("CaptionText"):Connect(function()
		local text = caption:GetAttribute("CaptionText")
		captionHeader.Text = text
	end)

	local EASING_STYLE = Enum.EasingStyle.Quad
	local TWEEN_SPEED = 0.2
	local TWEEN_INFO_IN = TweenInfo.new(TWEEN_SPEED, EASING_STYLE, Enum.EasingDirection.In)
	local TWEEN_INFO_OUT = TweenInfo.new(TWEEN_SPEED, EASING_STYLE, Enum.EasingDirection.Out)
	local TweenService = game:GetService("TweenService")
	local captionCaret = caption.Caret
	local isCompletelyEnabled = false
	local function getCaptionPosition(customEnabled)
		local enabled = customEnabled or isCompletelyEnabled
		local yOffset = if enabled then 4 else -2
		return UDim2.new(0, (widget.AbsoluteSize.X/2), 1, yOffset)
	end
	local function updatePosition(updateWithTween, forcedEnabled)
		-- Currently the one thing which isn't accounted for are the bounds of the screen
		-- This would be an issue if someone sets a long caption text for the left or
		-- right most icon
		local enabled = forcedEnabled or isCompletelyEnabled
		local incomingCaptionPosition = getCaptionPosition()
		local captionY = incomingCaptionPosition.Y
		local newCaptionPosition = UDim2.new(0.5, 0, captionY.Scale, captionY.Offset)
		if updateWithTween ~= true then
			caption.Position = newCaptionPosition
			return
		end
		local tweenInfo = (enabled and TWEEN_INFO_IN) or TWEEN_INFO_OUT
		local slideTween = TweenService:Create(caption, tweenInfo, {Position = newCaptionPosition})
		slideTween:Play()
	end
	captionJanitor:add(widget:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
		updatePosition()
	end))
	captionJanitor:add(widget:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		updatePosition()
	end))
	updatePosition(nil, false)

	local function updateHotkey(keyCodeEnum)
		labelContent.Text = keyCodeEnum.Name
		hotkeys.Visible = true
	end
	captionJanitor:add(icon.toggleKeyAdded:Connect(updateHotkey))
	for keyCodeEnum, _ in pairs(icon.bindedToggleKeys) do
		updateHotkey(keyCodeEnum)
		break
	end

	local function setCaptionEnabled(enabled)
		if isCompletelyEnabled == enabled then
			return
		end
		local joinedFrame = icon.joinedFrame
		if joinedFrame and string.match(joinedFrame.Name, "Dropdown") then
			enabled = false
		end
		isCompletelyEnabled = enabled
		local newTransparency = (enabled and 0) or 1
		local tweenInfo = (enabled and TWEEN_INFO_IN) or TWEEN_INFO_OUT
		local tweenTransparency = TweenService:Create(caption, tweenInfo, {
			GroupTransparency = newTransparency
		})
		tweenTransparency:Play()
		updatePosition(true)
	end
	
	local WAIT_DURATION = 0.5
	local RECOVER_PERIOD = 0.3
	local Icon = icon.Icon
	captionJanitor:add(icon.stateChanged:Connect(function(stateName)
		if stateName == "Hovering" then
			local lastClock = Icon.captionLastClosedClock
			local clockDifference = (lastClock and os.clock() - lastClock) or 999
			local waitDuration = (clockDifference < RECOVER_PERIOD and 0) or WAIT_DURATION
			task.delay(waitDuration, function()
				if icon.activeState == "Hovering" then
					setCaptionEnabled(true)
				end
			end)
		else
			Icon.captionLastClosedClock = os.clock()
			setCaptionEnabled(false)
		end
	end))
	
	return caption
end end,
    [14] = function()local maui,script,require,getfenv,setfenv=ImportGlobals(14)return {
	
	
	-- How items appear when the icon is deselected (i.e. its default state)
	Deselected = {
		{"Widget", "MinimumWidth", 44},
		{"Widget", "MinimumHeight", 44},
		{"Widget", "BorderSize", 4},
		{"IconCorners", "CornerRadius", UDim.new(1, 0)},
		{"IconButton", "BackgroundColor3", Color3.fromRGB(0, 0, 0)},
		{"IconButton", "BackgroundTransparency", 0.3},
		{"IconImageScale", "Value", 0.5},
		{"IconImageCorner", "CornerRadius", UDim.new(0, 0)},
		{"IconImage", "ImageColor3", Color3.fromRGB(255, 255, 255)},
		{"IconImage", "ImageTransparency", 0},
		{"IconImage", "Image", ""},
		{"IconLabel", "FontFace", Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)},
		{"IconLabel", "Text", ""},
		{"IconLabel", "TextSize", 16},
		{"IconLabel", "Position", UDim2.fromOffset(0, -1)},
		{"IconSpot", "BackgroundTransparency", 1},
		{"IconOverlay", "BackgroundTransparency", 0.925},
		{"IconSpotGradient", "Enabled", false},
		{"IconGradient", "Enabled", false},
		{"Dropdown", "BackgroundColor3", Color3.fromRGB(0, 0, 0)},
		{"Dropdown", "BackgroundTransparency", 0.3},
	},
	
	
	-- How items appear when the icon is selected
	Selected = {
		{"IconSpot", "BackgroundTransparency", 0.7},
		{"IconSpot", "BackgroundColor3", Color3.fromRGB(255, 255, 255)},
		{"IconSpotGradient", "Enabled", true},
		{"IconSpotGradient", "Rotation", 45},
		{"IconSpotGradient", "Color", ColorSequence.new(Color3.fromRGB(96, 98, 100), Color3.fromRGB(77, 78, 80))},
	},
	
	-- How items appear when a cursor is above (but not pressing) the frame, or when focused with a controller
	Hovering = {
		
	},
	
	
	-- How items appear when the icon is initially clicked until released
	Pressing = {
		
	},
	
} end,
    [15] = function()local maui,script,require,getfenv,setfenv=ImportGlobals(15)-- LOCAL
local Utility = {}
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer



-- FUNCTIONS
function Utility.copyTable(t)
	-- Credit to Stephen Leitnick (September 13, 2017) for this function from TableUtil
	assert(type(t) == "table", "First argument must be a table")
	local tCopy = table.create(#t)
	for k,v in pairs(t) do
		if (type(v) == "table") then
			tCopy[k] = Utility.copyTable(v)
		else
			tCopy[k] = v
		end
	end
	return tCopy
end

function Utility.formatStateName(incomingStateName)
	return string.upper(string.sub(incomingStateName, 1, 1))..string.lower(string.sub(incomingStateName, 2))
end

function Utility.localPlayerRespawned(callback)
	-- The client localscript may be located under a ScreenGui with ResetOnSpawn set to true
	-- In these scenarios, traditional methods like CharacterAdded won't be called by the
	-- time the localscript has been destroyed, therefore we listen for died instead
	task.spawn(function()
		local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
		local humanoid
		for i = 1, 5 do
			humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				break
			end
			task.wait(1)
		end
		if humanoid then
			humanoid.Died:Once(function()
				task.delay(Players.RespawnTime-0.1, function()
					callback()
				end)

			end)
		end
	end)
end



return Utility
 end
} -- [RefId] = Closure

-- Set up from data
do
    -- Localizing certain libraries and built-ins for runtime efficiency
    local task, setmetatable, error, newproxy, getmetatable, next, table, unpack, coroutine, script, type, require, pcall, getfenv, setfenv, rawget= task, setmetatable, error, newproxy, getmetatable, next, table, unpack, coroutine, script, type, require, pcall, getfenv, setfenv, rawget

    local table_insert = table.insert
    local table_remove = table.remove

    -- lol
    local table_freeze = table.freeze or function(t) return t end

    -- If we're not running on Roblox or Lune runtime, we won't have a task library
    local Defer = task and task.defer or function(f, ...)
        local Thread = coroutine.create(f)
        coroutine.resume(Thread, ...)
        return Thread
    end

    -- `maui.Version` compat
    local Version = "0.0.0-venv"

    local RefBindings = {} -- [RefId] = RealObject

    local ScriptClosures = {}
    local StoredModuleValues = {}
    local ScriptsToRun = {}

    -- maui.Shared
    local SharedEnvironment = {}

    -- We're creating 'fake' instance refs soley for traversal of the DOM for require() compatibility
    -- It's meant to be as lazy as possible lol
    local RefChildren = {} -- [Ref] = {ChildrenRef, ...}

    -- Implemented instance methods
    local InstanceMethods = {
        GetChildren = function(self)
            local Children = RefChildren[self]
            local ReturnArray = {}
    
            for Child in next, Children do
                table_insert(ReturnArray, Child)
            end
    
            return ReturnArray
        end,

        -- Not implementing `recursive` arg, as it isn't needed for us here
        FindFirstChild = function(self, name)
            if not name then
                error("Argument 1 missing or nil", 2)
            end

            for Child in next, RefChildren[self] do
                if Child.Name == name then
                    return Child
                end
            end

            return
        end,

        GetFullName = function(self)
            local Path = self.Name
            local ObjectPointer = self.Parent

            while ObjectPointer do
                Path = ObjectPointer.Name .. "." .. Path

                -- Move up the DOM (parent will be nil at the end, and this while loop will stop)
                ObjectPointer = ObjectPointer.Parent
            end

            return "VirtualEnv." .. Path
        end,
    }

    -- "Proxies" to instance methods, with err checks etc
    local InstanceMethodProxies = {}
    for MethodName, Method in next, InstanceMethods do
        InstanceMethodProxies[MethodName] = function(self, ...)
            if not RefChildren[self] then
                error("Expected ':' not '.' calling member function " .. MethodName, 1)
            end

            return Method(self, ...)
        end
    end

    local function CreateRef(className, name, parent)
        -- `name` and `parent` can also be set later by the init script if they're absent

        -- Extras
        local StringValue_Value

        -- Will be set to RefChildren later aswell
        local Children = setmetatable({}, {__mode = "k"})

        -- Err funcs
        local function InvalidMember(member)
            error(member .. " is not a valid (virtual) member of " .. className .. " \"" .. name .. "\"", 1)
        end

        local function ReadOnlyProperty(property)
            error("Unable to assign (virtual) property " .. property .. ". Property is read only", 1)
        end

        local Ref = newproxy(true)
        local RefMetatable = getmetatable(Ref)

        RefMetatable.__index = function(_, index)
            if index == "ClassName" then -- First check "properties"
                return className
            elseif index == "Name" then
                return name
            elseif index == "Parent" then
                return parent
            elseif className == "StringValue" and index == "Value" then
                -- Supporting StringValue.Value for Rojo .txt file conv
                return StringValue_Value
            else -- Lastly, check "methods"
                local InstanceMethod = InstanceMethodProxies[index]

                if InstanceMethod then
                    return InstanceMethod
                end
            end

            -- Next we'll look thru child refs
            for Child in next, Children do
                if Child.Name == index then
                    return Child
                end
            end

            -- At this point, no member was found; this is the same err format as Roblox
            InvalidMember(index)
        end

        RefMetatable.__newindex = function(_, index, value)
            -- __newindex is only for props fyi
            if index == "ClassName" then
                ReadOnlyProperty(index)
            elseif index == "Name" then
                name = value
            elseif index == "Parent" then
                -- We'll just ignore the process if it's trying to set itself
                if value == Ref then
                    return
                end

                if parent ~= nil then
                    -- Remove this ref from the CURRENT parent
                    RefChildren[parent][Ref] = nil
                end

                parent = value

                if value ~= nil then
                    -- And NOW we're setting the new parent
                    RefChildren[value][Ref] = true
                end
            elseif className == "StringValue" and index == "Value" then
                -- Supporting StringValue.Value for Rojo .txt file conv
                StringValue_Value = value
            else
                -- Same err as __index when no member is found
                InvalidMember(index)
            end
        end

        RefMetatable.__tostring = function()
            return name
        end

        RefChildren[Ref] = Children

        if parent ~= nil then
            RefChildren[parent][Ref] = true
        end

        return Ref
    end

    -- Create real ref DOM from object tree
    local function CreateRefFromObject(object, parent)
        local RefId = object[1]
        local ClassName = object[2]
        local Properties = object[3]
        local Children = object[4] -- Optional

        local Name = table_remove(Properties, 1)

        local Ref = CreateRef(ClassName, Name, parent) -- 3rd arg may be nil if this is from root
        RefBindings[RefId] = Ref

        if Properties then
            for PropertyName, PropertyValue in next, Properties do
                Ref[PropertyName] = PropertyValue
            end
        end

        if Children then
            for _, ChildObject in next, Children do
                CreateRefFromObject(ChildObject, Ref)
            end
        end

        return Ref
    end

    local RealObjectRoot = {}
    for _, Object in next, ObjectTree do
        table_insert(RealObjectRoot, CreateRefFromObject(Object))
    end

    -- Now we'll set script closure refs and check if they should be ran as a BaseScript
    for RefId, Closure in next, ClosureBindings do
        local Ref = RefBindings[RefId]

        ScriptClosures[Ref] = Closure

        local ClassName = Ref.ClassName
        if ClassName == "LocalScript" or ClassName == "Script" then
            table_insert(ScriptsToRun, Ref)
        end
    end

    local function LoadScript(scriptRef)
        local ScriptClassName = scriptRef.ClassName

        -- First we'll check for a cached module value (packed into a tbl)
        local StoredModuleValue = StoredModuleValues[scriptRef]
        if StoredModuleValue and ScriptClassName == "ModuleScript" then
            return unpack(StoredModuleValue)
        end

        local Closure = ScriptClosures[scriptRef]
        if not Closure then
            return
        end

        -- If it's a BaseScript, we'll just run it directly!
        if ScriptClassName == "LocalScript" or ScriptClassName == "Script" then
            Closure()
            return
        else
            local ClosureReturn = {Closure()}
            StoredModuleValues[scriptRef] = ClosureReturn
            return unpack(ClosureReturn)
        end
    end

    -- We'll assign the actual func from the top of this output for flattening user globals at runtime
    -- Returns (in a tuple order): maui, script, require, getfenv, setfenv
    function ImportGlobals(refId)
        local ScriptRef = RefBindings[refId]

        local Closure = ScriptClosures[ScriptRef]
        if not Closure then
            return
        end

        -- This will be set right after the other global funcs, it's for handling proper behavior when
        -- getfenv/setfenv is called and safeenv needs to be disabled
        local EnvHasBeenSet = false
        local RealEnv
        local VirtualEnv
        local SetEnv

        local Global_maui = table_freeze({
            Version = Version,
            Script = script, -- The actual script object for the script this is running on, not a fake ref
            Shared = SharedEnvironment,

            -- For compatibility purposes..
            GetScript = function()
                return script
            end,
            GetShared = function()
                return SharedEnvironment
            end,
        })

        local Global_script = ScriptRef

        local function Global_require(module, ...)
            if RefChildren[module] and module.ClassName == "ModuleScript" and ScriptClosures[module] then
                return LoadScript(module)
            end

            return require(module, ...)
        end

        -- Calling these flattened getfenv/setfenv functions will disable safeenv for the WHOLE SCRIPT
        local function Global_getfenv(stackLevel, ...)
            -- Now we have to set the env for the other variables used here to be valid
            if not EnvHasBeenSet then
                SetEnv()
            end

            if type(stackLevel) == "number" and stackLevel >= 0 then
                if stackLevel == 0 then
                    return VirtualEnv
                else
                    -- Offset by 1 for the actual env
                    stackLevel = stackLevel + 1

                    local GetOk, FunctionEnv = pcall(getfenv, stackLevel)
                    if GetOk and FunctionEnv == RealEnv then
                        return VirtualEnv
                    end
                end
            end

            return getfenv(stackLevel, ...)
        end

        local function Global_setfenv(stackLevel, newEnv, ...)
            if not EnvHasBeenSet then
                SetEnv()
            end

            if type(stackLevel) == "number" and stackLevel >= 0 then
                if stackLevel == 0 then
                    return setfenv(VirtualEnv, newEnv)
                else
                    stackLevel = stackLevel + 1

                    local GetOk, FunctionEnv = pcall(getfenv, stackLevel)
                    if GetOk and FunctionEnv == RealEnv then
                        return setfenv(VirtualEnv, newEnv)
                    end
                end
            end

            return setfenv(stackLevel, newEnv, ...)
        end

        -- From earlier, will ONLY be set if needed
        function SetEnv()
            RealEnv = getfenv(0)

            local GlobalEnvOverride = {
                ["maui"] = Global_maui,
                ["script"] = Global_script,
                ["require"] = Global_require,
                ["getfenv"] = Global_getfenv,
                ["setfenv"] = Global_setfenv,
            }

            VirtualEnv = setmetatable({}, {
                __index = function(_, index)
                    local IndexInVirtualEnv = rawget(VirtualEnv, index)
                    if IndexInVirtualEnv ~= nil then
                        return IndexInVirtualEnv
                    end

                    local IndexInGlobalEnvOverride = GlobalEnvOverride[index]
                    if IndexInGlobalEnvOverride ~= nil then
                        return IndexInGlobalEnvOverride
                    end

                    return RealEnv[index]
                end
            })

            setfenv(Closure, VirtualEnv)
            EnvHasBeenSet = true
        end

        -- Now, return flattened globals ready for direct runtime exec
        return Global_maui, Global_script, Global_require, Global_getfenv, Global_setfenv
    end

    for _, ScriptRef in next, ScriptsToRun do
        Defer(LoadScript, ScriptRef)
    end

    -- If there's a "MainModule" top-level modulescript, we'll return it from the output's closure directly
    do
        local MainModule
        for _, Ref in next, RealObjectRoot do
            if Ref.ClassName == "ModuleScript" and Ref.Name == "Icon" then
                MainModule = Ref
                break
            end
        end

        if MainModule then
            return LoadScript(MainModule)
        end
    end

    -- If any scripts are currently running now from task scheduler, the scope won't close until all running threads are closed
    -- (thanks for coming to my ted talk)
end

