--[[
    Fluent Interface Suite
    This script is not intended to be modified.
    To view the source code, see the 'src' folder on GitHub!

    Author: dawid
    License: MIT
    GitHub: https://github.com/dawid-scripts/Fluent
	
	This Fluent Edit By Ayaya ;>
	And No Minify Code But Normaly It Not Make For Edit If Need U Dm Me For a little Help ;>
--]]

-- Will be used later for getting flattened globals
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
                5,
                "ModuleScript",
                {
                    "Themes"
                },
                {
                    {
                        6,
                        "ModuleScript",
                        {
                            "Default"
                        }
                    },
                    {
                        7,
                        "ModuleScript",
                        {
                            "BlueGradient"
                        }
                    }
                }
            },
            {
                10,
                "ModuleScript",
                {
                    "IconController"
                }
            },
            {
                8,
                "ModuleScript",
                {
                    "Signal"
                }
            },
            {
                9,
                "ModuleScript",
                {
                    "Maid"
                }
            },
            {
                4,
                "ModuleScript",
                {
                    "TopbarPlusGui"
                }
            },
            {
                3,
                "ModuleScript",
                {
                    "TopbarPlusReference"
                }
            },
            {
                2,
                "ModuleScript",
                {
                    "VERSION"
                }
            }
        }
    }
}

-- Holds direct closure data
local ClosureBindings = {
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(1)-- LOCAL
local LocalizationService = game:GetService("LocalizationService")
local tweenService = game:GetService("TweenService")
local debris = game:GetService("Debris")
local userInputService = game:GetService("UserInputService")
local httpService = game:GetService("HttpService") -- This is to generate GUIDs
local runService = game:GetService("RunService")
local textService = game:GetService("TextService")
local starterGui = game:GetService("StarterGui")
local guiService = game:GetService("GuiService")
local localizationService = game:GetService("LocalizationService")
local playersService = game:GetService("Players")
local localPlayer = playersService.LocalPlayer
local iconModule = script
local TopbarPlusReference = require(iconModule.TopbarPlusReference)
local referenceObject = TopbarPlusReference.getObject()
local leadPackage = referenceObject and referenceObject.Value
if leadPackage and leadPackage ~= iconModule then
	return require(leadPackage)
end
if not referenceObject then
    TopbarPlusReference.addToReplicatedStorage()
end
local Icon = {}
Icon.__index = Icon
local IconController = require(iconModule.IconController)
local Signal = require(iconModule.Signal)
local Maid = require(iconModule.Maid)
local TopbarPlusGui = require(iconModule.TopbarPlusGui)
local Themes = require(iconModule.Themes)
local activeItems = TopbarPlusGui.ActiveItems
local topbarContainer = TopbarPlusGui.TopbarContainer
local iconTemplate = topbarContainer["IconContainer"]
local DEFAULT_THEME = Themes.Default
local THUMB_OFFSET = 55
local DEFAULT_FORCED_GROUP_VALUES = {}



-- CONSTRUCTORS
function Icon.new()
	local self = {}
	setmetatable(self, Icon)

	-- Maids (for autocleanup)
	local maid = Maid.new()
	self._maid = maid
	self._hoveringMaid = maid:give(Maid.new())
	self._dropdownClippingMaid = maid:give(Maid.new())
	self._menuClippingMaid = maid:give(Maid.new())

	-- These are the GuiObjects that make up the icon
	local instances = {}
	self.instances = instances
	local iconContainer = maid:give(iconTemplate:Clone())
	iconContainer.Visible = true
	iconContainer.Parent = topbarContainer
	instances["iconContainer"] = iconContainer
	instances["iconButton"] = iconContainer.IconButton
	instances["iconImage"] = instances.iconButton.IconImage
	instances["iconLabel"] = instances.iconButton.IconLabel
	instances["fakeIconLabel"] = instances.iconButton.FakeIconLabel
	instances["iconGradient"] = instances.iconButton.IconGradient
	instances["iconCorner"] = instances.iconButton.IconCorner
	instances["iconOverlay"] = iconContainer.IconOverlay
	instances["iconOverlayCorner"] = instances.iconOverlay.IconOverlayCorner
	instances["noticeFrame"] = instances.iconButton.NoticeFrame
	instances["noticeLabel"] = instances.noticeFrame.NoticeLabel
	instances["captionContainer"] = iconContainer.CaptionContainer
	instances["captionFrame"] = instances.captionContainer.CaptionFrame
	instances["captionLabel"] = instances.captionContainer.CaptionLabel
	instances["captionCorner"] = instances.captionFrame.CaptionCorner
	instances["captionOverlineContainer"] = instances.captionContainer.CaptionOverlineContainer
	instances["captionOverline"] = instances.captionOverlineContainer.CaptionOverline
	instances["captionOverlineCorner"] = instances.captionOverline.CaptionOverlineCorner
	instances["captionVisibilityBlocker"] = instances.captionFrame.CaptionVisibilityBlocker
	instances["captionVisibilityCorner"] = instances.captionVisibilityBlocker.CaptionVisibilityCorner
	instances["tipFrame"] = iconContainer.TipFrame
	instances["tipLabel"] = instances.tipFrame.TipLabel
	instances["tipCorner"] = instances.tipFrame.TipCorner
	instances["dropdownContainer"] = iconContainer.DropdownContainer
	instances["dropdownFrame"] = instances.dropdownContainer.DropdownFrame
	instances["dropdownList"] = instances.dropdownFrame.DropdownList
	instances["menuContainer"] = iconContainer.MenuContainer
	instances["menuFrame"] = instances.menuContainer.MenuFrame
	instances["menuList"] = instances.menuFrame.MenuList
	instances["clickSound"] = iconContainer.ClickSound

	-- These determine and describe how instances behave and appear
	self._settings = {
		action = {
			["toggleTransitionInfo"] = {},
			["resizeInfo"] = {},
			["repositionInfo"] = {},
			["captionFadeInfo"] = {},
			["tipFadeInfo"] = {},
			["dropdownSlideInfo"] = {},
			["menuSlideInfo"] = {},
		},
		toggleable = {
			["iconBackgroundColor"] = {instanceNames = {"iconButton"}, propertyName = "BackgroundColor3"},
			["iconBackgroundTransparency"] = {instanceNames = {"iconButton"}, propertyName = "BackgroundTransparency"},
			["iconCornerRadius"] = {instanceNames = {"iconCorner", "iconOverlayCorner"}, propertyName = "CornerRadius"},
			["iconGradientColor"] = {instanceNames = {"iconGradient"}, propertyName = "Color"},
			["iconGradientRotation"] = {instanceNames = {"iconGradient"}, propertyName = "Rotation"},
			["iconImage"] = {callMethods = {self._updateIconSize}, instanceNames = {"iconImage"}, propertyName = "Image"},
			["iconImageColor"] = {instanceNames = {"iconImage"}, propertyName = "ImageColor3"},
			["iconImageTransparency"] = {instanceNames = {"iconImage"}, propertyName = "ImageTransparency"},
			["iconScale"] = {instanceNames = {"iconButton"}, propertyName = "Size"},
			["forcedIconSizeX"] = {},
			["forcedIconSizeY"] = {},
			["iconSize"] = {callSignals = {self.updated}, callMethods = {self._updateIconSize}, instanceNames = {"iconContainer"}, propertyName = "Size", tweenAction = "resizeInfo"},
			["iconOffset"] = {instanceNames = {"iconButton"}, propertyName = "Position"},
			["iconText"] = {callMethods = {self._updateIconSize}, instanceNames = {"iconLabel"}, propertyName = "Text"},
			["iconTextColor"] = {instanceNames = {"iconLabel"}, propertyName = "TextColor3"},
			["iconFont"] = {callMethods = {self._updateIconSize}, instanceNames = {"iconLabel"}, propertyName = "Font"},
			["iconImageYScale"] = {callMethods = {self._updateIconSize}},
			["iconImageRatio"] = {callMethods = {self._updateIconSize}},
			["iconLabelYScale"] = {callMethods = {self._updateIconSize}},
			["noticeCircleColor"] = {instanceNames = {"noticeFrame"}, propertyName = "ImageColor3"},
			["noticeCircleImage"] = {instanceNames = {"noticeFrame"}, propertyName = "Image"},
			["noticeTextColor"] = {instanceNames = {"noticeLabel"}, propertyName = "TextColor3"},
			["noticeImageTransparency"] = {instanceNames = {"noticeFrame"}, propertyName = "ImageTransparency"},
			["noticeTextTransparency"] = {instanceNames = {"noticeLabel"}, propertyName = "TextTransparency"},
			["baseZIndex"] = {callMethods = {self._updateBaseZIndex}},
			["order"] = {callSignals = {self.updated}, instanceNames = {"iconContainer"}, propertyName = "LayoutOrder"},
			["alignment"] = {callSignals = {self.updated}, callMethods = {self._updateDropdown}},
			["iconImageVisible"] = {instanceNames = {"iconImage"}, propertyName = "Visible"},
			["iconImageAnchorPoint"] = {instanceNames = {"iconImage"}, propertyName = "AnchorPoint"},
			["iconImagePosition"] = {instanceNames = {"iconImage"}, propertyName = "Position", tweenAction = "resizeInfo"},
			["iconImageSize"] = {instanceNames = {"iconImage"}, propertyName = "Size", tweenAction = "resizeInfo"},
			["iconImageTextXAlignment"] = {instanceNames = {"iconImage"}, propertyName = "TextXAlignment"},
			["iconLabelVisible"] = {instanceNames = {"iconLabel"}, propertyName = "Visible"},
			["iconLabelAnchorPoint"] = {instanceNames = {"iconLabel"}, propertyName = "AnchorPoint"},
			["iconLabelPosition"] = {instanceNames = {"iconLabel"}, propertyName = "Position", tweenAction = "resizeInfo"},
			["iconLabelSize"] = {instanceNames = {"iconLabel"}, propertyName = "Size", tweenAction = "resizeInfo"},
			["iconLabelTextXAlignment"] = {instanceNames = {"iconLabel"}, propertyName = "TextXAlignment"},
			["iconLabelTextSize"] = {instanceNames = {"iconLabel"}, propertyName = "TextSize"},
			["noticeFramePosition"] = {instanceNames = {"noticeFrame"}, propertyName = "Position"},
			["clickSoundId"] = {instanceNames = {"clickSound"}, propertyName = "SoundId"},
			["clickVolume"] = {instanceNames = {"clickSound"}, propertyName = "Volume"},
			["clickPlaybackSpeed"] = {instanceNames = {"clickSound"}, propertyName = "PlaybackSpeed"},
			["clickTimePosition"] = {instanceNames = {"clickSound"}, propertyName = "TimePosition"},
		},
		other = {
			["captionBackgroundColor"] = {instanceNames = {"captionFrame"}, propertyName = "BackgroundColor3"},
			["captionBackgroundTransparency"] = {instanceNames = {"captionFrame"}, propertyName = "BackgroundTransparency", group = "caption"},
			["captionBlockerTransparency"] = {instanceNames = {"captionVisibilityBlocker"}, propertyName = "BackgroundTransparency", group = "caption"},
			["captionOverlineColor"] = {instanceNames = {"captionOverline"}, propertyName = "BackgroundColor3"},
			["captionOverlineTransparency"] = {instanceNames = {"captionOverline"}, propertyName = "BackgroundTransparency", group = "caption"},
			["captionTextColor"] = {instanceNames = {"captionLabel"}, propertyName = "TextColor3"},
			["captionTextTransparency"] = {instanceNames = {"captionLabel"}, propertyName = "TextTransparency", group = "caption"},
			["captionFont"] = {instanceNames = {"captionLabel"}, propertyName = "Font"},
			["captionCornerRadius"] = {instanceNames = {"captionCorner", "captionOverlineCorner", "captionVisibilityCorner"}, propertyName = "CornerRadius"},
			["tipBackgroundColor"] = {instanceNames = {"tipFrame"}, propertyName = "BackgroundColor3"},
			["tipBackgroundTransparency"] = {instanceNames = {"tipFrame"}, propertyName = "BackgroundTransparency", group = "tip"},
			["tipTextColor"] = {instanceNames = {"tipLabel"}, propertyName = "TextColor3"},
			["tipTextTransparency"] = {instanceNames = {"tipLabel"}, propertyName = "TextTransparency", group = "tip"},
			["tipFont"] = {instanceNames = {"tipLabel"}, propertyName = "Font"},
			["tipCornerRadius"] = {instanceNames = {"tipCorner"}, propertyName = "CornerRadius"},
			["dropdownSize"] = {instanceNames = {"dropdownContainer"}, propertyName = "Size", unique = "dropdown"},
			["dropdownCanvasSize"] = {instanceNames = {"dropdownFrame"}, propertyName = "CanvasSize"},
			["dropdownMaxIconsBeforeScroll"] = {callMethods = {self._updateDropdown}},
			["dropdownMinWidth"] = {callMethods = {self._updateDropdown}},
			["dropdownSquareCorners"] = {callMethods = {self._updateDropdown}},
			["dropdownBindToggleToIcon"] = {},
			["dropdownToggleOnLongPress"] = {},
			["dropdownToggleOnRightClick"] = {},
			["dropdownCloseOnTapAway"] = {},
			["dropdownHidePlayerlistOnOverlap"] = {},
			["dropdownListPadding"] = {callMethods = {self._updateDropdown}, instanceNames = {"dropdownList"}, propertyName = "Padding"},
			["dropdownAlignment"] = {callMethods = {self._updateDropdown}},
			["dropdownScrollBarColor"] = {instanceNames = {"dropdownFrame"}, propertyName = "ScrollBarImageColor3"},
			["dropdownScrollBarTransparency"] = {instanceNames = {"dropdownFrame"}, propertyName = "ScrollBarImageTransparency"},
			["dropdownScrollBarThickness"] = {instanceNames = {"dropdownFrame"}, propertyName = "ScrollBarThickness"},
			["dropdownIgnoreClipping"] = {callMethods = {self._dropdownIgnoreClipping}},
			["menuSize"] = {instanceNames = {"menuContainer"}, propertyName = "Size", unique = "menu"},
			["menuCanvasSize"] = {instanceNames = {"menuFrame"}, propertyName = "CanvasSize"},
			["menuMaxIconsBeforeScroll"] = {callMethods = {self._updateMenu}},
			["menuBindToggleToIcon"] = {},
			["menuToggleOnLongPress"] = {},
			["menuToggleOnRightClick"] = {},
			["menuCloseOnTapAway"] = {},
			["menuListPadding"] = {callMethods = {self._updateMenu}, instanceNames = {"menuList"}, propertyName = "Padding"},
			["menuDirection"] = {callMethods = {self._updateMenu}},
			["menuScrollBarColor"] = {instanceNames = {"menuFrame"}, propertyName = "ScrollBarImageColor3"},
			["menuScrollBarTransparency"] = {instanceNames = {"menuFrame"}, propertyName = "ScrollBarImageTransparency"},
			["menuScrollBarThickness"] = {instanceNames = {"menuFrame"}, propertyName = "ScrollBarThickness"},
			["menuIgnoreClipping"] = {callMethods = {self._menuIgnoreClipping}},
		}
	}

	---------------------------------
	self._groupSettings = {}
	for _, settingsDetails in pairs(self._settings) do
		for settingName, settingDetail in pairs(settingsDetails) do
			local group = settingDetail.group
			if group then
				local groupSettings = self._groupSettings[group]
				if not groupSettings then
					groupSettings = {}
					self._groupSettings[group] = groupSettings
				end
				table.insert(groupSettings, settingName)
				settingDetail.forcedGroupValue = DEFAULT_FORCED_GROUP_VALUES[group]
				settingDetail.useForcedGroupValue = true
			end
		end
	end
	---------------------------------

	-- The setting values themselves will be set within _settings
	-- Setup a dictionary to make it quick and easy to reference setting by name
	self._settingsDictionary = {}
	-- Some instances require unique behaviours. These are defined with the 'unique' key
	-- for instance, we only want caption transparency effects to be applied on hovering
	self._uniqueSettings = {}
	self._uniqueSettingsDictionary = {}
	self.uniqueValues = {}
	local uniqueBehaviours = {
		["dropdown"] = function(settingName, instance, propertyName, value)
			local tweenInfo = self:get("dropdownSlideInfo")
			local bindToggleToIcon = self:get("dropdownBindToggleToIcon")
			local hidePlayerlist = self:get("dropdownHidePlayerlistOnOverlap") == true and self:get("alignment") == "right"
			local dropdownContainer = self.instances.dropdownContainer
			local dropdownFrame = self.instances.dropdownFrame
			local newValue = value
			local isOpen = true
			local isDeselected = not self.isSelected
			if bindToggleToIcon == false then
				isDeselected = not self.dropdownOpen
			end
			local isSpecialPressing = self._longPressing or self._rightClicking
			if self._tappingAway or (isDeselected and not isSpecialPressing) or (isSpecialPressing and self.dropdownOpen) then 
				local dropdownSize = self:get("dropdownSize")
				local XOffset = (dropdownSize and dropdownSize.X.Offset/1) or 0
				newValue = UDim2.new(0, XOffset, 0, 0)
				isOpen = false
			end
			-- if #self.dropdownIcons > 0 and isOpen and hidePlayerlist and self._parentIcon == nil and self._bringBackPlayerlist == nil then
			if #self.dropdownIcons > 0 and isOpen and hidePlayerlist then
				if starterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList) then
					IconController._bringBackPlayerlist = (IconController._bringBackPlayerlist and IconController._bringBackPlayerlist + 1) or 1
					self._bringBackPlayerlist = true
					starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
				end
			elseif self._bringBackPlayerlist and not isOpen and IconController._bringBackPlayerlist then
				IconController._bringBackPlayerlist -= 1
				if IconController._bringBackPlayerlist <= 0 then
					IconController._bringBackPlayerlist = nil
					starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
				end
				self._bringBackPlayerlist = nil
			end
			local tween = tweenService:Create(instance, tweenInfo, {[propertyName] = newValue})
			local connection
			connection = tween.Completed:Connect(function()
				connection:Disconnect()
				--dropdownContainer.ClipsDescendants = not self.dropdownOpen
			end)
			tween:Play()
			if isOpen then
				--dropdownFrame.CanvasPosition = self._dropdownCanvasPos
			else
				self._dropdownCanvasPos = dropdownFrame.CanvasPosition
			end
			dropdownFrame.ScrollingEnabled = isOpen -- It's important scrolling is only enabled when the dropdown is visible otherwise it could block the scrolling behaviour of other icons
			self.dropdownOpen = isOpen
			self:_decideToCallSignal("dropdown")
		end,
		["menu"] = function(settingName, instance, propertyName, value)
			local tweenInfo = self:get("menuSlideInfo")
			local bindToggleToIcon = self:get("menuBindToggleToIcon")
			local menuContainer = self.instances.menuContainer
			local menuFrame = self.instances.menuFrame
			local newValue = value
			local isOpen = true
			local isDeselected = not self.isSelected
			if bindToggleToIcon == false then
				isDeselected = not self.menuOpen
			end
			local isSpecialPressing = self._longPressing or self._rightClicking
			if self._tappingAway or (isDeselected and not isSpecialPressing) or (isSpecialPressing and self.menuOpen) then 
				local menuSize = self:get("menuSize")
				local YOffset = (menuSize and menuSize.Y.Offset/1) or 0
				newValue = UDim2.new(0, 0, 0, YOffset)
				isOpen = false
			end
			if isOpen ~= self.menuOpen then
				self.updated:Fire()
			end
			if isOpen and tweenInfo.EasingDirection == Enum.EasingDirection.Out then
				tweenInfo = TweenInfo.new(tweenInfo.Time, tweenInfo.EasingStyle, Enum.EasingDirection.In)
			end
			local tween = tweenService:Create(instance, tweenInfo, {[propertyName] = newValue})
			local connection
			connection = tween.Completed:Connect(function()
				connection:Disconnect()
				--menuContainer.ClipsDescendants = not self.menuOpen
			end)
			tween:Play()
			if isOpen then
				if self._menuCanvasPos then
					menuFrame.CanvasPosition = self._menuCanvasPos
				end
			else
				self._menuCanvasPos = menuFrame.CanvasPosition
			end
			menuFrame.ScrollingEnabled = isOpen -- It's important scrolling is only enabled when the menu is visible otherwise it could block the scrolling behaviour of other icons
			self.menuOpen = isOpen
			self:_decideToCallSignal("menu")
		end,
	}
	for settingsType, settingsDetails in pairs(self._settings) do
		for settingName, settingDetail in pairs(settingsDetails) do
			if settingsType == "toggleable" then
				settingDetail.values = settingDetail.values or {
					deselected = nil,
					selected = nil,
				}
			else
				settingDetail.value = nil
			end
			settingDetail.additionalValues = {}
			settingDetail.type = settingsType
			self._settingsDictionary[settingName] = settingDetail
			--
			local uniqueCat = settingDetail.unique
			if uniqueCat then
				local uniqueCatArray = self._uniqueSettings[uniqueCat] or {}
				table.insert(uniqueCatArray, settingName)
				self._uniqueSettings[uniqueCat] = uniqueCatArray
				self._uniqueSettingsDictionary[settingName] = uniqueBehaviours[uniqueCat]
			end
			--
		end
	end
	
	-- Signals (events)
	self.updated = maid:give(Signal.new())
	self.selected = maid:give(Signal.new())
    self.deselected = maid:give(Signal.new())
    self.toggled = maid:give(Signal.new())
	self.userSelected = maid:give(Signal.new())
	self.userDeselected = maid:give(Signal.new())
	self.userToggled = maid:give(Signal.new())
	self.hoverStarted = maid:give(Signal.new())
	self.hoverEnded = maid:give(Signal.new())
	self.dropdownOpened = maid:give(Signal.new())
	self.dropdownClosed = maid:give(Signal.new())
	self.menuOpened = maid:give(Signal.new())
	self.menuClosed = maid:give(Signal.new())
	self.notified = maid:give(Signal.new())
	self._endNotices = maid:give(Signal.new())
	self._ignoreClippingChanged = maid:give(Signal.new())
	
	-- Connections
	-- This enables us to chain icons and features like menus and dropdowns together without them being hidden by parent frame with ClipsDescendants enabled
	local function setFeatureChange(featureName, value)
		local parentIcon = self._parentIcon
		self:set(featureName.."IgnoreClipping", value)
		if value == true and parentIcon then
			local connection = parentIcon._ignoreClippingChanged:Connect(function(_, value)
				self:set(featureName.."IgnoreClipping", value)
			end)
			local endConnection
			endConnection = self[featureName.."Closed"]:Connect(function()
				endConnection:Disconnect()
				connection:Disconnect()
			end)
		end
	end
	self.dropdownOpened:Connect(function()
		setFeatureChange("dropdown", true)
	end)
	self.dropdownClosed:Connect(function()
		setFeatureChange("dropdown", false)
	end)
	self.menuOpened:Connect(function()
		setFeatureChange("menu", true)
	end)
	self.menuClosed:Connect(function()
		setFeatureChange("menu", false)
	end)
	--]]

	-- Properties
	self.deselectWhenOtherIconSelected = true
	self.name = ""
	self.isSelected = false
	self.presentOnTopbar = true
	self.accountForWhenDisabled = false
	self.enabled = true
	self.hovering = false
	self.tipText = nil
	self.captionText = nil
	self.totalNotices = 0
	self.notices = {}
	self.dropdownIcons = {}
	self.menuIcons = {}
	self.dropdownOpen = false
	self.menuOpen = false
	self.locked = false
	self.topPadding = UDim.new(0, 4)
	self.targetPosition = nil
	self.toggleItems = {}
	self.lockedSettings = {}
	self.UID = httpService:GenerateGUID(true)
	self.blockBackBehaviourChecks = {}
	
	-- Private Properties
	self._draggingFinger = false
	self._updatingIconSize = true
	self._previousDropdownOpen = false
	self._previousMenuOpen = false
	self._bindedToggleKeys = {}
	self._bindedEvents = {}
	
	-- Apply start values
	self:setName("UnnamedIcon")
	self:setTheme(DEFAULT_THEME, true)

	-- Input handlers
	-- Calls deselect/select when the icon is clicked
	--[[instances.iconButton.MouseButton1Click:Connect(function()
		if self.locked then return end
		if self._draggingFinger then
			return false
		elseif self.isSelected then
			self:deselect()
			return true
		end
		self:select()
	end)--]]
	instances.iconButton.MouseButton1Click:Connect(function()
		if self.locked then return end
		if self.isSelected then
			self:deselect()
			self.userDeselected:Fire()
			self.userToggled:Fire(false)
			return true
		end
		self:select()
		self.userSelected:Fire()
		self.userToggled:Fire(true)
	end)
	instances.iconButton.MouseButton2Click:Connect(function()
		self._rightClicking = true
		if self:get("dropdownToggleOnRightClick") == true then
			self:_update("dropdownSize")
		end
		if self:get("menuToggleOnRightClick") == true then
			self:_update("menuSize")
		end
		self._rightClicking = false
	end)

	-- Shows/hides the dark overlay when the icon is presssed/released
	instances.iconButton.MouseButton1Down:Connect(function()
		if self.locked then return end
		self:_updateStateOverlay(0.7, Color3.new(0, 0, 0))
	end)
	instances.iconButton.MouseButton1Up:Connect(function()
		if self.overlayLocked then return end
		self:_updateStateOverlay(0.9, Color3.new(1, 1, 1))
	end)

	-- Tap away + KeyCode toggles
	userInputService.InputBegan:Connect(function(input, touchingAnObject)
		local validTapAwayInputs = {
			[Enum.UserInputType.MouseButton1] = true,
			[Enum.UserInputType.MouseButton2] = true,
			[Enum.UserInputType.MouseButton3] = true,
			[Enum.UserInputType.Touch] = true,
		}
		if not touchingAnObject and validTapAwayInputs[input.UserInputType] then
			self._tappingAway = true
			if self.dropdownOpen and self:get("dropdownCloseOnTapAway") == true then
				self:_update("dropdownSize")
			end
			if self.menuOpen and self:get("menuCloseOnTapAway") == true then
				self:_update("menuSize")
			end
			self._tappingAway = false
		end
		--
		if self._bindedToggleKeys[input.KeyCode] and not touchingAnObject and not self.locked then
			if self.isSelected then
				self:deselect()
				self.userDeselected:Fire()
				self.userToggled:Fire(false)
			else
				self:select()
				self.userSelected:Fire()
				self.userToggled:Fire(true)
			end
		end
		--
	end)
	
	-- hoverStarted and hoverEnded triggers and actions
	-- these are triggered when a mouse enters/leaves the icon with a mouse, is highlighted with
	-- a controller selection box, or dragged over with a touchpad
	self.hoverStarted:Connect(function(x, y)
		self.hovering = true
		if not self.locked then
			self:_updateStateOverlay(0.9, Color3.fromRGB(255, 255, 255))
		end
		self:_updateHovering()
	end)
	self.hoverEnded:Connect(function()
		self.hovering = false
		self:_updateStateOverlay(1)
		self._hoveringMaid:clean()
		self:_updateHovering()
	end)
	instances.iconButton.MouseEnter:Connect(function(x, y) -- Mouse (started)
		self.hoverStarted:Fire(x, y)
	end)
	instances.iconButton.MouseLeave:Connect(function() -- Mouse (ended)
		self.hoverEnded:Fire()
	end)
	instances.iconButton.SelectionGained:Connect(function() -- Controller (started)
		self.hoverStarted:Fire()
	end)
	instances.iconButton.SelectionLost:Connect(function() -- Controller (ended)
		self.hoverEnded:Fire()
	end)
	instances.iconButton.MouseButton1Down:Connect(function() -- TouchPad (started)
		if self._draggingFinger then
			self.hoverStarted:Fire()
		end
		-- Long press check
		local heartbeatConnection
		local releaseConnection
		local longPressTime = 0.7
		local endTick = tick() + longPressTime
		heartbeatConnection = runService.Heartbeat:Connect(function()
			if tick() >= endTick then
				releaseConnection:Disconnect()
				heartbeatConnection:Disconnect()
				self._longPressing = true
				if self:get("dropdownToggleOnLongPress") == true then
					self:_update("dropdownSize")
				end
				if self:get("menuToggleOnLongPress") == true then
					self:_update("menuSize")
				end
				self._longPressing = false
			end
		end)
		releaseConnection = instances.iconButton.MouseButton1Up:Connect(function()
			releaseConnection:Disconnect()
			heartbeatConnection:Disconnect()
		end)
	end)
	if userInputService.TouchEnabled then
		instances.iconButton.MouseButton1Up:Connect(function() -- TouchPad (ended), this was originally enabled for non-touchpads too
			if self.hovering then
				self.hoverEnded:Fire()
			end
		end)
		-- This is used to highlight when a mobile/touch device is dragging their finger accross the screen
		-- this is important for determining the hoverStarted and hoverEnded events on mobile
		local dragCount = 0
		userInputService.TouchMoved:Connect(function(touch, touchingAnObject)
			if touchingAnObject then
				return
			end
			self._draggingFinger = true
		end)
		userInputService.TouchEnded:Connect(function()
			self._draggingFinger = false
		end)
	end

	-- Finish
	self._updatingIconSize = false
	self:_updateIconSize()
	IconController.iconAdded:Fire(self)
	
	return self
end

-- This is the same as Icon.new(), except it adds additional behaviour for certain specified names designed to mimic core icons, such as 'Chat'
function Icon.mimic(coreIconToMimic)
	local iconName = coreIconToMimic.."Mimic"
	local icon = IconController.getIcon(iconName)
	if icon then
		return icon
	end
	icon = Icon.new()
	icon:setName(iconName)

	if coreIconToMimic == "Chat" then
		icon:setOrder(-1)
		icon:setImage("rbxasset://textures/ui/TopBar/chatOff.png", "deselected")
		icon:setImage("rbxasset://textures/ui/TopBar/chatOn.png", "selected")
		icon:setImageYScale(0.625)
		-- Since roblox's core gui api sucks melons I reverted to listening for signals within the chat modules
		-- unfortunately however they've just gone and removed *these* signals therefore 
		-- this mimic chat and similar features are now impossible to recreate accurately, so I'm disabling for now
		-- ill go ahead and post a feature request; fingers crossed we get something by the next decade

		--[[
		-- Setup maid and cleanup actioon
		local maid = icon._maid
		icon._fakeChatMaid = maid:give(Maid.new())
		maid.chatMimicCleanup = function()
			starterGui:SetCoreGuiEnabled("Chat", icon.enabled)
		end
		-- Tap into chat module
		local chatMainModule = localPlayer.PlayerScripts:WaitForChild("ChatScript").ChatMain
		local ChatMain = require(chatMainModule)
		local function displayChatBar(visibility)
			icon.ignoreVisibilityStateChange = true
			ChatMain.CoreGuiEnabled:fire(visibility)
			ChatMain.IsCoreGuiEnabled = false
			ChatMain:SetVisible(visibility)
			icon.ignoreVisibilityStateChange = nil
		end
		local function setIconEnabled(visibility)
			icon.ignoreVisibilityStateChange = true
			ChatMain.CoreGuiEnabled:fire(visibility)
			icon:setEnabled(visibility)
			starterGui:SetCoreGuiEnabled("Chat", false)
			icon:deselect()
			icon.updated:Fire()
			icon.ignoreVisibilityStateChange = nil
		end
		-- Open chat via Slash key
		icon._fakeChatMaid:give(userInputService.InputEnded:Connect(function(inputObject, gameProcessedEvent)
			if gameProcessedEvent then
				return "Another menu has priority"
			elseif not(inputObject.KeyCode == Enum.KeyCode.Slash or inputObject.KeyCode == Enum.SpecialKey.ChatHotkey) then
				return "No relavent key pressed"
			elseif ChatMain.IsFocused() then
				return "Chat bar already open"
			elseif not icon.enabled then
				return "Icon disabled"
			end
			ChatMain:FocusChatBar(true)
			icon:select()
		end))
		-- ChatActive
		icon._fakeChatMaid:give(ChatMain.VisibilityStateChanged:Connect(function(visibility)
			if not icon.ignoreVisibilityStateChange then
				if visibility == true then
					icon:select()
				else
					icon:deselect()
				end
			end
		end))
		-- Keep when other icons selected
		icon.deselectWhenOtherIconSelected = false
		-- Mimic chat notifications
		icon._fakeChatMaid:give(ChatMain.MessagesChanged:connect(function()
			if ChatMain:GetVisibility() == true then
				return "ChatWindow was open"
			end
			icon:notify(icon.selected)
		end))
		-- Mimic visibility when StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, state) is called
		coroutine.wrap(function()
			runService.Heartbeat:Wait()
			icon._fakeChatMaid:give(ChatMain.CoreGuiEnabled:connect(function(newState)
				if icon.ignoreVisibilityStateChange then
					return "ignoreVisibilityStateChange enabled"
				end
				local topbarEnabled = starterGui:GetCore("TopbarEnabled")
				if topbarEnabled ~= IconController.previousTopbarEnabled then
					return "SetCore was called instead of SetCoreGuiEnabled"
				end
				if not icon.enabled and userInputService:IsKeyDown(Enum.KeyCode.LeftShift) and userInputService:IsKeyDown(Enum.KeyCode.P) then
					icon:setEnabled(true)
				else
					setIconEnabled(newState)
				end
			end))
		end)()
		icon.deselected:Connect(function()
			displayChatBar(false)
		end)
		icon.selected:Connect(function()
			displayChatBar(true)
		end)
		setIconEnabled(starterGui:GetCoreGuiEnabled("Chat"))
		--]]
	end
	return icon
end



-- CORE UTILITY METHODS
function Icon:set(settingName, value, iconState, setAdditional)
	local settingDetail = self._settingsDictionary[settingName]
	assert(settingDetail ~= nil, ("setting '%s' does not exist"):format(settingName))
	if type(iconState) == "string" then
		iconState = iconState:lower()
	end
	local previousValue = self:get(settingName, iconState)

	if iconState == "hovering" then
		-- Apply hovering state if valid
		settingDetail.hoveringValue = value
		if setAdditional ~= "_ignorePrevious" then
			settingDetail.additionalValues["previous_"..iconState] = previousValue
		end
		if type(setAdditional) == "string" then
			settingDetail.additionalValues[setAdditional.."_"..iconState] = previousValue
		end
		self:_update(settingName)

	else
		-- Update the settings value
		local toggleState = iconState
		local settingType = settingDetail.type
		if settingType == "toggleable" then
			local valuesToSet = {}
			if toggleState == "deselected" or toggleState == "selected" then
				table.insert(valuesToSet, toggleState)
			else
				table.insert(valuesToSet, "deselected")
				table.insert(valuesToSet, "selected")
				toggleState = nil
			end
			for i, v in pairs(valuesToSet) do
				settingDetail.values[v] = value
				if setAdditional ~= "_ignorePrevious" then
					settingDetail.additionalValues["previous_"..v] = previousValue
				end
				if type(setAdditional) == "string" then
					settingDetail.additionalValues[setAdditional.."_"..v] = previousValue
				end
			end
		else
			settingDetail.value = value
			if type(setAdditional) == "string" then
				if setAdditional ~= "_ignorePrevious" then
					settingDetail.additionalValues["previous"] = previousValue
				end
				settingDetail.additionalValues[setAdditional] = previousValue
			end
		end

		-- Check previous and new are not the same
		if previousValue == value then
			return self, "Value was already set"
		end

		-- Update appearances of associated instances
		local currentToggleState = self:getToggleState()
		if not self._updateAfterSettingAll and settingDetail.instanceNames and (currentToggleState == toggleState or toggleState == nil) then
			local ignoreTweenAction = (settingName == "iconSize" and previousValue and previousValue.X.Scale == 1)
			local tweenInfo = (settingDetail.tweenAction and not ignoreTweenAction and self:get(settingDetail.tweenAction)) or TweenInfo.new(0)
			self:_update(settingName, currentToggleState, tweenInfo)
		end
	end

	-- Call any methods present
	if settingDetail.callMethods then
		for _, callMethod in pairs(settingDetail.callMethods) do
			callMethod(self, value, iconState)
		end
	end
	
	-- Call any signals present
	if settingDetail.callSignals then
		for _, callSignal in pairs(settingDetail.callSignals) do
			callSignal:Fire()
		end
	end
	return self
end

function Icon:setAdditionalValue(settingName, setAdditional, value, iconState)
	local settingDetail = self._settingsDictionary[settingName]
	assert(settingDetail ~= nil, ("setting '%s' does not exist"):format(settingName))
	local stringMatch = setAdditional.."_"
	if iconState then
		stringMatch = stringMatch..iconState
	end
	for key, _ in pairs(settingDetail.additionalValues) do
		if string.match(key, stringMatch) then
			settingDetail.additionalValues[key] = value
		end
	end
end

function Icon:get(settingName, iconState, getAdditional)
	local settingDetail = self._settingsDictionary[settingName]
	assert(settingDetail ~= nil, ("setting '%s' does not exist"):format(settingName))
	local valueToReturn, additionalValueToReturn
	if typeof(iconState) == "string" then
		iconState = iconState:lower()
	end

	--if ((self.hovering and settingDetail.hoveringValue) or iconState == "hovering") and getAdditional == nil then
	if (iconState == "hovering") and getAdditional == nil then
		valueToReturn = settingDetail.hoveringValue
		additionalValueToReturn = type(getAdditional) == "string" and settingDetail.additionalValues[getAdditional.."_"..iconState]
	end

	local settingType = settingDetail.type
	if settingType == "toggleable" then
		local toggleState = ((iconState == "deselected" or iconState == "selected") and iconState) or self:getToggleState()
		if additionalValueToReturn == nil then
			additionalValueToReturn = type(getAdditional) == "string" and settingDetail.additionalValues[getAdditional.."_"..toggleState]
		end
		if valueToReturn == nil then
			valueToReturn = settingDetail.values[toggleState]
		end
	
	else
		if additionalValueToReturn == nil then
			additionalValueToReturn = type(getAdditional) == "string" and settingDetail.additionalValues[getAdditional]
		end
		if valueToReturn == nil then
			valueToReturn = settingDetail.value
		end
	end

	return valueToReturn, additionalValueToReturn
end

function Icon:getHovering(settingName)
	local settingDetail = self._settingsDictionary[settingName]
	assert(settingDetail ~= nil, ("setting '%s' does not exist"):format(settingName))
	return settingDetail.hoveringValue
end

function Icon:getToggleState(isSelected)
	isSelected = isSelected or self.isSelected
	return (isSelected and "selected") or "deselected"
end

function Icon:getIconState()
	if self.hovering then
		return "hovering"
	else
		return self:getToggleState()
	end
end

function Icon:_update(settingName, toggleState, customTweenInfo)
	local settingDetail = self._settingsDictionary[settingName]
	assert(settingDetail ~= nil, ("setting '%s' does not exist"):format(settingName))
	toggleState = toggleState or self:getToggleState()
	local value = settingDetail.value or (settingDetail.values and settingDetail.values[toggleState])
	if self.hovering and settingDetail.hoveringValue then
		value = settingDetail.hoveringValue
	end
	if value == nil then return end
	local tweenInfo = customTweenInfo or (settingDetail.tweenAction and settingDetail.tweenAction ~= "" and self:get(settingDetail.tweenAction)) or self:get("toggleTransitionInfo") or TweenInfo.new(0.15)
	local propertyName = settingDetail.propertyName
	local invalidPropertiesTypes = {
		["string"] = true,
		["NumberSequence"] = true,
		["Text"] = true,
		["EnumItem"] = true,
		["ColorSequence"] = true,
	}
	local uniqueSetting = self._uniqueSettingsDictionary[settingName]
	local newValue = value
	if settingDetail.useForcedGroupValue then
		newValue = settingDetail.forcedGroupValue
	end
	if settingDetail.instanceNames then
		for _, instanceName in pairs(settingDetail.instanceNames) do
			local instance = self.instances[instanceName]
			local propertyType = typeof(instance[propertyName])
			local cannotTweenProperty = invalidPropertiesTypes[propertyType] or typeof(instance) == "table"
			if uniqueSetting then
				uniqueSetting(settingName, instance, propertyName, newValue)
			elseif cannotTweenProperty then
				instance[propertyName] = value
			else
				tweenService:Create(instance, tweenInfo, {[propertyName] = newValue}):Play()
			end
			--
			if settingName == "iconSize" and instance[propertyName] ~= newValue then
				self.updated:Fire()
			end
			--
		end
	end
end

function Icon:_updateAll(iconState, customTweenInfo)
	for settingName, settingDetail in pairs(self._settingsDictionary) do
		if settingDetail.instanceNames then
			self:_update(settingName, iconState, customTweenInfo)
		end
	end
	-- It's important we adapt the size of anything that could be changed through Localization
	-- In this case, the icon label, caption and tip
	self:_updateIconSize()
	self:_updateCaptionSize()
	self:_updateTipSize()
end

function Icon:_updateHovering(customTweenInfo)
	for settingName, settingDetail in pairs(self._settingsDictionary) do
		if settingDetail.instanceNames and settingDetail.hoveringValue ~= nil then
			self:_update(settingName, nil, customTweenInfo)
		end
	end
end

function Icon:_updateStateOverlay(transparency, color)
	local stateOverlay = self.instances.iconOverlay
	stateOverlay.BackgroundTransparency = transparency or 1
	stateOverlay.BackgroundColor3 = color or Color3.new(1, 1, 1)
end

function Icon:setTheme(theme, updateAfterSettingAll)
	self._updateAfterSettingAll = updateAfterSettingAll
	for settingsType, settingsDetails in pairs(theme) do
		if settingsType == "toggleable" then
			for settingName, settingValue in pairs(settingsDetails.deselected) do
				if not self.lockedSettings[settingName] then
					self:set(settingName, settingValue, "both")
				end
			end
			for settingName, settingValue in pairs(settingsDetails.selected) do
				if not self.lockedSettings[settingName] then
					self:set(settingName, settingValue, "selected")
				end
			end
		else
			for settingName, settingValue in pairs(settingsDetails) do
				if not self.lockedSettings[settingName] then
					local settingDetail = self._settingsDictionary[settingName]
					if settingsType == "action" and settingDetail == nil then
						settingDetail = {}
						self._settingsDictionary[settingName] = {}
					end
					self:set(settingName, settingValue)
				end
			end
		end
	end
	self._updateAfterSettingAll = nil
	if updateAfterSettingAll then
		self:_updateAll()
	end
	return self
end

function Icon:getInstance(instanceName)
	return self.instances[instanceName]
end

function Icon:setInstance(instanceName, instance)
	local originalInstance = self.instances[instanceName]
	self.instances[instanceName] = instance
	if originalInstance then
		originalInstance:Destroy()
	end
	return self
end

function Icon:getSettingDetail(targetSettingName)
	for _, settingsDetails in pairs(self._settings) do
		for settingName, settingDetail in pairs(settingsDetails) do
			if settingName == targetSettingName then
				return settingDetail
			end
		end
	end
	return false
end

function Icon:modifySetting(settingName, dictionary)
	local settingDetail = self:getSettingDetail(settingName)
	for key, value in pairs(dictionary) do
		settingDetail[key] = value
	end
	return self
end

function Icon:convertLabelToNumberSpinner(numberSpinner)
	-- This updates the number spinners appearance
	self:set("iconLabelSize", UDim2.new(1,0,1,0))
	numberSpinner.Parent = self:getInstance("iconButton")

	-- This creates a fake iconLabel which updates the property of all descendant spinner TextLabels when indexed
	local textLabel = {}
	setmetatable(textLabel, {__newindex = function(_, index, value)
		for _, label in pairs(numberSpinner.Frame:GetDescendants()) do
			if label:IsA("TextLabel") then
				label[index] = value
			end
		end
	end})

	-- This overrides existing instances and settings so that they update the spinners properties (instead of the old textlabel)
	local iconButton = self:getInstance("iconButton")
	iconButton.ZIndex = 0
	self:setInstance("iconLabel", textLabel)
	self:modifySetting("iconText", {instanceNames = {}}) -- We do this to prevent text being modified within the metatable above
	self:setInstance("iconLabelSpinner", numberSpinner.Frame)
	local settingsToConvert = {"iconLabelVisible", "iconLabelAnchorPoint", "iconLabelPosition", "iconLabelSize"}
	for _, settingName in pairs(settingsToConvert) do
		self:modifySetting(settingName, {instanceNames = {"iconLabelSpinner"}})
	end

	-- This applies all the values we just updated
	self:_updateAll()
	return self
end

function Icon:setEnabled(bool)
	self.enabled = bool
	self.instances.iconContainer.Visible = bool
	self.updated:Fire()
	return self
end

function Icon:setName(string)
	self.name = string
	self.instances.iconContainer.Name = string
	return self
end

function Icon:setProperty(propertyName, value)
	self[propertyName] = value
	return self
end

function Icon:_playClickSound()
	local clickSound = self.instances.clickSound
	if clickSound.SoundId ~= nil and #clickSound.SoundId > 0 and clickSound.Volume > 0 then
		local clickSoundCopy = clickSound:Clone()
		clickSoundCopy.Parent = clickSound.Parent
		clickSoundCopy:Play()
		debris:AddItem(clickSoundCopy, clickSound.TimeLength)
	end
end

function Icon:select(byIcon)
	--if self.locked then return self end
	self.isSelected = true
	self:_setToggleItemsVisible(true, byIcon)
	self:_updateNotice()
	self:_updateAll()
	self:_playClickSound()
	if #self.dropdownIcons > 0 or #self.menuIcons > 0 then
		IconController:_updateSelectionGroup()
	end
	if userInputService.GamepadEnabled then
		-- If a corresponding guiObject is found (set via :setToggleItem()) then this automatically
		-- moves the controller selection to a selectable and active instance within that guiObject.
		-- It also support back (Controller B) being pressed by navigating to previous pages or
		-- closing the icon and focusing selection back on the controller navigation topbar.
		for toggleItem, buttonInstancesArray in pairs(self.toggleItems) do
			if #buttonInstancesArray > 0 then
				local focusMaid = Maid.new()
				guiService:AddSelectionTuple(self.UID, unpack(buttonInstancesArray))
				guiService.SelectedObject = buttonInstancesArray[1]
				IconController.activeButtonBCallbacks += 1
				focusMaid:give(userInputService.InputEnded:Connect(function(input, processed)
					local blockBackBehaviour = false
					for _, func in pairs(self.blockBackBehaviourChecks) do
						if func() == true then
							blockBackBehaviour = true
							break
						end
					end
					if input.KeyCode == Enum.KeyCode.ButtonB and not blockBackBehaviour then
						guiService.SelectedObject = self.instances.iconButton
						self:deselect()
					end
				end))
				focusMaid:give(self.deselected:Connect(function()
					focusMaid:clean()
				end))
				focusMaid:give(function()
					IconController.activeButtonBCallbacks -= 1
					if IconController.activeButtonBCallbacks < 0 then
						IconController.activeButtonBCallbacks = 0
					end
				end)
			end
		end
	end
	self.selected:Fire()
    self.toggled:Fire(self.isSelected)
	return self
end

function Icon:deselect(byIcon)
	--if self.locked then return self end
	self.isSelected = false
	self:_setToggleItemsVisible(false, byIcon)
	self:_updateNotice()
	self:_updateAll()
	self:_playClickSound()
	if #self.dropdownIcons > 0 or #self.menuIcons > 0 then
		IconController:_updateSelectionGroup()
	end
    self.deselected:Fire()
    self.toggled:Fire(self.isSelected)
	if userInputService.GamepadEnabled then
		guiService:RemoveSelectionGroup(self.UID)
	end
	return self
end

function Icon:notify(clearNoticeEvent, noticeId)
	coroutine.wrap(function()
		if not clearNoticeEvent then
			clearNoticeEvent = self.deselected
		end
		if self._parentIcon then
			self._parentIcon:notify(clearNoticeEvent)
		end
		
		local notifComplete = Signal.new()
		local endEvent = self._endNotices:Connect(function()
			notifComplete:Fire()
		end)
		local customEvent = clearNoticeEvent:Connect(function()
			notifComplete:Fire()
		end)
		
		noticeId = noticeId or httpService:GenerateGUID(true)
		self.notices[noticeId] = {
			completeSignal = notifComplete,
			clearNoticeEvent = clearNoticeEvent,
		}
		self.totalNotices += 1
		self:_updateNotice()

		self.notified:Fire(noticeId)
		notifComplete:Wait()
		
		endEvent:Disconnect()
		customEvent:Disconnect()
		notifComplete:Disconnect()
		
		self.totalNotices -= 1
		self.notices[noticeId] = nil
		self:_updateNotice()
	end)()
	return self
end

function Icon:_updateNotice()
	local enabled = true
	if self.totalNotices < 1 then
		enabled = false
	end
	-- Deselect
	if not self.isSelected then
		if (#self.dropdownIcons > 0 or #self.menuIcons > 0) and self.totalNotices > 0 then
			enabled = true
		end
	end
	-- Select
	if self.isSelected then
		if #self.dropdownIcons > 0 or #self.menuIcons > 0 then
			enabled = false
		end
	end
	local value = (enabled and 0) or 1
	self:set("noticeImageTransparency", value)
	self:set("noticeTextTransparency", value)
	self.instances.noticeLabel.Text = (self.totalNotices < 100 and self.totalNotices) or "99+"
end

function Icon:clearNotices()
	self._endNotices:Fire()
	return self
end

function Icon:disableStateOverlay(bool)
	if bool == nil then
		bool = true
	end
	local stateOverlay = self.instances.iconOverlay
	stateOverlay.Visible = not bool
	return self
end



-- TOGGLEABLE METHODS
function Icon:setLabel(text, iconState)
	text = text or ""
	self:set("iconText", text, iconState)
	return self
end

function Icon:setCornerRadius(scale, offset, iconState)
	local oldCornerRadius = self.instances.iconCorner.CornerRadius
	local newCornerRadius = UDim.new(scale or oldCornerRadius.Scale, offset or oldCornerRadius.Offset)
	self:set("iconCornerRadius", newCornerRadius, iconState)
	return self
end

function Icon:setImage(imageId, iconState)
	local textureId = (tonumber(imageId) and "http://www.roblox.com/asset/?id="..imageId) or imageId or ""
	return self:set("iconImage", textureId, iconState)
end

function Icon:setOrder(order, iconState)
	local newOrder = tonumber(order) or 1
	return self:set("order", newOrder, iconState)
end

function Icon:setLeft(iconState)
	return self:set("alignment", "left", iconState)
end

function Icon:setMid(iconState)
	return self:set("alignment", "mid", iconState)
end

function Icon:setRight(iconState)
	if not self.internalIcon then
		IconController.setupHealthbar()
	end
	return self:set("alignment", "right", iconState)
end

function Icon:setImageYScale(YScale, iconState)
	local newYScale = tonumber(YScale) or 0.63
	return self:set("iconImageYScale", newYScale, iconState)
end

function Icon:setImageRatio(ratio, iconState)
	local newRatio = tonumber(ratio) or 1
	return self:set("iconImageRatio", newRatio, iconState)
end

function Icon:setLabelYScale(YScale, iconState)
	local newYScale = tonumber(YScale) or 0.45
	return self:set("iconLabelYScale", newYScale, iconState)
end
	
function Icon:setBaseZIndex(ZIndex, iconState)
	local newBaseZIndex = tonumber(ZIndex) or 1
	return self:set("baseZIndex", newBaseZIndex, iconState)
end

function Icon:_updateBaseZIndex(baseValue)
	local container = self.instances.iconContainer
	local newBaseValue = tonumber(baseValue) or container.ZIndex
	local difference = newBaseValue - container.ZIndex
	if difference == 0 then return "The baseValue is the same" end
	for _, object in pairs(self.instances) do
		if object:IsA("GuiObject") then
			object.ZIndex = object.ZIndex + difference
		end
	end
	return true
end

function Icon:setSize(XOffset, YOffset, iconState)
	if tonumber(XOffset) then
		self.forcefullyAppliedXSize = true
		self:set("forcedIconSizeX", tonumber(XOffset), iconState)
	else
		self.forcefullyAppliedXSize = false
		self:set("forcedIconSizeX", 32, iconState)
	end
	if tonumber(YOffset) then
		self.forcefullyAppliedYSize = true
		self:set("forcedIconSizeY", tonumber(YOffset), iconState)
	else
		self.forcefullyAppliedYSize = false
		self:set("forcedIconSizeY", 32, iconState)
	end
	local newXOffset = tonumber(XOffset) or 32
	local newYOffset = tonumber(YOffset) or (YOffset ~= "_NIL" and newXOffset) or 32
	self:set("iconSize", UDim2.new(0, newXOffset, 0, newYOffset), iconState)
	return self
end

function Icon:setXSize(XOffset, iconState)
	self:setSize(XOffset, "_NIL", iconState)
	return self
end

function Icon:setYSize(YOffset, iconState)
	self:setSize("_NIL", YOffset, iconState)
	return self
end

function Icon:_getContentText(text)
	-- This converts richtext (e.g. "<b>Shop</b>") to normal text (e.g. "Shop")
	-- This also converts richtext/normaltext into its localized (translated) version
	-- This is important when calculating the size of the label/box for instance
	self.instances.fakeIconLabel.Text = text
	local textToTranslate = self.instances.fakeIconLabel.ContentText
	local translatedContentText = typeof(self.instances.iconLabel) == "Instance" and IconController.translator:Translate(self.instances.iconLabel, textToTranslate)
	if typeof(translatedContentText) ~= "string" or translatedContentText == "" then
		translatedContentText = textToTranslate
	end
	self.instances.fakeIconLabel.Text = ""
	return translatedContentText
end

function Icon:_updateIconSize(_, iconState)
	if self._destroyed then return end
	-- This is responsible for handling the appearance and size of the icons label and image, in additon to its own size
	local X_MARGIN = 12
	local X_GAP = 8

	local values = {
		iconImage = self:get("iconImage", iconState) or "_NIL",
		iconText = self:get("iconText", iconState) or "_NIL",
		iconFont = self:get("iconFont", iconState) or "_NIL",
		iconSize = self:get("iconSize", iconState) or "_NIL",
		forcedIconSizeX = self:get("forcedIconSizeX", iconState) or "_NIL",
		iconImageYScale = self:get("iconImageYScale", iconState) or "_NIL",
		iconImageRatio = self:get("iconImageRatio", iconState) or "_NIL",
		iconLabelYScale = self:get("iconLabelYScale", iconState) or "_NIL",
	}
	for k,v in pairs(values) do
		if v == "_NIL" then
			return
		end
	end

	local iconContainer = self.instances.iconContainer
	if not iconContainer.Parent then return end

	-- We calculate the cells dimensions as apposed to reading because there's a possibility the cells dimensions were changed at the exact time and have not yet updated
	-- this essentially saves us from waiting a heartbeat which causes additonal complications
	local cellSizeXOffset = values.iconSize.X.Offset
	local cellSizeXScale = values.iconSize.X.Scale
	local cellWidth = cellSizeXOffset + (cellSizeXScale * iconContainer.Parent.AbsoluteSize.X)
	local minCellWidth = values.forcedIconSizeX--cellWidth
	local maxCellWidth = (cellSizeXScale > 0 and cellWidth) or (self.forcefullyAppliedXSize and minCellWidth) or 9999
	local cellSizeYOffset = values.iconSize.Y.Offset
	local cellSizeYScale = values.iconSize.Y.Scale
	local cellHeight = cellSizeYOffset + (cellSizeYScale * iconContainer.Parent.AbsoluteSize.Y)
	local labelHeight = cellHeight * values.iconLabelYScale
	local iconContentText = self:_getContentText(values.iconText)
	local labelWidth = textService:GetTextSize(iconContentText, labelHeight, values.iconFont, Vector2.new(10000, labelHeight)).X
	local imageWidth = cellHeight * values.iconImageYScale * values.iconImageRatio
	
	local usingImage = values.iconImage ~= ""
	local usingText = values.iconText ~= ""
	local notifPosYScale = 0.5
	local desiredCellWidth
	local preventClippingOffset = labelHeight/2
	
	if usingImage and not usingText then
		desiredCellWidth = 0
		notifPosYScale = 0.45
		self:set("iconImageVisible", true, iconState)
		self:set("iconImageAnchorPoint", Vector2.new(0.5, 0.5), iconState)
		self:set("iconImagePosition", UDim2.new(0.5, 0, 0.5, 0), iconState)
		self:set("iconImageSize", UDim2.new(values.iconImageYScale*values.iconImageRatio, 0, values.iconImageYScale, 0), iconState)
		self:set("iconLabelVisible", false, iconState)

	elseif not usingImage and usingText then
		desiredCellWidth = labelWidth+(X_MARGIN*2)
		self:set("iconLabelVisible", true, iconState)
		self:set("iconLabelAnchorPoint", Vector2.new(0, 0.5), iconState)
		self:set("iconLabelPosition", UDim2.new(0, X_MARGIN, 0.5, 0), iconState)
		self:set("iconLabelSize", UDim2.new(1, -X_MARGIN*2, values.iconLabelYScale, preventClippingOffset), iconState)
		self:set("iconLabelTextXAlignment", Enum.TextXAlignment.Center, iconState)
		self:set("iconImageVisible", false, iconState)

	elseif usingImage and usingText then
		local labelGap = X_MARGIN + imageWidth + X_GAP
		desiredCellWidth = labelGap + labelWidth + X_MARGIN
		self:set("iconImageVisible", true, iconState)
		self:set("iconImageAnchorPoint", Vector2.new(0, 0.5), iconState)
		self:set("iconImagePosition", UDim2.new(0, X_MARGIN, 0.5, 0), iconState)
		self:set("iconImageSize", UDim2.new(0, imageWidth, values.iconImageYScale, 0), iconState)
		----
		self:set("iconLabelVisible", true, iconState)
		self:set("iconLabelAnchorPoint", Vector2.new(0, 0.5), iconState)
		self:set("iconLabelPosition", UDim2.new(0, labelGap, 0.5, 0), iconState)
		self:set("iconLabelSize", UDim2.new(1, -labelGap-X_MARGIN, values.iconLabelYScale, preventClippingOffset), iconState)
		self:set("iconLabelTextXAlignment", Enum.TextXAlignment.Left, iconState)
	end
	if desiredCellWidth then
		if not self._updatingIconSize then
			self._updatingIconSize = true
			local widthScale = (cellSizeXScale > 0 and cellSizeXScale) or 0
			local widthOffset = (cellSizeXScale > 0 and 0) or math.clamp(desiredCellWidth, minCellWidth, maxCellWidth)
			self:set("iconSize", UDim2.new(widthScale, widthOffset, values.iconSize.Y.Scale, values.iconSize.Y.Offset), iconState, "_ignorePrevious")

			-- This ensures that if an icon is within a dropdown or menu, its container adapts accordingly with this new iconSize value
			local parentIcon = self._parentIcon
			if parentIcon then
				local originalIconSize = UDim2.new(0, desiredCellWidth, 0, values.iconSize.Y.Offset)
				if #parentIcon.dropdownIcons > 0 then
					self:setAdditionalValue("iconSize", "beforeDropdown", originalIconSize, iconState)
					parentIcon:_updateDropdown()
				end
				if #parentIcon.menuIcons > 0 then
					self:setAdditionalValue("iconSize", "beforeMenu", originalIconSize, iconState)
					parentIcon:_updateMenu()
				end
			end

			self._updatingIconSize = false
		end
	end
	self:set("iconLabelTextSize", labelHeight, iconState)
	self:set("noticeFramePosition", UDim2.new(notifPosYScale, 0, 0, -2), iconState)

	self._updatingIconSize = false
end



-- FEATURE METHODS
function Icon:bindEvent(iconEventName, eventFunction)
	local event = self[iconEventName]
	assert(event and typeof(event) == "table" and event.Connect, "argument[1] must be a valid topbarplus icon event name!")
	assert(typeof(eventFunction) == "function", "argument[2] must be a function!")
	self._bindedEvents[iconEventName] = event:Connect(function(...)
		eventFunction(self, ...)
	end)
	return self
end

function Icon:unbindEvent(iconEventName)
	local eventConnection = self._bindedEvents[iconEventName]
	if eventConnection then
		eventConnection:Disconnect()
		self._bindedEvents[iconEventName] = nil
	end
	return self
end

function Icon:bindToggleKey(keyCodeEnum)
	assert(typeof(keyCodeEnum) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
	self._bindedToggleKeys[keyCodeEnum] = true
	return self
end

function Icon:unbindToggleKey(keyCodeEnum)
	assert(typeof(keyCodeEnum) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
	self._bindedToggleKeys[keyCodeEnum] = nil
	return self
end

function Icon:lock()
	self.instances.iconButton.Active = false
	self.locked = true
	task.defer(function()
		-- We do this to prevent the overlay remaining enabled if :lock is called right after an icon is selected
		if self.locked then
			self.overlayLocked = true
		end
	end)
	return self
end

function Icon:unlock()
	self.instances.iconButton.Active = true
	self.locked = false
	self.overlayLocked = false
	return self
end

function Icon:debounce(seconds)
	self:lock()
	task.wait(seconds)
	self:unlock()
	return self
end

function Icon:autoDeselect(bool)
	if bool == nil then
		bool = true
	end
	self.deselectWhenOtherIconSelected = bool
	return self
end

function Icon:setTopPadding(offset, scale)
	local newOffset = offset or 4
	local newScale = scale or 0
	self.topPadding = UDim.new(newScale, newOffset)
	self.updated:Fire()
	return self
end

function Icon:bindToggleItem(guiObjectOrLayerCollector)
	if not guiObjectOrLayerCollector:IsA("GuiObject") and not guiObjectOrLayerCollector:IsA("LayerCollector") then
		error("Toggle item must be a GuiObject or LayerCollector!")
	end
	self.toggleItems[guiObjectOrLayerCollector] = true
	self:updateSelectionInstances()
	return self
end

function Icon:updateSelectionInstances()
	-- This is to assist with controller navigation and selection
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

function Icon:addBackBlocker(func)
	-- This is custom behaviour that can block the default behaviour of going back or closing a page when Controller B is pressed
	-- If the function returns ``true`` then the B Back behaviour is blocked
	-- This is useful for instance when a user is purchasing an item and you don't want them to return to the previous page
	-- if they pressed B during this pending period
	table.insert(self.blockBackBehaviourChecks, func)
	return self
end

function Icon:unbindToggleItem(guiObjectOrLayerCollector)
	self.toggleItems[guiObjectOrLayerCollector] = nil
	return self
end

function Icon:_setToggleItemsVisible(bool, byIcon)
	for toggleItem, _ in pairs(self.toggleItems) do
		if not byIcon or byIcon.toggleItems[toggleItem] == nil then
			local property = "Visible"
			if toggleItem:IsA("LayerCollector") then
				property = "Enabled"
			end
			toggleItem[property] = bool
		end
	end
end

function Icon:call(func)
	task.spawn(func, self)
	return self
end

function Icon:give(userdata)
	local valueToGive = userdata
	if typeof(userdata) == "function" then
		local returnValue = userdata(self)
		if typeof(userdata) ~= "function" then
			valueToGive = returnValue
		else
			valueToGive = nil
		end
	end
	if valueToGive ~= nil then
		self._maid:give(valueToGive)
	end
	return self
end

-- Tips
DEFAULT_FORCED_GROUP_VALUES["tip"] = 1

function Icon:setTip(text)
	assert(typeof(text) == "string" or text == nil, "Expected string, got "..typeof(text))
	local realText = text or ""
	local isVisible = realText ~= ""
	self.tipText = text
	self.instances.tipLabel.Text = realText
	self.instances.tipFrame.Parent = (isVisible and activeItems) or self.instances.iconContainer
	self._maid.tipFrame = self.instances.tipFrame
	self:_updateTipSize()
	
	local tipMaid = Maid.new()
	self._maid.tipMaid = tipMaid
	if isVisible then
		tipMaid:give(self.hoverStarted:Connect(function()
			if not self.isSelected then
				self:displayTip(true)
			end
		end))
		tipMaid:give(self.hoverEnded:Connect(function()
			self:displayTip(false)
		end))
		tipMaid:give(self.selected:Connect(function()
			if self.hovering then
				self:displayTip(false)
			end
		end))
	end
	self:displayTip(self.hovering and isVisible)
	return self
end

function Icon:_updateTipSize()
	local realText = self.tipText or ""
	local isVisible = realText ~= ""
	local iconContentText = self:_getContentText(realText)
	local textSize = textService:GetTextSize(iconContentText, 12, Enum.Font.GothamSemibold, Vector2.new(1000, 20-6))
	self.instances.tipFrame.Size = (isVisible and UDim2.new(0, textSize.X+6, 0, 20)) or UDim2.new(0, 0, 0, 0)
end

function Icon:displayTip(bool)
	if userInputService.TouchEnabled and not self._draggingFinger then return end

	-- Determine caption visibility
	local isVisible = self.tipVisible or false
	if typeof(bool) == "boolean" then
		isVisible = bool
	end
	self.tipVisible = isVisible

	-- Have tip position track mouse or finger
	local tipFrame = self.instances.tipFrame
	if isVisible then
		-- When the user moves their cursor/finger, update tip to match the position
		local function updateTipPositon(x, y)
			local newX = x
			local newY = y
			local camera = workspace.CurrentCamera
			local viewportSize = camera and camera.ViewportSize
			if userInputService.TouchEnabled then
				--tipFrame.AnchorPoint = Vector2.new(0.5, 0.5)
				local desiredX = newX - tipFrame.Size.X.Offset/2
				local minX = 0
				local maxX = viewportSize.X - tipFrame.Size.X.Offset
				local desiredY = newY + THUMB_OFFSET + 60
				local minY = tipFrame.AbsoluteSize.Y + THUMB_OFFSET + 64 + 3
				local maxY = viewportSize.Y - tipFrame.Size.Y.Offset
				newX = math.clamp(desiredX, minX, maxX)
				newY = math.clamp(desiredY, minY, maxY)
			elseif IconController.controllerModeEnabled then
				local indicator = TopbarPlusGui.Indicator
				local newPos = indicator.AbsolutePosition
				newX = newPos.X - tipFrame.Size.X.Offset/2 + indicator.AbsoluteSize.X/2
				newY = newPos.Y + 90
			else
				local desiredX = newX
				local minX = 0
				local maxX = viewportSize.X - tipFrame.Size.X.Offset - 48
				local desiredY = newY
				local minY = tipFrame.Size.Y.Offset+3
				local maxY = viewportSize.Y
				newX = math.clamp(desiredX, minX, maxX)
				newY = math.clamp(desiredY, minY, maxY)
			end
			--local difX = tipFrame.AbsolutePosition.X - tipFrame.Position.X.Offset
			--local difY = tipFrame.AbsolutePosition.Y - tipFrame.Position.Y.Offset
			--local globalX = newX - difX
			--local globalY = newY - difY
			--tipFrame.Position = UDim2.new(0, globalX, 0, globalY-55)
			tipFrame.Position = UDim2.new(0, newX, 0, newY-20)
		end
		local cursorLocation = userInputService:GetMouseLocation()
		if cursorLocation then
			updateTipPositon(cursorLocation.X, cursorLocation.Y)
		end
		self._hoveringMaid:give(self.instances.iconButton.MouseMoved:Connect(updateTipPositon))
	end

	-- Change transparency of relavent tip instances
	for _, settingName in pairs(self._groupSettings.tip) do
		local settingDetail = self._settingsDictionary[settingName]
		settingDetail.useForcedGroupValue = not isVisible
		self:_update(settingName)
	end
end

-- Captions
DEFAULT_FORCED_GROUP_VALUES["caption"] = 1

function Icon:setCaption(text)
	assert(typeof(text) == "string" or text == nil, "Expected string, got "..typeof(text))
	local realText = text or ""
	local isVisible = realText ~= ""
	self.captionText = text
	self.instances.captionLabel.Text = realText
	self.instances.captionContainer.Parent = (isVisible and activeItems) or self.instances.iconContainer
	self._maid.captionContainer = self.instances.captionContainer
	self:_updateIconSize(nil, self:getIconState())
	local captionMaid = Maid.new()
	self._maid.captionMaid = captionMaid
	if isVisible then
		captionMaid:give(self.hoverStarted:Connect(function()
			if not self.isSelected then
				self:displayCaption(true)
			end
		end))
		captionMaid:give(self.hoverEnded:Connect(function()
			self:displayCaption(false)
		end))
		captionMaid:give(self.selected:Connect(function()
			if self.hovering then
				self:displayCaption(false)
			end
		end))
		local iconContainer = self.instances.iconContainer
		captionMaid:give(iconContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			if self.hovering then
				self:displayCaption()
			end
		end))
		captionMaid:give(iconContainer:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
			if self.hovering then
				self:displayCaption()
			end
		end))
	end
	self:_updateCaptionSize()
	self:displayCaption(self.hovering and isVisible)
	return self
end

function Icon:_updateCaptionSize()
	-- This adapts the caption size
	local CAPTION_X_MARGIN = 6
	local CAPTION_CONTAINER_Y_SIZE_SCALE = 0.8
	local CAPTION_LABEL_Y_SCALE = 0.58
	local iconSize = self:get("iconSize")
	local labelFont = self:get("captionFont")
	if iconSize and labelFont then
		local cellSizeYOffset = iconSize.Y.Offset
		local cellSizeYScale = iconSize.Y.Scale
		local iconContainer = self.instances.iconContainer
		local captionContainer = self.instances.captionContainer
		local realText = self.captionText or ""
		local isVisible = realText ~= ""
		if isVisible then
			local cellHeight = cellSizeYOffset + (cellSizeYScale * iconContainer.Parent.AbsoluteSize.Y)
			local captionLabel = self.instances.captionLabel
			local captionContainerHeight = cellHeight * CAPTION_CONTAINER_Y_SIZE_SCALE
			local captionLabelHeight = captionContainerHeight * CAPTION_LABEL_Y_SCALE
			local iconContentText = self:_getContentText(self.captionText)
			local textWidth = textService:GetTextSize(iconContentText, captionLabelHeight, labelFont, Vector2.new(10000, captionLabelHeight)).X
			captionLabel.TextSize = captionLabelHeight
			captionLabel.Size = UDim2.new(0, textWidth, CAPTION_LABEL_Y_SCALE, 0)
			captionContainer.Size = UDim2.new(0, textWidth + CAPTION_X_MARGIN*2, 0, cellHeight*CAPTION_CONTAINER_Y_SIZE_SCALE)
		else
			captionContainer.Size = UDim2.new(0, 0, 0, 0)
		end
	end
end

function Icon:displayCaption(bool)
	if userInputService.TouchEnabled and not self._draggingFinger then return end
	local yOffset = 8
	
	-- Determine caption position
	if self._draggingFinger then
		yOffset = yOffset + THUMB_OFFSET
	end
	local iconContainer = self.instances.iconContainer
	local captionContainer = self.instances.captionContainer
	local newPos = UDim2.new(0, iconContainer.AbsolutePosition.X+iconContainer.AbsoluteSize.X/2-captionContainer.AbsoluteSize.X/2, 0, iconContainer.AbsolutePosition.Y+(iconContainer.AbsoluteSize.Y*2)+yOffset)
	captionContainer.Position = newPos

	-- Determine caption visibility
	local isVisible = self.captionVisible or false
	if typeof(bool) == "boolean" then
		isVisible = bool
	end
	self.captionVisible = isVisible

	-- Change transparency of relavent caption instances
	local captionFadeInfo = self:get("captionFadeInfo")
	for _, settingName in pairs(self._groupSettings.caption) do
		local settingDetail = self._settingsDictionary[settingName]
		settingDetail.useForcedGroupValue = not isVisible
		self:_update(settingName)
	end
end

-- Join or leave a special feature such as a Dropdown or Menu
function Icon:join(parentIcon, featureName, dontUpdate)
	if self._parentIcon then
		self:leave()
	end
	local newFeatureName = (featureName and featureName:lower()) or "dropdown"
	local beforeName = "before"..featureName:sub(1,1):upper()..featureName:sub(2)
	local parentFrame = parentIcon.instances[featureName.."Frame"]
	self.presentOnTopbar = false
	self.joinedFeatureName = featureName
	self._parentIcon = parentIcon
	self.instances.iconContainer.Parent = parentFrame
	for noticeId, noticeDetail in pairs(self.notices) do
		parentIcon:notify(noticeDetail.clearNoticeEvent, noticeId)
		--parentIcon:notify(noticeDetail.completeSignal, noticeId)
	end
	
	if featureName == "dropdown" then
		local squareCorners = parentIcon:get("dropdownSquareCorners")
		self:set("iconSize", UDim2.new(1, 0, 0, self:get("iconSize", "deselected").Y.Offset), "deselected", beforeName)
		self:set("iconSize", UDim2.new(1, 0, 0, self:get("iconSize", "selected").Y.Offset), "selected", beforeName)
		if squareCorners then
			self:set("iconCornerRadius", UDim.new(0, 0), "deselected", beforeName)
			self:set("iconCornerRadius", UDim.new(0, 0), "selected", beforeName)
		end
		self:set("captionBlockerTransparency", 0.4, nil, beforeName)
	end
	local array = parentIcon[newFeatureName.."Icons"]
	table.insert(array, self)
	if not dontUpdate then
		if featureName == "dropdown" then
			parentIcon:_updateDropdown()
		elseif featureName == "menu" then
			parentIcon:_updateMenu()
		end
	end
	parentIcon.deselectWhenOtherIconSelected = false
	--
	IconController:_updateSelectionGroup()
	self:_decideToCallSignal("dropdown")
	self:_decideToCallSignal("menu")
	--
	return self
end

function Icon:leave()
	if self._destroyed or self.instances.iconContainer.Parent == nil then
		return
	end
	local settingsToReset = {"iconSize", "captionBlockerTransparency", "iconCornerRadius"}
	local parentIcon = self._parentIcon
	self.instances.iconContainer.Parent = topbarContainer
	self.presentOnTopbar = true
	self.joinedFeatureName = nil
	local function scanFeature(t, prevReference, updateMethod)
		for i, otherIcon in pairs(t) do
			if otherIcon == self then
				for _, settingName in pairs(settingsToReset) do
					local states = {"deselected", "selected"}
					for _, toggleState in pairs(states) do
						local currentSetting, previousSetting = self:get(settingName, toggleState, prevReference)
						if previousSetting then
							self:set(settingName, previousSetting, toggleState)
						end
					end
				end
				table.remove(t, i)
				updateMethod(parentIcon)
				if #t == 0 then
					self._parentIcon.deselectWhenOtherIconSelected = true
				end
				break
			end
		end
	end
	scanFeature(parentIcon.dropdownIcons, "beforeDropdown", parentIcon._updateDropdown)
	scanFeature(parentIcon.menuIcons, "beforeMenu", parentIcon._updateMenu)
	--
	for noticeId, noticeDetail in pairs(self.notices) do
		local parentIconNoticeDetail = parentIcon.notices[noticeId]
		if parentIconNoticeDetail then
			parentIconNoticeDetail.completeSignal:Fire()
		end
	end
	--
	self._parentIcon = nil
	--
	IconController:_updateSelectionGroup()
	self:_decideToCallSignal("dropdown")
	self:_decideToCallSignal("menu")
	--
	return self
end

function Icon:_decideToCallSignal(featureName)
	local isOpen = self[featureName.."Open"]
	local previousIsOpenName = "_previous"..string.sub(featureName, 1, 1):upper()..featureName:sub(2).."Open"
	local previousIsOpen = self[previousIsOpenName]
	local totalIcons = #self[featureName.."Icons"]
	if isOpen and totalIcons > 0 and previousIsOpen == false then
		self[previousIsOpenName] = true
		self[featureName.."Opened"]:Fire()
	elseif (not isOpen or totalIcons == 0) and previousIsOpen == true then
		self[previousIsOpenName] = false
		self[featureName.."Closed"]:Fire()
	end
end

function Icon:_ignoreClipping(featureName)
	local ignoreClipping = self:get(featureName.."IgnoreClipping")
	if self._parentIcon then
		local maid = self["_"..featureName.."ClippingMaid"]
		local frame = self.instances[featureName.."Container"]
		maid:clean()
		if ignoreClipping then
			local fakeFrame = Instance.new("Frame")
			fakeFrame.Name = frame.Name.."FakeFrame"
			fakeFrame.ClipsDescendants = true
			fakeFrame.BackgroundTransparency = 1
			fakeFrame.Size = frame.Size
			fakeFrame.Position = frame.Position
			fakeFrame.Parent = activeItems
			--
			for a,b in pairs(frame:GetChildren()) do
				b.Parent = fakeFrame
			end
			--
			local function updateSize()
				local absoluteSize = frame.AbsoluteSize
				fakeFrame.Size = UDim2.new(0, absoluteSize.X, 0, absoluteSize.Y)
			end
			maid:give(frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				updateSize()
			end))
			updateSize()
			local function updatePos()
				local absolutePosition = frame.absolutePosition
				fakeFrame.Position = UDim2.new(0, absolutePosition.X, 0, absolutePosition.Y+36)
			end
			maid:give(frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
				updatePos()
			end))
			updatePos()
			maid:give(function()
				for a,b in pairs(fakeFrame:GetChildren()) do
					b.Parent = frame
				end
				fakeFrame.Name = "Destroying..."
				fakeFrame:Destroy()
			end)
		end
	end
	self._ignoreClippingChanged:Fire(featureName, ignoreClipping)
end

-- Dropdowns
function Icon:setDropdown(arrayOfIcons)
	-- Reset any previous icons
	for i, otherIcon in pairs(self.dropdownIcons) do
		otherIcon:leave()
	end
	-- Apply new icons
	if type(arrayOfIcons) == "table" then
		for i, otherIcon in pairs(arrayOfIcons) do
			otherIcon:join(self, "dropdown", true)
		end
	end
	-- Update dropdown
	self:_updateDropdown()
	return self
end

function Icon:_updateDropdown()
	local values = {
		maxIconsBeforeScroll = self:get("dropdownMaxIconsBeforeScroll") or "_NIL",
		minWidth = self:get("dropdownMinWidth") or "_NIL",
		padding = self:get("dropdownListPadding") or "_NIL",
		dropdownAlignment = self:get("dropdownAlignment") or "_NIL",
		iconAlignment = self:get("alignment") or "_NIL",
		scrollBarThickness = self:get("dropdownScrollBarThickness") or "_NIL",
	}
	for k, v in pairs(values) do if v == "_NIL" then return end end
	
	local YPadding = values.padding.Offset
	local dropdownContainer = self.instances.dropdownContainer
	local dropdownFrame = self.instances.dropdownFrame
	local dropdownList = self.instances.dropdownList
	local totalIcons = #self.dropdownIcons

	local lastVisibleIconIndex = (totalIcons > values.maxIconsBeforeScroll and values.maxIconsBeforeScroll) or totalIcons
	local newCanvasSizeY = -YPadding
	local newFrameSizeY = 0
	local newMinWidth = values.minWidth
	table.sort(self.dropdownIcons, function(a,b) return a:get("order") < b:get("order") end)
	for i = 1, totalIcons do
		local otherIcon = self.dropdownIcons[i]
		local _, otherIconSize = otherIcon:get("iconSize", nil, "beforeDropdown")
		local increment = otherIconSize.Y.Offset + YPadding
		if i <= lastVisibleIconIndex then
			newFrameSizeY = newFrameSizeY + increment
		end
		if i == totalIcons then
			newFrameSizeY = newFrameSizeY + increment/4
		end
		newCanvasSizeY = newCanvasSizeY + increment
		local otherIconWidth = otherIconSize.X.Offset --+ 4 + 100 -- the +100 is to allow for notices
		if otherIconWidth > newMinWidth then
			newMinWidth = otherIconWidth
		end
		-- This ensures the dropdown is navigated fully and correctly with a controller
		local prevIcon = (i == 1 and self) or self.dropdownIcons[i-1]
		local nextIcon = self.dropdownIcons[i+1]
		otherIcon.instances.iconButton.NextSelectionUp = prevIcon and prevIcon.instances.iconButton
		otherIcon.instances.iconButton.NextSelectionDown = nextIcon and nextIcon.instances.iconButton
	end

	local finalCanvasSizeY = (lastVisibleIconIndex == totalIcons and 0) or newCanvasSizeY
	self:set("dropdownCanvasSize", UDim2.new(0, 0, 0, finalCanvasSizeY))
	self:set("dropdownSize", UDim2.new(0, (newMinWidth+4)*2, 0, newFrameSizeY))

	-- Set alignment while considering screen bounds
	local dropdownAlignment = values.dropdownAlignment:lower()
	local alignmentDetails = {
		left = {
			AnchorPoint = Vector2.new(0, 0),
			PositionXScale = 0,
			ThicknessMultiplier = 0,
		},
		mid = {
			AnchorPoint = Vector2.new(0.5, 0),
			PositionXScale = 0.5,
			ThicknessMultiplier = 0.5,
		},
		right = {
			AnchorPoint = Vector2.new(0.5, 0),
			PositionXScale = 1,
			FrameAnchorPoint = Vector2.new(0, 0),
			FramePositionXScale = 0,
			ThicknessMultiplier = 1,
		}
	}
	local alignmentDetail = alignmentDetails[dropdownAlignment]
	if not alignmentDetail then
		alignmentDetail = alignmentDetails[values.iconAlignment:lower()]
	end
	dropdownContainer.AnchorPoint = alignmentDetail.AnchorPoint
	dropdownContainer.Position = UDim2.new(alignmentDetail.PositionXScale, 0, 1, YPadding+0)
	local scrollbarThickness = values.scrollBarThickness
	local newThickness = scrollbarThickness * alignmentDetail.ThicknessMultiplier
	local additionalOffset = (dropdownFrame.VerticalScrollBarPosition == Enum.VerticalScrollBarPosition.Right and newThickness) or -newThickness
	dropdownFrame.AnchorPoint = alignmentDetail.FrameAnchorPoint or alignmentDetail.AnchorPoint
	dropdownFrame.Position = UDim2.new(alignmentDetail.FramePositionXScale or alignmentDetail.PositionXScale, additionalOffset, 0, 0)
	self._dropdownCanvasPos = Vector2.new(0, 0)
end

function Icon:_dropdownIgnoreClipping()
	self:_ignoreClipping("dropdown")
end


-- Menus
function Icon:setMenu(arrayOfIcons)
	-- Reset any previous icons
	for i, otherIcon in pairs(self.menuIcons) do
		otherIcon:leave()
	end
	-- Apply new icons
	if type(arrayOfIcons) == "table" then
		for i, otherIcon in pairs(arrayOfIcons) do
			otherIcon:join(self, "menu", true)
		end
	end
	-- Update menu
	self:_updateMenu()
	return self
end

function Icon:_getMenuDirection()
	local direction = (self:get("menuDirection") or "_NIL"):lower()
	local alignment = (self:get("alignment") or "_NIL"):lower()
	if direction ~= "left" and direction ~= "right" then
		direction = (alignment == "left" and "right") or "left" 
	end
	return direction
end

function Icon:_updateMenu()
	local values = {
		maxIconsBeforeScroll = self:get("menuMaxIconsBeforeScroll") or "_NIL",
		direction = self:get("menuDirection") or "_NIL",
		iconAlignment = self:get("alignment") or "_NIL",
		scrollBarThickness = self:get("menuScrollBarThickness") or "_NIL",
	}
	for k, v in pairs(values) do if v == "_NIL" then return end end
	
	local XPadding = IconController[values.iconAlignment.."Gap"]--12
	local menuContainer = self.instances.menuContainer
	local menuFrame = self.instances.menuFrame
	local menuList = self.instances.menuList
	local totalIcons = #self.menuIcons

	local direction = self:_getMenuDirection()
	local lastVisibleIconIndex = (totalIcons > values.maxIconsBeforeScroll and values.maxIconsBeforeScroll) or totalIcons
	local newCanvasSizeX = -XPadding
	local newFrameSizeX = 0
	local newMinHeight = 0
	local sortFunc = (direction == "right" and function(a,b) return a:get("order") < b:get("order") end) or function(a,b) return a:get("order") > b:get("order") end
	table.sort(self.menuIcons, sortFunc)
	for i = 1, totalIcons do
		local otherIcon = self.menuIcons[i]
		local otherIconSize = otherIcon:get("iconSize")
		local increment = otherIconSize.X.Offset + XPadding
		if i <= lastVisibleIconIndex then
			newFrameSizeX = newFrameSizeX + increment
		end
		if i == lastVisibleIconIndex and i ~= totalIcons then
			newFrameSizeX = newFrameSizeX -2--(increment/4)
		end
		newCanvasSizeX = newCanvasSizeX + increment
		local otherIconHeight = otherIconSize.Y.Offset
		if otherIconHeight > newMinHeight then
			newMinHeight = otherIconHeight
		end
		-- This ensures the menu is navigated fully and correctly with a controller
		local prevIcon = self.menuIcons[i-1]
		local nextIcon = self.menuIcons[i+1]
		otherIcon.instances.iconButton.NextSelectionRight = prevIcon and prevIcon.instances.iconButton
		otherIcon.instances.iconButton.NextSelectionLeft = nextIcon and nextIcon.instances.iconButton
	end

	local canvasSize = (lastVisibleIconIndex == totalIcons and 0) or newCanvasSizeX + XPadding
	self:set("menuCanvasSize", UDim2.new(0, canvasSize, 0, 0))
	self:set("menuSize", UDim2.new(0, newFrameSizeX, 0, newMinHeight + values.scrollBarThickness + 3))

	-- Set direction
	local directionDetails = {
		left = {
			containerAnchorPoint = Vector2.new(1, 0),
			containerPosition = UDim2.new(0, -4, 0, 0),
			canvasPosition = Vector2.new(canvasSize, 0)
		},
		right = {
			containerAnchorPoint = Vector2.new(0, 0),
			containerPosition = UDim2.new(1, XPadding-2, 0, 0),
			canvasPosition = Vector2.new(0, 0),
		}
	}
	local directionDetail = directionDetails[direction]
	menuContainer.AnchorPoint = directionDetail.containerAnchorPoint
	menuContainer.Position = directionDetail.containerPosition
	menuFrame.CanvasPosition = directionDetail.canvasPosition
	self._menuCanvasPos = directionDetail.canvasPosition

	menuList.Padding = UDim.new(0, XPadding)
end

function Icon:_menuIgnoreClipping()
	self:_ignoreClipping("menu")
end



-- DESTROY/CLEANUP METHOD
function Icon:destroy()
	if self._destroyed then return end
	IconController.iconRemoved:Fire(self)
	self:clearNotices()
	if self._parentIcon then
		self:leave()
	end
	self:setDropdown()
	self:setMenu()
	self._destroyed = true
	self._maid:clean()
end
Icon.Destroy = Icon.destroy



return Icon end,
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(2)return "v2.9.1" end,
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(3)-- This module enables you to place Icon wherever you like within the data model while
-- still enabling third-party applications (such as HDAdmin/Nanoblox) to locate it
-- This is necessary to prevent two TopbarPlus applications initiating at runtime which would
-- cause icons to overlap with each other

local replicatedStorage = game:GetService("ReplicatedStorage")
local TopbarPlusReference = {}

function TopbarPlusReference.addToReplicatedStorage()
    local existingItem = replicatedStorage:FindFirstChild(script.Name)
    if existingItem then
        return false
    end
    local objectValue = Instance.new("ObjectValue")
    objectValue.Name = script.Name
    objectValue.Value = script.Parent
    objectValue.Parent = replicatedStorage
    return objectValue
end

function TopbarPlusReference.getObject()
    local objectValue = replicatedStorage:FindFirstChild(script.Name)
    if objectValue then
        return objectValue
    end
    return false
end

return TopbarPlusReference end,
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(4)-- SETUP ICON TEMPLATE
local topbarPlusGui = Instance.new("ScreenGui")
topbarPlusGui.Enabled = true
topbarPlusGui.DisplayOrder = 0
topbarPlusGui.IgnoreGuiInset = true
topbarPlusGui.ResetOnSpawn = false
topbarPlusGui.Name = "TopbarPlus"

local activeItems = Instance.new("Folder")
activeItems.Name = "ActiveItems"
activeItems.Parent = topbarPlusGui

local topbarContainer = Instance.new("Frame")
topbarContainer.BackgroundTransparency = 1
topbarContainer.Name = "TopbarContainer"
topbarContainer.Position = UDim2.new(0, 0, 0, 0)
topbarContainer.Size = UDim2.new(1, 0, 0, 36)
topbarContainer.Visible = true
topbarContainer.ZIndex = 1
topbarContainer.Parent = topbarPlusGui
topbarContainer.Active = false

local iconContainer = Instance.new("Frame")
iconContainer.BackgroundTransparency = 1
iconContainer.Name = "IconContainer"
iconContainer.Position = UDim2.new(0, 104, 0, 4)
iconContainer.Visible = false
iconContainer.ZIndex = 1
iconContainer.Parent = topbarContainer
iconContainer.Active = false

local iconButton = Instance.new("TextButton")
iconButton.Name = "IconButton"
iconButton.Visible = true
iconButton.Text = ""
iconButton.ZIndex = 10--2
iconButton.BorderSizePixel = 0
iconButton.AutoButtonColor = false
iconButton.Parent = iconContainer
iconButton.Active = true
iconButton.TextTransparency = 1
iconButton.RichText = true

local iconImage = Instance.new("ImageLabel")
iconImage.BackgroundTransparency = 1
iconImage.Name = "IconImage"
iconImage.AnchorPoint = Vector2.new(0, 0.5)
iconImage.Visible = true
iconImage.ZIndex = 11--3
iconImage.ScaleType = Enum.ScaleType.Fit
iconImage.Parent = iconButton
iconImage.Active = false

local iconLabel = Instance.new("TextLabel")
iconLabel.BackgroundTransparency = 1
iconLabel.Name = "IconLabel"
iconLabel.AnchorPoint = Vector2.new(0, 0.5)
iconLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
iconLabel.Text = ""
iconLabel.RichText = true
iconLabel.TextScaled = false
iconLabel.ClipsDescendants = true
iconLabel.ZIndex = 11--3
iconLabel.Active = false
iconLabel.AutoLocalize = true
iconLabel.Parent = iconButton

local fakeIconLabel = iconLabel:Clone()
fakeIconLabel.Name = "FakeIconLabel"
fakeIconLabel.AnchorPoint = Vector2.new(0, 0)
fakeIconLabel.Position = UDim2.new(0, 0, 0, 0)
fakeIconLabel.Size = UDim2.new(1, 0, 1, 0)
fakeIconLabel.TextTransparency = 1
fakeIconLabel.AutoLocalize = false
fakeIconLabel.Parent = iconLabel.Parent

local iconGradient = Instance.new("UIGradient")
iconGradient.Name = "IconGradient"
iconGradient.Enabled = true
iconGradient.Parent = iconButton

local iconCorner = Instance.new("UICorner")
iconCorner.Name = "IconCorner"
iconCorner.Parent = iconButton

local iconOverlay = Instance.new("Frame")
iconOverlay.Name = "IconOverlay"
iconOverlay.BackgroundTransparency = 1
iconOverlay.Position = iconButton.Position
iconOverlay.Size = UDim2.new(1, 0, 1, 0)
iconOverlay.Visible = true
iconOverlay.ZIndex = iconButton.ZIndex + 1
iconOverlay.BorderSizePixel = 0
iconOverlay.Parent = iconContainer
iconOverlay.Active = false

local iconOverlayCorner = iconCorner:Clone()
iconOverlayCorner.Name = "IconOverlayCorner"
iconOverlayCorner.Parent = iconOverlay


-- Notice prompts
local noticeFrame = Instance.new("ImageLabel")
noticeFrame.BackgroundTransparency = 1
noticeFrame.Name = "NoticeFrame"
noticeFrame.Position = UDim2.new(0.45, 0, 0, -2)
noticeFrame.Size = UDim2.new(1, 0, 0.7, 0)
noticeFrame.Visible = true
noticeFrame.ZIndex = 12--4
noticeFrame.ImageTransparency = 1
noticeFrame.ScaleType = Enum.ScaleType.Fit
noticeFrame.Parent = iconButton
noticeFrame.Active = false

local noticeLabel = Instance.new("TextLabel")
noticeLabel.Name = "NoticeLabel"
noticeLabel.BackgroundTransparency = 1
noticeLabel.Position = UDim2.new(0.25, 0, 0.15, 0)
noticeLabel.Size = UDim2.new(0.5, 0, 0.7, 0)
noticeLabel.Visible = true
noticeLabel.ZIndex = 13--5
noticeLabel.Font = Enum.Font.Arial
noticeLabel.Text = "0"
noticeLabel.TextTransparency = 1
noticeLabel.TextScaled = true
noticeLabel.Parent = noticeFrame
noticeLabel.Active = false


-- Captions
local captionContainer = Instance.new("Frame")
captionContainer.Name = "CaptionContainer"
captionContainer.BackgroundTransparency = 1
captionContainer.AnchorPoint = Vector2.new(0, 0)
captionContainer.ClipsDescendants = true
captionContainer.ZIndex = 30
captionContainer.Visible = true
captionContainer.Parent = iconContainer
captionContainer.Active = false

local captionFrame = Instance.new("Frame")
captionFrame.Name = "CaptionFrame"
captionFrame.BorderSizePixel = 0
captionFrame.AnchorPoint = Vector2.new(0.5,0.5)
captionFrame.Position = UDim2.new(0.5,0,0.5,0)
captionFrame.Size = UDim2.new(1,0,1,0)
captionFrame.ZIndex = 31
captionFrame.Parent = captionContainer
captionFrame.Active = false

local captionLabel = Instance.new("TextLabel")
captionLabel.Name = "CaptionLabel"
captionLabel.BackgroundTransparency = 1
captionLabel.AnchorPoint = Vector2.new(0.5,0.5)
captionLabel.Position = UDim2.new(0.5,0,0.56,0)
captionLabel.TextXAlignment = Enum.TextXAlignment.Center
captionLabel.RichText = true
captionLabel.ZIndex = 32
captionLabel.Parent = captionContainer
captionLabel.Active = false

local captionCorner = Instance.new("UICorner")
captionCorner.Name = "CaptionCorner"
captionCorner.Parent = captionFrame

local captionOverlineContainer = Instance.new("Frame")
captionOverlineContainer.Name = "CaptionOverlineContainer"
captionOverlineContainer.BackgroundTransparency = 1
captionOverlineContainer.AnchorPoint = Vector2.new(0.5,0.5)
captionOverlineContainer.Position = UDim2.new(0.5,0,-0.5,3)
captionOverlineContainer.Size = UDim2.new(1,0,1,0)
captionOverlineContainer.ZIndex = 33
captionOverlineContainer.ClipsDescendants = true
captionOverlineContainer.Parent = captionContainer
captionOverlineContainer.Active = false

local captionOverline = Instance.new("Frame")
captionOverline.Name = "CaptionOverline"
captionOverline.AnchorPoint = Vector2.new(0.5,0.5)
captionOverline.Position = UDim2.new(0.5,0,1.5,-3)
captionOverline.Size = UDim2.new(1,0,1,0)
captionOverline.ZIndex = 34
captionOverline.Parent = captionOverlineContainer
captionOverline.Active = false

local captionOverlineCorner = captionCorner:Clone()
captionOverlineCorner.Name = "CaptionOverlineCorner"
captionOverlineCorner.Parent = captionOverline

local captionVisibilityBlocker = captionFrame:Clone()
captionVisibilityBlocker.Name = "CaptionVisibilityBlocker"
captionVisibilityBlocker.BackgroundTransparency = 1
captionVisibilityBlocker.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
captionVisibilityBlocker.ZIndex -= 1
captionVisibilityBlocker.Parent = captionFrame
captionVisibilityBlocker.Active = false

local captionVisibilityCorner = captionVisibilityBlocker.CaptionCorner
captionVisibilityCorner.Name = "CaptionVisibilityCorner"


-- Tips
local tipFrame = Instance.new("Frame")
tipFrame.Name = "TipFrame"
tipFrame.BorderSizePixel = 0
tipFrame.AnchorPoint = Vector2.new(0, 0)
tipFrame.Position = UDim2.new(0,50,0,50)
tipFrame.Size = UDim2.new(1,0,1,-8)
tipFrame.ZIndex = 40
tipFrame.Parent = iconContainer
tipFrame.Active = false

local tipCorner = Instance.new("UICorner")
tipCorner.Name = "TipCorner"
tipCorner.CornerRadius = UDim.new(0.25,0)
tipCorner.Parent = tipFrame

local tipLabel = Instance.new("TextLabel")
tipLabel.Name = "TipLabel"
tipLabel.BackgroundTransparency = 1
tipLabel.TextScaled = false
tipLabel.TextSize = 12
tipLabel.Position = UDim2.new(0,3,0,3)
tipLabel.Size = UDim2.new(1,-6,1,-6)
tipLabel.ZIndex = 41
tipLabel.RichText = true
tipLabel.Parent = tipFrame
tipLabel.Active = false


-- Dropdowns
local dropdownContainer = Instance.new("Frame")
dropdownContainer.Name = "DropdownContainer"
dropdownContainer.BackgroundTransparency = 1
dropdownContainer.BorderSizePixel = 0
dropdownContainer.AnchorPoint = Vector2.new(0.5, 0)
dropdownContainer.ZIndex = -2
dropdownContainer.ClipsDescendants = true
dropdownContainer.Visible = true
dropdownContainer.Parent = iconContainer
dropdownContainer.Selectable = false
dropdownContainer.Active = false

local dropdownFrame = Instance.new("ScrollingFrame")
dropdownFrame.Name = "DropdownFrame"
dropdownFrame.BackgroundTransparency = 1
dropdownFrame.BorderSizePixel = 0
dropdownFrame.AnchorPoint = Vector2.new(0.5, 0)
dropdownFrame.Position = UDim2.new(0.5, 0, 0, 0)
dropdownFrame.Size = UDim2.new(0.5, 2, 1, 0)
dropdownFrame.ZIndex = -1
dropdownFrame.ClipsDescendants = false
dropdownFrame.Visible = true
dropdownFrame.TopImage = dropdownFrame.MidImage
dropdownFrame.BottomImage = dropdownFrame.MidImage
dropdownFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always
dropdownFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
dropdownFrame.Parent = dropdownContainer
dropdownFrame.Active = false
dropdownFrame.Selectable = false
dropdownFrame.ScrollingEnabled = false

local dropdownList = Instance.new("UIListLayout")
dropdownList.Name = "DropdownList"
dropdownList.FillDirection = Enum.FillDirection.Vertical
dropdownList.SortOrder = Enum.SortOrder.LayoutOrder
dropdownList.Parent = dropdownFrame

local dropdownPadding = Instance.new("UIPadding")
dropdownPadding.Name = "DropdownPadding"
dropdownPadding.PaddingRight = UDim.new(0, 2)
dropdownPadding.Parent = dropdownFrame


-- Menus
local menuContainer = Instance.new("Frame")
menuContainer.Name = "MenuContainer"
menuContainer.BackgroundTransparency = 1
menuContainer.BorderSizePixel = 0
menuContainer.AnchorPoint = Vector2.new(1, 0)
menuContainer.Size = UDim2.new(0, 500, 0, 50)
menuContainer.ZIndex = -2
menuContainer.ClipsDescendants = true
menuContainer.Visible = true
menuContainer.Parent = iconContainer
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


-- Click Sound
local clickSound = Instance.new("Sound")
clickSound.Name = "ClickSound"
clickSound.Volume = 0
clickSound.Parent = iconContainer


-- Other
local indicator = Instance.new("ImageLabel")
indicator.Name = "Indicator"
indicator.BackgroundTransparency = 1
indicator.Image = "rbxassetid://5278151556"
indicator.Size = UDim2.new(0,32,0,32)
indicator.AnchorPoint = Vector2.new(0.5,0)
indicator.Position = UDim2.new(0.5,0,0,5)
indicator.ScaleType = Enum.ScaleType.Fit
indicator.Visible = false
indicator.Active = true
indicator.Parent = topbarPlusGui
indicator.Active = false



-- PARENT
local localPlayer = game:GetService("Players").LocalPlayer
local playerGui = localPlayer.PlayerGui
topbarPlusGui.Parent = playerGui



return topbarPlusGui end,
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(5)-- Require all children and return their references
local Themes = {}
for _, module in pairs(script:GetChildren()) do
    if module:IsA("ModuleScript") then
        Themes[module.Name] = require(module)
    end
end
return Themes end,
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(6)--[[
This file is necessary for constructing the default Icon template
Do not remove this module otherwise TopbarPlus will break
Modifying this file may also cause TopbarPlus to break
It's recommended instead to create a separate theme module and use that instead

To apply your theme after creating it, do:
```lua
local IconController = require(pathway.to.IconController)
local Themes = require(pathway.to.Themes)
IconController.setGameTheme(Themes.YourThemeName)
```

or by applying to an individual icon:
```lua
local Icon = require(pathway.to.Icon)
local Themes = require(pathway.to.Themes)
local newIcon = Icon.new()
    :setTheme(Themes.YourThemeName)
```
--]]

return {
    
    -- Settings which describe how an item behaves or transitions between states
    action =  {
        toggleTransitionInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        resizeInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        repositionInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        captionFadeInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        tipFadeInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        dropdownSlideInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        menuSlideInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    },

    -- Settings which describe how an item appears when 'deselected' and 'selected'
    toggleable = {
        -- How items appear normally (i.e. when they're 'deselected')
        deselected = {
            iconBackgroundColor = Color3.fromRGB(0, 0, 0),
            iconBackgroundTransparency = 0.5,
            iconCornerRadius = UDim.new(0.25, 0),
            iconGradientColor = ColorSequence.new(Color3.fromRGB(255, 255, 255)),
            iconGradientRotation = 0,
            iconImage = "",
            iconImageColor =Color3.fromRGB(255, 255, 255),
            iconImageTransparency = 0,
            iconImageYScale = 0.63,
            iconImageRatio = 1,
            iconLabelYScale = 0.45,
            iconScale = UDim2.new(1, 0, 1, 0),
            forcedIconSizeX = 32;
            forcedIconSizeY = 32;
            iconSize = UDim2.new(0, 32, 0, 32),
            iconOffset = UDim2.new(0, 0, 0, 0),
            iconText = "",
            iconTextColor = Color3.fromRGB(255, 255, 255),
            iconFont = Enum.Font.GothamSemibold,
            noticeCircleColor = Color3.fromRGB(255, 255, 255),
            noticeCircleImage = "http://www.roblox.com/asset/?id=4871790969",
            noticeTextColor = Color3.fromRGB(31, 33, 35),
            baseZIndex = 1,
            order = 1,
            alignment = "left",
            clickSoundId = "rbxassetid://5273899897",
            clickVolume = 0,
            clickPlaybackSpeed = 1,
            clickTimePosition = 0.12
        },
        -- How items appear after the icon has been clicked (i.e. when they're 'selected')
        -- If a selected value is not specified, it will default to the deselected value
        selected = {
            iconBackgroundColor = Color3.fromRGB(245, 245, 245),
            iconBackgroundTransparency = 0.1,
            iconImageColor = Color3.fromRGB(57, 60, 65),
            iconTextColor = Color3.fromRGB(57, 60, 65),
            clickPlaybackSpeed = 1.5,
        }
    },

    -- Settings where toggleState doesn't matter (they have a singular state)
    other = {
        -- Caption settings
        captionBackgroundColor = Color3.fromRGB(0, 0, 0),
        captionBackgroundTransparency = 0.5,
        captionTextColor = Color3.fromRGB(255, 255, 255),
        captionTextTransparency = 0,
        captionFont = Enum.Font.GothamSemibold,
        captionOverlineColor = Color3.fromRGB(0, 170, 255),
        captionOverlineTransparency = 0,
        captionCornerRadius = UDim.new(0.25, 0),
        -- Tip settings
        tipBackgroundColor = Color3.fromRGB(255, 255, 255),
        tipBackgroundTransparency = 0.1,
        tipTextColor = Color3.fromRGB(27, 42, 53),
        tipTextTransparency = 0,
        tipFont = Enum.Font.GothamSemibold,
        tipCornerRadius = UDim.new(0.175, 0),
        -- Dropdown settings
        dropdownAlignment = "auto", -- 'left', 'mid', 'right' or 'auto' (auto is where the dropdown alignment matches the icons alignment)
        dropdownMaxIconsBeforeScroll = 3,
        dropdownMinWidth = 32,
        dropdownSquareCorners = false,
        dropdownBindToggleToIcon = true,
        dropdownToggleOnLongPress = false,
        dropdownToggleOnRightClick = false,
        dropdownCloseOnTapAway = false,
        dropdownHidePlayerlistOnOverlap = true,
        dropdownListPadding = UDim.new(0, 2),
        dropdownScrollBarColor = Color3.fromRGB(25, 25, 25),
        dropdownScrollBarTransparency = 0.2,
        dropdownScrollBarThickness = 4,
        -- Menu settings
        menuDirection = "auto", -- 'left', 'right' or 'auto' (for auto, if alignment is 'left' or 'mid', menuDirection will be 'right', else menuDirection is 'left')
        menuMaxIconsBeforeScroll = 4,
        menuBindToggleToIcon = true,
        menuToggleOnLongPress = false,
        menuToggleOnRightClick = false,
        menuCloseOnTapAway = false,
        menuScrollBarColor = Color3.fromRGB(25, 25, 25),
        menuScrollBarTransparency = 0.2,
        menuScrollBarThickness = 4,
    },
    
} end,
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(7)-- BlueGradient by ForeverHD
local selectedColor = Color3.fromRGB(0, 170, 255)
local selectedColorDarker = Color3.fromRGB(0, 120, 180)
local neutralColor = Color3.fromRGB(255, 255, 255)
return {
    
    -- Settings which describe how an item behaves or transitions between states
    action =  {
        resizeInfo = TweenInfo.new(0.2, Enum.EasingStyle.Back),
        repositionInfo = TweenInfo.new(0.2, Enum.EasingStyle.Back),
    },
    
    -- Settings which describe how an item appears when 'deselected' and 'selected'
    toggleable = {
        -- How items appear normally (i.e. when they're 'deselected')
        deselected = {
            iconGradientColor = ColorSequence.new(selectedColor, selectedColorDarker),
            iconGradientRotation = 90,
            noticeCircleColor = selectedColor,
            noticeCircleImage = "http://www.roblox.com/asset/?id=4882430005",
            noticeTextColor = neutralColor,
            captionOverlineColor = selectedColor,
        },
        -- How items appear after the icon has been clicked (i.e. when they're 'selected')
        -- If a selected value is not specified, it will default to the deselected value
        selected = {
            iconBackgroundColor = Color3.fromRGB(255, 255, 255),
            iconBackgroundTransparency = 0.1,
            iconGradientColor = ColorSequence.new(selectedColor, selectedColorDarker),
            iconGradientRotation = 90,
            iconImageColor = Color3.fromRGB(255, 255, 255),
            iconTextColor = Color3.fromRGB(255, 255, 255),
            noticeCircleColor = neutralColor,
            noticeTextColor = selectedColor,
        }
    },
    
    -- Settings where toggleState doesn't matter (they have a singular state)
    other =  {},
    
}
 end,
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(8)--[=[
	A class which holds data and methods for ScriptSignals.

	@class ScriptSignal
]=]
local ScriptSignal = {}
ScriptSignal.__index = ScriptSignal

--[=[
	A class which holds data and methods for ScriptConnections.

	@class ScriptConnection
]=]
local ScriptConnection = {}
ScriptConnection.__index = ScriptConnection

--[=[
	A boolean which determines if a ScriptConnection is active or not.

	@prop Connected boolean
	@within ScriptConnection

	@readonly
	@ignore
]=]


export type Class = typeof( setmetatable({
	_active = true,
	_head = nil :: ScriptConnectionNode?
}, ScriptSignal) )

export type ScriptConnection = typeof( setmetatable({
	Connected = true,
	_node = nil :: ScriptConnectionNode?
}, ScriptConnection) )

type ScriptConnectionNode = {
	_signal: Class,
	_connection: ScriptConnection?,
	_handler: (...any) -> (),

	_next: ScriptConnectionNode?,
	_prev: ScriptConnectionNode?
}


local FreeThread: thread? = nil

local function RunHandlerInFreeThread(handler, ...)
	local thread = FreeThread :: thread
	FreeThread = nil

	handler(...)

	FreeThread = thread
end

local function CreateFreeThread()
	FreeThread = coroutine.running()

	while true do
		RunHandlerInFreeThread( coroutine.yield() )
	end
end

--[=[
	Creates a ScriptSignal object.

	@return ScriptSignal
	@ignore
]=]
function ScriptSignal.new(): Class
	return setmetatable({
		_active = true,
		_head = nil
	}, ScriptSignal)
end

--[=[
	Returns a boolean determining if the object is a ScriptSignal.

	```lua
	local janitor = Janitor.new()
	local signal = ScriptSignal.new()

	ScriptSignal.Is(signal) -> true
	ScriptSignal.Is(janitor) -> false
	```

	@param object any
	@return boolean
	@ignore
]=]
function ScriptSignal.Is(object): boolean
	return typeof(object) == 'table'
		and getmetatable(object) == ScriptSignal
end

--[=[
	Returns a boolean determing if a ScriptSignal object is active.

	```lua
	ScriptSignal:IsActive() -> true
	ScriptSignal:Destroy()
	ScriptSignal:IsActive() -> false
	```

	@return boolean
	@ignore
]=]
function ScriptSignal:IsActive(): boolean
	return self._active == true
end

--[=[
	Connects a handler to a ScriptSignal object.

	```lua
	ScriptSignal:Connect(function(text)
		print(text)
	end)

	ScriptSignal:Fire("Something")
	ScriptSignal:Fire("Something else")

	-- "Something" and then "Something else" are printed
	```

	@param handler (...: any) -> ()
	@return ScriptConnection
	@ignore
]=]
function ScriptSignal:Connect(
	handler: (...any) -> ()
): ScriptConnection

	assert(
		typeof(handler) == 'function',
		"Must be function"
	)

	if self._active ~= true then
		return setmetatable({
			Connected = false,
			_node = nil
		}, ScriptConnection)
	end

	local _head: ScriptConnectionNode? = self._head

	local node: ScriptConnectionNode = {
		_signal = self :: Class,
		_connection = nil,
		_handler = handler,

		_next = _head,
		_prev = nil
	}

	if _head ~= nil then
		_head._prev = node
	end

	self._head = node

	local connection = setmetatable({
		Connected = true,
		_node = node
	}, ScriptConnection)

	node._connection = connection

	return connection :: ScriptConnection
end

--[=[
	Connects a handler to a ScriptSignal object, but only allows that
	connection to run once. Any `:Fire` calls called afterwards won't trigger anything.

	```lua
	ScriptSignal:ConnectOnce(function()
		print("Connection fired")
	end)

	ScriptSignal:Fire()
	ScriptSignal:Fire()

	-- "Connection fired" is only fired once
	```

	@param handler (...: any) -> ()
	@ignore
]=]
function ScriptSignal:ConnectOnce(
	handler: (...any) -> ()
)
	assert(
		typeof(handler) == 'function',
		"Must be function"
	)

	local connection
	connection = self:Connect(function(...)
		connection:Disconnect()
		handler(...)
	end)
end

--[=[
	Yields the thread until a `:Fire` call occurs, returns what the signal was fired with.

	```lua
	task.spawn(function()
		print(
			ScriptSignal:Wait()
		)
	end)

	ScriptSignal:Fire("Arg", nil, 1, 2, 3, nil)
	-- "Arg", nil, 1, 2, 3, nil are printed
	```

	@yields
	@return ...any
	@ignore
]=]
function ScriptSignal:Wait(): (...any)
	local thread do
		thread = coroutine.running()

		local connection
		connection = self:Connect(function(...)
			connection:Disconnect()
			task.spawn(thread, ...)
		end)
	end

	return coroutine.yield()
end

--[=[
	Fires a ScriptSignal object with the arguments passed.

	```lua
	ScriptSignal:Connect(function(text)
		print(text)
	end)

	ScriptSignal:Fire("Some Text...")

	-- "Some Text..." is printed twice
	```

	@param ... any
	@ignore
]=]
function ScriptSignal:Fire(...: any)
	local node: ScriptConnectionNode? = self._head
	while node ~= nil do
		if node._connection ~= nil then
			if FreeThread == nil then
				task.spawn(CreateFreeThread)
			end

			task.spawn(
				FreeThread :: thread,
				node._handler, ...
			)
		end

		node = node._next
	end
end

--[=[
	Disconnects all connections from a ScriptSignal object without making it unusable.

	```lua
	local connection = ScriptSignal:Connect(function() end)

	connection.Connected -> true
	ScriptSignal:DisconnectAll()
	connection.Connected -> false
	```

	@ignore
]=]
function ScriptSignal:DisconnectAll()
	local node: ScriptConnectionNode? = self._head
	while node ~= nil do
		local _connection = node._connection

		if _connection ~= nil then
			_connection.Connected = false
			_connection._node = nil
			node._connection = nil
		end

		node = node._next
	end

	self._head = nil
end

--[=[
	Destroys a ScriptSignal object, disconnecting all connections and making it unusable.

	```lua
	ScriptSignal:Destroy()

	local connection = ScriptSignal:Connect(function() end)
	connection.Connected -> false
	```

	@ignore
]=]
function ScriptSignal:Destroy()
	if self._active ~= true then
		return
	end

	self:DisconnectAll()
	self._active = false
end

--[=[
	Disconnects a connection, any `:Fire` calls from now on will not
	invoke this connection's handler.

	```lua
	local connection = ScriptSignal:Connect(function() end)

	connection.Connected -> true
	connection:Disconnect()
	connection.Connected -> false
	```

	@ignore
]=]
function ScriptConnection:Disconnect()
	if self.Connected ~= true then
		return
	end

	self.Connected = false

	local _node: ScriptConnectionNode = self._node
	local _prev = _node._prev
	local _next = _node._next

	if _next ~= nil then
		_next._prev = _prev
	end

	if _prev ~= nil then
		_prev._next = _next
	else
		-- _node == _signal._head

		_node._signal._head = _next
	end

	_node._connection = nil
	self._node = nil
end

-- Compatibility methods for TopbarPlus
ScriptConnection.destroy = ScriptConnection.Disconnect
ScriptConnection.Destroy = ScriptConnection.Disconnect
ScriptConnection.disconnect = ScriptConnection.Disconnect
ScriptSignal.destroy = ScriptSignal.Destroy
ScriptSignal.Disconnect = ScriptSignal.Destroy
ScriptSignal.disconnect = ScriptSignal.Destroy

ScriptSignal.connect = ScriptSignal.Connect
ScriptSignal.wait = ScriptSignal.Wait
ScriptSignal.fire = ScriptSignal.Fire

return ScriptSignal end,
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(9)-- Maid
-- Author: Quenty
-- Source: https://github.com/Quenty/NevermoreEngine/blob/8ef4242a880c645b2f82a706e8074e74f23aab06/Modules/Shared/Events/Maid.lua
-- License: MIT (https://github.com/Quenty/NevermoreEngine/blob/version2/LICENSE.md)


---	Manages the cleaning of events and other things.
-- Useful for encapsulating state and make deconstructors easy
-- @classmod Maid
-- @see Signal

local Maid = {}
Maid.ClassName = "Maid"

--- Returns a new Maid object
-- @constructor Maid.new()
-- @treturn Maid
function Maid.new()
	return setmetatable({
		_tasks = {}
	}, Maid)
end

function Maid.isMaid(value)
	return type(value) == "table" and value.ClassName == "Maid"
end

--- Returns Maid[key] if not part of Maid metatable
-- @return Maid[key] value
function Maid:__index(index)
	if Maid[index] then
		return Maid[index]
	else
		return self._tasks[index]
	end
end

--- Add a task to clean up. Tasks given to a maid will be cleaned when
--  maid[index] is set to a different value.
-- @usage
-- Maid[key] = (function)         Adds a task to perform
-- Maid[key] = (event connection) Manages an event connection
-- Maid[key] = (Maid)             Maids can act as an event connection, allowing a Maid to have other maids to clean up.
-- Maid[key] = (Object)           Maids can cleanup objects with a `Destroy` method
-- Maid[key] = nil                Removes a named task. If the task is an event, it is disconnected. If it is an object,
--                                it is destroyed.
function Maid:__newindex(index, newTask)
	if Maid[index] ~= nil then
		error(("'%s' is reserved"):format(tostring(index)), 2)
	end

	local tasks = self._tasks
	local oldTask = tasks[index]

	if oldTask == newTask then
		return
	end

	tasks[index] = newTask

	if oldTask then
		if type(oldTask) == "function" then
			oldTask()
		elseif typeof(oldTask) == "RBXScriptConnection" then
			oldTask:Disconnect()
		elseif oldTask.Destroy then
			oldTask:Destroy()
		elseif oldTask.destroy then
			oldTask:destroy()
		end
	end
end

--- Same as indexing, but uses an incremented number as a key.
-- @param task An item to clean
-- @treturn number taskId
function Maid:giveTask(task)
	if not task then
		error("Task cannot be false or nil", 2)
	end

	local taskId = #self._tasks+1
	self[taskId] = task

	if type(task) == "table" and (not (task.Destroy or task.destroy)) then
		warn("[Maid.GiveTask] - Gave table task without .Destroy\n\n" .. debug.traceback())
	end

	return taskId
end

--[[ I wont' be using promises for TopbarPlus so we can ignore this method
function Maid:givePromise(promise)
	if (promise:getStatus() ~= Promise.Status.Started) then
		return promise
	end

	local newPromise = Promise.resolve(promise)
	local id = self:giveTask(newPromise)

	-- Ensure GC
	newPromise:finally(function()
		self[id] = nil
	end)

	return newPromise, id
end--]]

function Maid:give(taskOrPromise)
	local taskId
	if type(taskOrPromise) == "table" and taskOrPromise.isAPromise then
		_, taskId = self:givePromise(taskOrPromise)
	else
		taskId = self:giveTask(taskOrPromise)
	end
	return taskOrPromise, taskId
end

--- Cleans up all tasks.
-- @alias Destroy
function Maid:doCleaning()
	local tasks = self._tasks

	-- Disconnect all events first as we know this is safe
	for index, task in pairs(tasks) do
		if typeof(task) == "RBXScriptConnection" then
			tasks[index] = nil
			task:Disconnect()
		end
	end

	-- Clear out tasks table completely, even if clean up tasks add more tasks to the maid
	local index, task = next(tasks)
	while task ~= nil do
		tasks[index] = nil
		if type(task) == "function" then
			task()
		elseif typeof(task) == "RBXScriptConnection" then
			task:Disconnect()
		elseif task.Destroy then
			task:Destroy()
		elseif task.destroy then
			task:destroy()
		end
		index, task = next(tasks)
	end
end

--- Alias for DoCleaning()
-- @function Destroy
Maid.destroy = Maid.doCleaning
Maid.clean = Maid.doCleaning

return Maid end,
    function()local maui,script,require,getfenv,setfenv=ImportGlobals(10)-- LOCAL
local starterGui = game:GetService("StarterGui")
local guiService = game:GetService("GuiService")
local hapticService = game:GetService("HapticService")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local players = game:GetService("Players")
local VRService = game:GetService("VRService")
local voiceChatService = game:GetService("VoiceChatService")
local localizationService = game:GetService("LocalizationService")
local iconModule = script.Parent
local TopbarPlusReference = require(iconModule.TopbarPlusReference)
local referenceObject = TopbarPlusReference.getObject()
local leadPackage = referenceObject and referenceObject.Value
if leadPackage and leadPackage.IconController ~= script then
	return require(leadPackage.IconController)
end
if not referenceObject then
    TopbarPlusReference.addToReplicatedStorage()
end
local IconController = {}
local Signal = require(iconModule.Signal)
local TopbarPlusGui = require(iconModule.TopbarPlusGui)
local topbarIcons = {}
local forceTopbarDisabled = false
local menuOpen
local topbarUpdating = false
local cameraConnection
local controllerMenuOverride
local isStudio = runService:IsStudio()
local localPlayer = players.LocalPlayer
local voiceChatIsEnabledForUserAndWithinExperience = false
local disableControllerOption = false
local STUPID_CONTROLLER_OFFSET = 32



-- LOCAL FUNCTIONS
local function checkTopbarEnabled()
	local success, bool = xpcall(function()
		return starterGui:GetCore("TopbarEnabled")
	end,function(err)
		--has not been registered yet, but default is that is enabled
		return true	
	end)
	return (success and bool)
end

local function checkTopbarEnabledAccountingForMimic()
	local topbarEnabledAccountingForMimic = (checkTopbarEnabled() or not IconController.mimicCoreGui)
	return topbarEnabledAccountingForMimic
end

-- Add icons to an overflow if they overlap the screen bounds or other icons
local function bindCamera()
	if not workspace.CurrentCamera then return end
	if cameraConnection and cameraConnection.Connected then
		cameraConnection:Disconnect()
	end
	cameraConnection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(IconController.updateTopbar)
end

-- OFFSET HANDLERS
local alignmentDetails = {}
alignmentDetails["left"] = {
	startScale = 0,
	getOffset = function()
		local offset = 48 + IconController.leftOffset
		if checkTopbarEnabled() then
			local chatEnabled = starterGui:GetCoreGuiEnabled("Chat")
			if chatEnabled then
				offset += 12 + 32
			end
			if voiceChatIsEnabledForUserAndWithinExperience and not isStudio then
				if chatEnabled then
					offset += 67
				else
					offset += 43
				end
			end
		end
		return offset
	end,
	getStartOffset = function()
		local alignmentGap = IconController["leftGap"]
		local startOffset = alignmentDetails.left.getOffset() + alignmentGap
		return startOffset
	end,
	records = {}
}
alignmentDetails["mid"] = {
	startScale = 0.5,
	getOffset = function()
		return 0
	end,
	getStartOffset = function(totalIconX) 
		local alignmentGap = IconController["midGap"]
		return -totalIconX/2 + (alignmentGap/2)
	end,
	records = {}
}
alignmentDetails["right"] = {
	startScale = 1,
	getOffset = function()
		local offset = IconController.rightOffset
		local localCharacter  = localPlayer.Character
		local localHumanoid = localCharacter and localCharacter:FindFirstChild("Humanoid")
		local isR6 = if localHumanoid and localHumanoid.RigType == Enum.HumanoidRigType.R6 then true else false -- Even though the EmotesMenu doesn't appear for R6 players, it will still register as enabled unless manually disabled
		if (checkTopbarEnabled() or VRService.VREnabled) and (starterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList) or starterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack) or (not isR6 and starterGui:GetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu))) then
			offset += 48
		end
		return offset
	end,
	getStartOffset = function(totalIconX)
		local startOffset = -totalIconX - alignmentDetails.right.getOffset()
		return startOffset
	end,
	records = {}
	--reverseSort = true
}



-- PROPERTIES
IconController.topbarEnabled = true
IconController.controllerModeEnabled = false
IconController.previousTopbarEnabled = checkTopbarEnabled()
IconController.leftGap = 12
IconController.midGap = 12
IconController.rightGap = 12
IconController.leftOffset = 0
IconController.rightOffset = 0
IconController.voiceChatEnabled = nil
IconController.mimicCoreGui = true
IconController.healthbarDisabled = false
IconController.activeButtonBCallbacks = 0
IconController.disableButtonB = false
IconController.translator = localizationService:GetTranslatorForPlayer(localPlayer)



-- EVENTS
IconController.iconAdded = Signal.new()
IconController.iconRemoved = Signal.new()
IconController.controllerModeStarted = Signal.new()
IconController.controllerModeEnded = Signal.new()
IconController.healthbarDisabledSignal = Signal.new()



-- CONNECTIONS
local iconCreationCount = 0
IconController.iconAdded:Connect(function(icon)
	topbarIcons[icon] = true
	if IconController.gameTheme then
		icon:setTheme(IconController.gameTheme)
	end
	icon.updated:Connect(function()
		IconController.updateTopbar()
	end)
	-- When this icon is selected, deselect other icons if necessary
	icon.selected:Connect(function()
		local allIcons = IconController.getIcons()
		for _, otherIcon in pairs(allIcons) do
			if icon.deselectWhenOtherIconSelected and otherIcon ~= icon and otherIcon.deselectWhenOtherIconSelected and otherIcon:getToggleState() == "selected" then
				otherIcon:deselect(icon)
			end
		end
	end)
	-- Order by creation if no order specified
	iconCreationCount = iconCreationCount + 1
	icon:setOrder(iconCreationCount)
	-- Apply controller view if enabled
	if IconController.controllerModeEnabled then
		IconController._enableControllerModeForIcon(icon, true)
	end
	IconController:_updateSelectionGroup()
	IconController.updateTopbar()
end)

IconController.iconRemoved:Connect(function(icon)
	topbarIcons[icon] = nil
	icon:setEnabled(false)
	icon:deselect()
	icon.updated:Fire()
	IconController:_updateSelectionGroup()
end)

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera)


-- METHODS
function IconController.setGameTheme(theme)
	IconController.gameTheme = theme
	local icons = IconController.getIcons()
	for _, icon in pairs(icons) do
		icon:setTheme(theme)
	end
end

function IconController.setDisplayOrder(value)
	value = tonumber(value) or TopbarPlusGui.DisplayOrder
	TopbarPlusGui.DisplayOrder = value
end
IconController.setDisplayOrder(10)

function IconController.getIcons()
	local allIcons = {}
	for otherIcon, _ in pairs(topbarIcons) do
		table.insert(allIcons, otherIcon)
	end
	return allIcons
end

function IconController.getIcon(name)
	for otherIcon, _ in pairs(topbarIcons) do
		if otherIcon.name == name then
			return otherIcon
		end
	end
	return false
end

function IconController.disableHealthbar(bool)
	local finalBool = (bool == nil or bool)
	IconController.healthbarDisabled = finalBool
	IconController.healthbarDisabledSignal:Fire(finalBool)
end

function IconController.disableControllerOption(bool)
	local finalBool = (bool == nil or bool)
	disableControllerOption = finalBool
	if IconController.getIcon("_TopbarControllerOption") then
		IconController._determineControllerDisplay()
	end
end

function IconController.canShowIconOnTopbar(icon)
	if (icon.enabled == true or icon.accountForWhenDisabled) and icon.presentOnTopbar then
		return true
	end
	return false
end

function IconController.getMenuOffset(icon)
	local alignment = icon:get("alignment")
	local alignmentGap = IconController[alignment.."Gap"]
	local extendLeft = 0
	local extendRight = 0
	local additionalRight = 0
	if icon.menuOpen then
		local menuSize = icon:get("menuSize")
		local menuSizeXOffset = menuSize.X.Offset
		local direction = icon:_getMenuDirection()
		if direction == "right" then
			extendRight += menuSizeXOffset + alignmentGap/6--2
		elseif direction == "left" then
			extendLeft = menuSizeXOffset + 4
			extendRight += alignmentGap/3--4
			additionalRight = menuSizeXOffset
		end
	end
	return extendLeft, extendRight, additionalRight
end

-- This is responsible for positioning the topbar icons
local requestedTopbarUpdate = false
function IconController.updateTopbar()
	local function getIncrement(otherIcon, alignment)
		--local container = otherIcon.instances.iconContainer
		--local sizeX = container.Size.X.Offset
		local iconSize = otherIcon:get("iconSize", otherIcon:getIconState()) or UDim2.new(0, 32, 0, 32)
		local sizeX = iconSize.X.Offset
		local alignmentGap = IconController[alignment.."Gap"]
		local iconWidthAndGap = (sizeX + alignmentGap)
		local increment = iconWidthAndGap
		local preOffset = 0
		if otherIcon._parentIcon == nil then
			local extendLeft, extendRight, additionalRight = IconController.getMenuOffset(otherIcon)
			preOffset += extendLeft
			increment += extendRight + additionalRight
		end
		return increment, preOffset
	end
	if topbarUpdating then -- This prevents the topbar updating and shifting icons more than it needs to
		requestedTopbarUpdate = true
		return false
	end
	task.defer(function()
		topbarUpdating = true
		runService.Heartbeat:Wait()
		topbarUpdating = false
		
		for alignment, alignmentInfo in pairs(alignmentDetails) do
			alignmentInfo.records = {}
		end

		for otherIcon, _ in pairs(topbarIcons) do
			if IconController.canShowIconOnTopbar(otherIcon) then
				local alignment = otherIcon:get("alignment")
				table.insert(alignmentDetails[alignment].records, otherIcon)
			end
		end
		local viewportSize = workspace.CurrentCamera.ViewportSize
		for alignment, alignmentInfo in pairs(alignmentDetails) do
			local records = alignmentInfo.records
			if #records > 1 then
				if alignmentInfo.reverseSort then
					table.sort(records, function(a,b) return a:get("order") > b:get("order") end)
				else
					table.sort(records, function(a,b) return a:get("order") < b:get("order") end)
				end
			end
			local totalIconX = 0
			for i, otherIcon in pairs(records) do
				local increment = getIncrement(otherIcon, alignment)
				totalIconX = totalIconX + increment
			end
			local offsetX = alignmentInfo.getStartOffset(totalIconX, alignment)
			local preOffsetX = offsetX
			local containerX = TopbarPlusGui.TopbarContainer.AbsoluteSize.X
			for i, otherIcon in pairs(records) do
				local increment, preOffset = getIncrement(otherIcon, alignment)
				local newAbsoluteX = alignmentInfo.startScale*containerX + preOffsetX+preOffset
				preOffsetX = preOffsetX + increment
			end
			for i, otherIcon in pairs(records) do
				local container = otherIcon.instances.iconContainer
				local increment, preOffset = getIncrement(otherIcon, alignment)
				local topPadding = otherIcon.topPadding
				local newPositon = UDim2.new(alignmentInfo.startScale, offsetX+preOffset, topPadding.Scale, topPadding.Offset)
				local isAnOverflowIcon = string.match(otherIcon.name, "_overflowIcon-")
				local repositionInfo = otherIcon:get("repositionInfo")
				if repositionInfo then
					tweenService:Create(container, repositionInfo, {Position = newPositon}):Play()
				else
					container.Position = newPositon
				end
				offsetX = offsetX + increment
				otherIcon.targetPosition = UDim2.new(0, (newPositon.X.Scale*viewportSize.X) + newPositon.X.Offset, 0, (newPositon.Y.Scale*viewportSize.Y) + newPositon.Y.Offset)
			end
		end

		-- OVERFLOW HANDLER
		--------
		local START_LEEWAY = 10 -- The additional offset where the end icon will be converted to ... without an apparant change in position
		local function getBoundaryX(iconToCheck, side, gap)
			local additionalGap = gap or 0
			local currentSize = iconToCheck:get("iconSize", iconToCheck:getIconState())
			local sizeX = currentSize.X.Offset
			local extendLeft, extendRight = IconController.getMenuOffset(iconToCheck)
			local boundaryXOffset = (side == "left" and (-additionalGap-extendLeft)) or (side == "right" and sizeX+additionalGap+extendRight)
			local boundaryX = iconToCheck.targetPosition.X.Offset + boundaryXOffset
			return boundaryX
		end
		local function getSizeX(iconToCheck, usePrevious)
			local currentSize, previousSize = iconToCheck:get("iconSize", iconToCheck:getIconState(), "beforeDropdown")
			local hoveringSize = iconToCheck:get("iconSize", "hovering")
			if iconToCheck.wasHoveringBeforeOverflow and previousSize and hoveringSize and hoveringSize.X.Offset > previousSize.X.Offset then
				-- This prevents hovering icons flicking back and forth, demonstrated at thread/1017485/191.
				previousSize = hoveringSize
			end
			local newSize = (usePrevious and previousSize) or currentSize
			local extendLeft, extendRight = IconController.getMenuOffset(iconToCheck)
			local sizeX = newSize.X.Offset + extendLeft + extendRight
			return sizeX
		end

		for alignment, alignmentInfo in pairs(alignmentDetails) do
			local overflowIcon = alignmentInfo.overflowIcon
			if overflowIcon then
				local alignmentGap = IconController[alignment.."Gap"]
				local oppositeAlignment = (alignment == "left" and "right") or "left"
				local oppositeAlignmentInfo = alignmentDetails[oppositeAlignment]
				local oppositeOverflowIcon = IconController.getIcon("_overflowIcon-"..oppositeAlignment)
				
				-- This determines whether any icons (from opposite or mid alignment) are overlapping with this alignment
				local overflowBoundaryX = getBoundaryX(overflowIcon, alignment)
				if overflowIcon.enabled then
					overflowBoundaryX = getBoundaryX(overflowIcon, oppositeAlignment, alignmentGap)
				end
				local function doesExceed(givenBoundaryX)
					local exceeds = (alignment == "left" and givenBoundaryX < overflowBoundaryX) or (alignment == "right" and givenBoundaryX > overflowBoundaryX)
					return exceeds
				end
				local alignmentOffset = oppositeAlignmentInfo.getOffset()
				if not overflowIcon.enabled then
					alignmentOffset += START_LEEWAY
				end
				local alignmentBorderX = (alignment == "left" and viewportSize.X - alignmentOffset) or (alignment == "right" and alignmentOffset)
				local closestBoundaryX = alignmentBorderX
				local exceededCriticalBoundary = doesExceed(closestBoundaryX)
				local function checkBoundaryExceeded(recordToCheck)
					local totalIcons = #recordToCheck
					for i = 1, totalIcons do
						local endIcon = recordToCheck[totalIcons+1 - i]
						if IconController.canShowIconOnTopbar(endIcon) then
							local isAnOverflowIcon = string.match(endIcon.name, "_overflowIcon-")
							if isAnOverflowIcon and totalIcons ~= 1 then
								break
							elseif isAnOverflowIcon and not endIcon.enabled then
								continue
							end
							local additionalMyX = 0
							if not overflowIcon.enabled then
								additionalMyX = START_LEEWAY
							end
							local myBoundaryX = getBoundaryX(endIcon, alignment, additionalMyX)
							local isNowClosest = (alignment == "left" and myBoundaryX < closestBoundaryX) or (alignment == "right" and myBoundaryX > closestBoundaryX)
							if isNowClosest then
								closestBoundaryX = myBoundaryX
								if doesExceed(myBoundaryX) then
									exceededCriticalBoundary = true
								end
							end
						end
					end
				end
				checkBoundaryExceeded(alignmentDetails[oppositeAlignment].records)
				checkBoundaryExceeded(alignmentDetails.mid.records)

				-- This determines which icons to give to the overflow if an overlap is present
				if exceededCriticalBoundary then
					local recordToCheck = alignmentInfo.records
					local totalIcons = #recordToCheck
					for i = 1, totalIcons do
						local endIcon = (alignment == "left" and recordToCheck[totalIcons+1 - i]) or (alignment == "right" and recordToCheck[i])
						if endIcon ~= overflowIcon and IconController.canShowIconOnTopbar(endIcon) then
							local additionalGap = alignmentGap
							local overflowIconSizeX = overflowIcon:get("iconSize", overflowIcon:getIconState()).X.Offset
							if overflowIcon.enabled then
								additionalGap += alignmentGap + overflowIconSizeX
							end
							local myBoundaryXPlusGap = getBoundaryX(endIcon, oppositeAlignment, additionalGap)
							local exceeds = (alignment == "left" and myBoundaryXPlusGap >= closestBoundaryX) or (alignment == "right" and myBoundaryXPlusGap <= closestBoundaryX)
							if exceeds then
								if not overflowIcon.enabled then
									local overflowContainer = overflowIcon.instances.iconContainer
									local yPos = overflowContainer.Position.Y
									local appearXAdditional = (alignment == "left" and -overflowContainer.Size.X.Offset) or 0
									local appearX = getBoundaryX(endIcon, oppositeAlignment, appearXAdditional)
									overflowContainer.Position = UDim2.new(0, appearX, yPos.Scale, yPos.Offset)
									overflowIcon:setEnabled(true)
								end
								if #endIcon.dropdownIcons > 0 then
									endIcon._overflowConvertedToMenu = true
									local wasSelected = endIcon.isSelected
									endIcon:deselect()
									local iconsToConvert = {}
									for _, dIcon in pairs(endIcon.dropdownIcons) do
										table.insert(iconsToConvert, dIcon)
									end
									for _, dIcon in pairs(endIcon.dropdownIcons) do
										dIcon:leave()
									end
									endIcon:setMenu(iconsToConvert)
									if wasSelected and overflowIcon.isSelected then
										endIcon:select()
									end
								end
								if endIcon.hovering then
									endIcon.wasHoveringBeforeOverflow = true
								end
								endIcon:join(overflowIcon, "dropdown")
								if #endIcon.menuIcons > 0 and endIcon.menuOpen then
									endIcon:deselect()
									endIcon:select()
									overflowIcon:select()
								end
							end
							break
						end
					end
				
				else
					
					-- This checks to see if the lowest/highest (depending on left/right) ordered overlapping icon is no longer overlapping, removes from the dropdown, and repeats if valid
					local winningOrder, winningOverlappedIcon
					local totalOverlappingIcons = #overflowIcon.dropdownIcons
					if not (oppositeOverflowIcon and oppositeOverflowIcon.enabled and #alignmentInfo.records == 1 and #oppositeAlignmentInfo.records ~= 1) then
						for _, overlappedIcon in pairs(overflowIcon.dropdownIcons) do
							local iconOrder = overlappedIcon:get("order")
							if winningOverlappedIcon == nil or (alignment == "left" and iconOrder < winningOrder) or (alignment == "right" and iconOrder > winningOrder) then
								winningOrder = iconOrder
								winningOverlappedIcon = overlappedIcon
							end
						end
					end
					if winningOverlappedIcon then
						local sizeX = getSizeX(winningOverlappedIcon, true)
						local myForesightBoundaryX = getBoundaryX(overflowIcon, oppositeAlignment)
						if totalOverlappingIcons == 1 then
							myForesightBoundaryX = getBoundaryX(overflowIcon, alignment, alignmentGap-START_LEEWAY)
						end
						local availableGap = math.abs(closestBoundaryX - myForesightBoundaryX) - (alignmentGap*2)
						local noLongerExeeds = (sizeX < availableGap)
						if noLongerExeeds then
							if #overflowIcon.dropdownIcons == 1 then
								overflowIcon:setEnabled(false)
							end
							local overflowContainer = overflowIcon.instances.iconContainer
							local yPos = overflowContainer.Position.Y
							overflowContainer.Position = UDim2.new(0, myForesightBoundaryX, yPos.Scale, yPos.Offset)
							winningOverlappedIcon:leave()
							winningOverlappedIcon.wasHoveringBeforeOverflow = nil
							--
							if winningOverlappedIcon._overflowConvertedToMenu then
								winningOverlappedIcon._overflowConvertedToMenu = nil
								local iconsToConvert = {}
								for _, dIcon in pairs(winningOverlappedIcon.menuIcons) do
									table.insert(iconsToConvert, dIcon)
								end
								for _, dIcon in pairs(winningOverlappedIcon.menuIcons) do
									dIcon:leave()
								end
								winningOverlappedIcon:setDropdown(iconsToConvert)
							end
							--
						end
					end

				end
			end
		end
		--------
		if requestedTopbarUpdate then
			requestedTopbarUpdate = false
			IconController.updateTopbar()
		end
		return true
	end)
end

function IconController.setTopbarEnabled(bool, forceBool)
	if forceBool == nil then
		forceBool = true
	end
	local indicator = TopbarPlusGui.Indicator
	if forceBool and not bool then
		forceTopbarDisabled = true
	elseif forceBool and bool then
		forceTopbarDisabled = false
	end
	local topbarEnabledAccountingForMimic = checkTopbarEnabledAccountingForMimic()
	if IconController.controllerModeEnabled then
		if bool then
			if TopbarPlusGui.TopbarContainer.Visible or forceTopbarDisabled or menuOpen or not topbarEnabledAccountingForMimic then return end
			if forceBool then
				indicator.Visible = topbarEnabledAccountingForMimic
			else
				indicator.Active = false
				if controllerMenuOverride and controllerMenuOverride.Connected then
					controllerMenuOverride:Disconnect()
				end
				
				if hapticService:IsVibrationSupported(Enum.UserInputType.Gamepad1) and hapticService:IsMotorSupported(Enum.UserInputType.Gamepad1,Enum.VibrationMotor.Small) then
					hapticService:SetMotor(Enum.UserInputType.Gamepad1,Enum.VibrationMotor.Small,1)
					delay(0.2,function()
						pcall(function()
							hapticService:SetMotor(Enum.UserInputType.Gamepad1,Enum.VibrationMotor.Small,0)
						end)
					end)
				end
				TopbarPlusGui.TopbarContainer.Visible = true
				TopbarPlusGui.TopbarContainer:TweenPosition(
					UDim2.new(0,0,0,5 + STUPID_CONTROLLER_OFFSET),
					Enum.EasingDirection.Out,
					Enum.EasingStyle.Quad,
					0.1,
					true
				)
				
				
				local selectIcon
				local targetOffset = 0
				IconController:_updateSelectionGroup()
				runService.Heartbeat:Wait()
				local indicatorSizeTrip = 50 --indicator.AbsoluteSize.Y * 2
				for otherIcon, _ in pairs(topbarIcons) do
					if IconController.canShowIconOnTopbar(otherIcon) and (selectIcon == nil or otherIcon:get("order") < selectIcon:get("order")) and otherIcon.enabled then
						selectIcon = otherIcon
					end
					local container = otherIcon.instances.iconContainer
					local newTargetOffset = -27 + container.AbsoluteSize.Y + indicatorSizeTrip
					if newTargetOffset > targetOffset then
						targetOffset = newTargetOffset
					end
				end
				if guiService:GetEmotesMenuOpen() then
					guiService:SetEmotesMenuOpen(false)
				end
				if guiService:GetInspectMenuEnabled() then
					guiService:CloseInspectMenu()
				end
				local newSelectedObject = IconController._previousSelectedObject or selectIcon.instances.iconButton
				IconController._setControllerSelectedObject(newSelectedObject)
				indicator.Image = "rbxassetid://5278151071"
				indicator:TweenPosition(
					UDim2.new(0.5,0,0,targetOffset + STUPID_CONTROLLER_OFFSET),
					Enum.EasingDirection.Out,
					Enum.EasingStyle.Quad,
					0.1,
					true
				)
			end
		else
			if forceBool then
				indicator.Visible = false
			elseif topbarEnabledAccountingForMimic then
				indicator.Visible = true
				indicator.Active = true
				controllerMenuOverride = indicator.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						IconController.setTopbarEnabled(true,false)
					end
				end)
			else
				indicator.Visible = false
			end
			if not TopbarPlusGui.TopbarContainer.Visible then return end
			guiService.AutoSelectGuiEnabled = true
			IconController:_updateSelectionGroup(true)
			TopbarPlusGui.TopbarContainer:TweenPosition(
				UDim2.new(0,0,0,-TopbarPlusGui.TopbarContainer.Size.Y.Offset + STUPID_CONTROLLER_OFFSET),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quad,
				0.1,
				true,
				function()
					TopbarPlusGui.TopbarContainer.Visible = false
				end
			)
			indicator.Image = "rbxassetid://5278151556"
			indicator:TweenPosition(
				UDim2.new(0.5,0,0,5),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quad,
				0.1,
				true
			)
		end
	else
		local topbarContainer = TopbarPlusGui.TopbarContainer
		if topbarEnabledAccountingForMimic then
			topbarContainer.Visible = bool
		else
			topbarContainer.Visible = false
		end
	end
end

function IconController.setGap(value, alignment)
	local newValue = tonumber(value) or 12
	local newAlignment = tostring(alignment):lower()
	if newAlignment == "left" or newAlignment == "mid" or newAlignment == "right" then
		IconController[newAlignment.."Gap"] = newValue
		IconController.updateTopbar()
		return
	end
	IconController.leftGap = newValue
	IconController.midGap = newValue
	IconController.rightGap = newValue
	IconController.updateTopbar()
end

function IconController.setLeftOffset(value)
	IconController.leftOffset = tonumber(value) or 0
	IconController.updateTopbar()
end

function IconController.setRightOffset(value)
	IconController.rightOffset = tonumber(value) or 0
	IconController.updateTopbar()
end

local localPlayer = players.LocalPlayer
local iconsToClearOnSpawn = {}
localPlayer.CharacterAdded:Connect(function()
	for _, icon in pairs(iconsToClearOnSpawn) do
		icon:destroy()
	end
	iconsToClearOnSpawn = {}
end)
function IconController.clearIconOnSpawn(icon)
	coroutine.wrap(function()
		local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
		table.insert(iconsToClearOnSpawn, icon)
	end)()
end



-- PRIVATE METHODS
function IconController:_updateSelectionGroup(clearAll)
	if IconController._navigationEnabled then
		guiService:RemoveSelectionGroup("TopbarPlusIcons")
	end
	if clearAll then
		guiService.CoreGuiNavigationEnabled = IconController._originalCoreGuiNavigationEnabled
		guiService.GuiNavigationEnabled = IconController._originalGuiNavigationEnabled
		IconController._navigationEnabled = nil
	elseif IconController.controllerModeEnabled then
		local icons = IconController.getIcons()
		local iconContainers = {}
		for i, otherIcon in pairs(icons) do
			local featureName = otherIcon.joinedFeatureName
			if not featureName or otherIcon._parentIcon[otherIcon.joinedFeatureName.."Open"] == true then
				table.insert(iconContainers, otherIcon.instances.iconButton)
			end
		end
		guiService:AddSelectionTuple("TopbarPlusIcons", table.unpack(iconContainers))
		if not IconController._navigationEnabled then
			IconController._originalCoreGuiNavigationEnabled = guiService.CoreGuiNavigationEnabled
			IconController._originalGuiNavigationEnabled = guiService.GuiNavigationEnabled
			guiService.CoreGuiNavigationEnabled = false
			guiService.GuiNavigationEnabled = true
			IconController._navigationEnabled = true
		end
	end
end

local function getScaleMultiplier()
	if guiService:IsTenFootInterface() then
		return 3
	else
		return 1.3
	end
end

function IconController._setControllerSelectedObject(object)
	local startId = (IconController._controllerSetCount and IconController._controllerSetCount + 1) or 0
	IconController._controllerSetCount = startId
	guiService.SelectedObject = object
	task.delay(0.1, function()
		local finalId = IconController._controllerSetCountS
		if startId == finalId then
			guiService.SelectedObject = object
		end
	end)
end

function IconController._enableControllerMode(bool)
	local indicator = TopbarPlusGui.Indicator
	local controllerOptionIcon = IconController.getIcon("_TopbarControllerOption")
	if IconController.controllerModeEnabled == bool then
		return
	end
	IconController.controllerModeEnabled = bool
	if bool then
		TopbarPlusGui.TopbarContainer.Position = UDim2.new(0,0,0,5)
		TopbarPlusGui.TopbarContainer.Visible = false
		local scaleMultiplier = getScaleMultiplier()
		indicator.Position = UDim2.new(0.5,0,0,5)
		indicator.Size = UDim2.new(0, 18*scaleMultiplier, 0, 18*scaleMultiplier)
		indicator.Image = "rbxassetid://5278151556"
		indicator.Visible = checkTopbarEnabledAccountingForMimic()
		indicator.Position = UDim2.new(0.5,0,0,5)
		indicator.Active = true
		controllerMenuOverride = indicator.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				IconController.setTopbarEnabled(true,false)
			end
		end)
	else
		TopbarPlusGui.TopbarContainer.Position = UDim2.new(0,0,0,0)
		TopbarPlusGui.TopbarContainer.Visible = checkTopbarEnabledAccountingForMimic()
		indicator.Visible = false
		IconController._setControllerSelectedObject(nil)
	end
	for icon, _ in pairs(topbarIcons) do
		IconController._enableControllerModeForIcon(icon, bool)
	end
end

function IconController._enableControllerModeForIcon(icon, bool)
	local parentIcon = icon._parentIcon
	local featureName = icon.joinedFeatureName
	if parentIcon then
		icon:leave()
	end
	if bool then
		local scaleMultiplier = getScaleMultiplier()
		local currentSizeDeselected = icon:get("iconSize", "deselected")
		local currentSizeSelected = icon:get("iconSize", "selected")
		local currentSizeHovering = icon:getHovering("iconSize")
		icon:set("iconSize", UDim2.new(0, currentSizeDeselected.X.Offset*scaleMultiplier, 0, currentSizeDeselected.Y.Offset*scaleMultiplier), "deselected", "controllerMode")
		icon:set("iconSize", UDim2.new(0, currentSizeSelected.X.Offset*scaleMultiplier, 0, currentSizeSelected.Y.Offset*scaleMultiplier), "selected", "controllerMode")
		if currentSizeHovering then
			icon:set("iconSize", UDim2.new(0, currentSizeSelected.X.Offset*scaleMultiplier, 0, currentSizeSelected.Y.Offset*scaleMultiplier), "hovering", "controllerMode")
		end
		icon:set("alignment", "mid", "deselected", "controllerMode")
		icon:set("alignment", "mid", "selected", "controllerMode")
	else
		local states = {"deselected", "selected", "hovering"}
		for _, iconState in pairs(states) do
			local _, previousAlignment = icon:get("alignment", iconState, "controllerMode")
			if previousAlignment then
				icon:set("alignment", previousAlignment, iconState)
			end
			local currentSize, previousSize = icon:get("iconSize", iconState, "controllerMode")
			if previousSize then
				icon:set("iconSize", previousSize, iconState)
			end
		end
	end
	if parentIcon then
		icon:join(parentIcon, featureName)
	end
end

local createdFakeHealthbarIcon = false
function IconController.setupHealthbar()

	if createdFakeHealthbarIcon then
		return
	end
	createdFakeHealthbarIcon = true

	-- Create a fake healthbar icon to mimic the core health gui
	task.defer(function()
		runService.Heartbeat:Wait()
		local Icon = require(iconModule)

		Icon.new()
			:setProperty("internalIcon", true)
			:setName("_FakeHealthbar")
			:setRight()
			:setOrder(-420)
			:setSize(80, 32)
			:lock()
			:set("iconBackgroundTransparency", 1)
			:give(function(icon)

				local healthContainer = Instance.new("Frame")
				healthContainer.Name = "HealthContainer"
				healthContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				healthContainer.BorderSizePixel = 0
				healthContainer.AnchorPoint = Vector2.new(0, 0.5)
				healthContainer.Position = UDim2.new(0, 0, 0.5, 0)
				healthContainer.Size = UDim2.new(1, 0, 0.2, 0)
				healthContainer.Visible = true
				healthContainer.ZIndex = 11
				healthContainer.Parent = icon.instances.iconButton

				local corner = Instance.new("UICorner")
				corner.CornerRadius = UDim.new(1, 0)
				corner.Parent = healthContainer

				local healthFrame = healthContainer:Clone()
				healthFrame.Name = "HealthFrame"
				healthFrame.BackgroundColor3 = Color3.fromRGB(167, 167, 167)
				healthFrame.BorderSizePixel = 0
				healthFrame.AnchorPoint = Vector2.new(0.5, 0.5)
				healthFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
				healthFrame.Size = UDim2.new(1, -2, 1, -2)
				healthFrame.Visible = true
				healthFrame.ZIndex = 12
				healthFrame.Parent = healthContainer

				local healthBar = healthFrame:Clone()
				healthBar.Name = "HealthBar"
				healthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				healthBar.BorderSizePixel = 0
				healthBar.AnchorPoint = Vector2.new(0, 0.5)
				healthBar.Position = UDim2.new(0, 0, 0.5, 0)
				healthBar.Size = UDim2.new(0.5, 0, 1, 0)
				healthBar.Visible = true
				healthBar.ZIndex = 13
				healthBar.Parent = healthFrame

				local START_HEALTHBAR_COLOR = Color3.fromRGB(27, 252, 107)
				local MID_HEALTHBAR_COLOR = Color3.fromRGB(250, 235, 0)
				local END_HEALTHBAR_COLOR = Color3.fromRGB(255, 28, 0)

				local function powColor3(color, pow)
					return Color3.new(
						math.pow(color.R, pow),
						math.pow(color.G, pow),
						math.pow(color.B, pow)
					)
				end

				local function lerpColor(colorA, colorB, frac, gamma)
					gamma = gamma or 2.0
					local CA = powColor3(colorA, gamma)
					local CB = powColor3(colorB, gamma)
					return powColor3(CA:Lerp(CB, frac), 1/gamma)
				end

				local firstTimeEnabling = true
				local function listenToHealth(character)
					if not character then
						return
					end
					local humanoid = character:WaitForChild("Humanoid", 10)
					if not humanoid then
						return
					end

					local function updateHealthBar()
						local realHealthbarEnabled = starterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health)
						local healthInterval = humanoid.Health / humanoid.MaxHealth
						if healthInterval == 1 or IconController.healthbarDisabled or (firstTimeEnabling and realHealthbarEnabled == false) then
							if icon.enabled then
								icon:setEnabled(false)
							end
							return
						elseif healthInterval < 1 then
							if not icon.enabled then
								icon:setEnabled(true)
							end
							firstTimeEnabling = false
							if realHealthbarEnabled then
								starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
							end
						end
						local startInterval = 0.9
						local endInterval = 0.1
						local m = 1/(startInterval - endInterval)
						local c = -m*endInterval
						local colorIntervalAbsolute = (m*healthInterval) + c
						local colorInterval = (colorIntervalAbsolute > 1 and 1) or (colorIntervalAbsolute < 0 and 0) or colorIntervalAbsolute
						local firstColor = (healthInterval > 0.5 and START_HEALTHBAR_COLOR) or MID_HEALTHBAR_COLOR
						local lastColor = (healthInterval > 0.5 and MID_HEALTHBAR_COLOR) or END_HEALTHBAR_COLOR
						local doubleSubtractor = (1-colorInterval)*2
						local modifiedColorInterval = (healthInterval > 0.5 and (1-doubleSubtractor)) or (2-doubleSubtractor)
						local newHealthFillColor = lerpColor(lastColor, firstColor, modifiedColorInterval)
						local newHealthFillSize = UDim2.new(healthInterval, 0, 1, 0)
						healthBar.BackgroundColor3 = newHealthFillColor
						healthBar.Size = newHealthFillSize
					end

					humanoid.HealthChanged:Connect(updateHealthBar)
					IconController.healthbarDisabledSignal:Connect(updateHealthBar)
					updateHealthBar()
				end
				localPlayer.CharacterAdded:Connect(function(character)
					listenToHealth(character)
				end)
				task.spawn(listenToHealth, localPlayer.Character)
			end)
	end)
end

function IconController._determineControllerDisplay()
	local mouseEnabled = userInputService.MouseEnabled
	local controllerEnabled = userInputService.GamepadEnabled
	local controllerOptionIcon = IconController.getIcon("_TopbarControllerOption")
	if mouseEnabled and controllerEnabled then
		-- Show icon (if option not disabled else hide)
		if not disableControllerOption then
			controllerOptionIcon:setEnabled(true)
		else
			controllerOptionIcon:setEnabled(false)
		end
	elseif mouseEnabled and not controllerEnabled then
		-- Hide icon, disableControllerMode
		controllerOptionIcon:setEnabled(false)
		IconController._enableControllerMode(false)
		controllerOptionIcon:deselect()
	elseif not mouseEnabled and controllerEnabled then
		-- Hide icon, _enableControllerMode
		controllerOptionIcon:setEnabled(false)
		IconController._enableControllerMode(true)
	end
end



-- BEHAVIOUR
--Controller support
coroutine.wrap(function()
	
	-- Create PC 'Enter Controller Mode' Icon
	runService.Heartbeat:Wait() -- This is required to prevent an infinite recursion
	local Icon = require(iconModule)
	local controllerOptionIcon = Icon.new()
		:setProperty("internalIcon", true)
		:setName("_TopbarControllerOption")
		:setOrder(100)
		:setImage(11162828670)
		:setRight()
		:setEnabled(false)
		:setTip("Controller mode")
		:setProperty("deselectWhenOtherIconSelected", false)

	-- This decides what controller widgets and displays to show based upon their connected inputs
	-- For example, if on PC with a controller, give the player the option to enable controller mode with a toggle
	-- While if using a console (no mouse, but controller) then bypass the toggle and automatically enable controller mode
	userInputService:GetPropertyChangedSignal("MouseEnabled"):Connect(IconController._determineControllerDisplay)
	userInputService.GamepadConnected:Connect(IconController._determineControllerDisplay)
	userInputService.GamepadDisconnected:Connect(IconController._determineControllerDisplay)
	IconController._determineControllerDisplay()

	-- Enable/Disable Controller Mode when icon clicked
	local function iconClicked()
		local isSelected = controllerOptionIcon.isSelected
		local iconTip = (isSelected and "Normal mode") or "Controller mode"
		controllerOptionIcon:setTip(iconTip)
		IconController._enableControllerMode(isSelected)
	end
	controllerOptionIcon.selected:Connect(iconClicked)
	controllerOptionIcon.deselected:Connect(iconClicked)

	-- Hide/show topbar when indicator action selected in controller mode
	userInputService.InputBegan:Connect(function(input,gpe)
		if not IconController.controllerModeEnabled then return end
		if input.KeyCode == Enum.KeyCode.DPadDown then
			if not guiService.SelectedObject and checkTopbarEnabledAccountingForMimic() then
				IconController.setTopbarEnabled(true,false)
			end
		elseif input.KeyCode == Enum.KeyCode.ButtonB and not IconController.disableButtonB then
			if IconController.activeButtonBCallbacks == 1 and TopbarPlusGui.Indicator.Image == "rbxassetid://5278151556" then
				IconController.activeButtonBCallbacks = 0
				guiService.SelectedObject = nil
			end
			if IconController.activeButtonBCallbacks == 0 then
				IconController._previousSelectedObject = guiService.SelectedObject
				IconController._setControllerSelectedObject(nil)
				IconController.setTopbarEnabled(false,false)
			end
		end
		input:Destroy()
	end)

	-- Setup overflow icons
	for alignment, detail in pairs(alignmentDetails) do
		if alignment ~= "mid" then
			local overflowName = "_overflowIcon-"..alignment
			local overflowIcon = Icon.new()
				:setProperty("internalIcon", true)
				:setImage(6069276526)
				:setName(overflowName)
				:setEnabled(false)
			detail.overflowIcon = overflowIcon
			overflowIcon.accountForWhenDisabled = true
			if alignment == "left" then
				overflowIcon:setOrder(math.huge)
				overflowIcon:setLeft()
				overflowIcon:set("dropdownAlignment", "right")
			elseif alignment == "right" then
				overflowIcon:setOrder(-math.huge)
				overflowIcon:setRight()
				overflowIcon:set("dropdownAlignment", "left")
			end
			overflowIcon.lockedSettings = {
				["iconImage"] = true,
				["order"] = true,
				["alignment"] = true,
			}
		end
	end





	-- This checks if voice chat is enabled
	task.defer(function()
		local success, enabledForUser
		while true do
			success, enabledForUser = pcall(function() return voiceChatService:IsVoiceEnabledForUserIdAsync(localPlayer.UserId) end)
			if success then
				break
			end
			task.wait(1)
		end
		local function checkVoiceChatManuallyEnabled()
			if IconController.voiceChatEnabled then
				if success and enabledForUser then
					voiceChatIsEnabledForUserAndWithinExperience = true
					IconController.updateTopbar()
				end
			end
		end
		checkVoiceChatManuallyEnabled()
		
		--------------- FEEL FREE TO DELETE THIS IS YOU DO NOT USE VOICE CHAT WITHIN YOUR EXPERIENCE ---------------
		localPlayer.PlayerGui:WaitForChild("TopbarPlus", 999)
		task.delay(10, function()
			checkVoiceChatManuallyEnabled()
			if IconController.voiceChatEnabled == nil and success and enabledForUser and isStudio then
				warn("⚠️TopbarPlus Action Required⚠️ If VoiceChat is enabled within your experience it's vital you set IconController.voiceChatEnabled to true ``require(game.ReplicatedStorage.Icon.IconController).voiceChatEnabled = true`` otherwise the BETA label will not be accounted for within your live servers. This warning will disappear after doing so. Feel free to delete this warning or to set to false if you don't have VoiceChat enabled within your experience.")
			end
		end)
		------------------------------------------------------------------------------------------------------------

	end)
	
	
	


	if not isStudio then
		local ownerId = game.CreatorId
		local groupService = game:GetService("GroupService")
		if game.CreatorType == Enum.CreatorType.Group then
			local success, ownerInfo = pcall(function() return groupService:GetGroupInfoAsync(game.CreatorId).Owner end)
			if success then
				ownerId = ownerInfo.Id
			end
		end
		local version = require(iconModule.VERSION)
		if localPlayer.UserId ~= ownerId then
			local marketplaceService = game:GetService("MarketplaceService")
			local success, placeInfo = pcall(function() return marketplaceService:GetProductInfo(game.PlaceId) end)
			if success and placeInfo then
				-- Required attrbute for using TopbarPlus
				-- This is not printed within stuido and to the game owner to prevent mixing with debug prints
				local gameName = placeInfo.Name
				print(("\n\n\n⚽ %s uses TopbarPlus %s\n🍍 TopbarPlus was developed by ForeverHD and the Nanoblox Team\n🚀 You can learn more and take a free copy by searching for 'TopbarPlus' on the DevForum\n\n"):format(gameName, version))
			end
		end
	end

end)()

-- Mimic the enabling of the topbar when StarterGui:SetCore("TopbarEnabled", state) is called
coroutine.wrap(function()
	local chatScript = players.LocalPlayer.PlayerScripts:WaitForChild("ChatScript", 4) or game:GetService("Chat"):WaitForChild("ChatScript", 4)
	if not chatScript then return end
	local chatMain = chatScript:FindFirstChild("ChatMain")
	if not chatMain then return end
	local ChatMain = require(chatMain)
	ChatMain.CoreGuiEnabled:connect(function()
		local topbarEnabled = checkTopbarEnabled()
		if topbarEnabled == IconController.previousTopbarEnabled then
			IconController.updateTopbar()
			return "SetCoreGuiEnabled was called instead of SetCore"
		end
		if IconController.mimicCoreGui then
			IconController.previousTopbarEnabled = topbarEnabled
			if IconController.controllerModeEnabled then
				IconController.setTopbarEnabled(false,false)
			else
				IconController.setTopbarEnabled(topbarEnabled,false)
			end
		end
		IconController.updateTopbar()
	end)
	local makeVisible = checkTopbarEnabled()
	if not makeVisible and not IconController.mimicCoreGui then
		makeVisible = true
	end
	IconController.setTopbarEnabled(makeVisible, false)
end)()

-- Mimic roblox menu when opened and closed
guiService.MenuClosed:Connect(function()
	if VRService.VREnabled then
		return
	end
	menuOpen = false
	if not IconController.controllerModeEnabled then
		IconController.setTopbarEnabled(IconController.topbarEnabled,false)
	end
end)
guiService.MenuOpened:Connect(function()
	if VRService.VREnabled then
		return
	end
	menuOpen = true
	IconController.setTopbarEnabled(false,false)
end)

bindCamera()

-- It's important we update all icons when a players language changes to account for changes in the width of text, etc
task.spawn(function()
	local success, translator = pcall(function() return localizationService:GetTranslatorForPlayerAsync(localPlayer) end)
	local function updateAllIcons()
		local icons = IconController.getIcons()
		for _, icon in pairs(icons) do
			icon:_updateAll()
		end
	end
	if success then
		IconController.translator = translator
		translator:GetPropertyChangedSignal("LocaleId"):Connect(updateAllIcons)
		task.spawn(updateAllIcons)
		task.delay(1, updateAllIcons)
		task.delay(10, updateAllIcons)
	end
end)


return IconController end
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

