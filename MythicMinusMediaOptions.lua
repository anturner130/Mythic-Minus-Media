-- Create the options panel frame
local optionsPanel = CreateFrame("Frame", "MythicMinusMediaOptionsPanel", InterfaceOptionsFramePanelContainer)
optionsPanel.name = MMMedia.name

local reloadLabel = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormal")

-- Add a title to the options panel
local title = optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("Mythic Minus Media Options")

-- Add a checkbox for DefaultNicknames
local defaultNicknamesCheckbox = CreateFrame("CheckButton", "DefaultNicknamesCheckbox", optionsPanel, "InterfaceOptionsCheckButtonTemplate")
defaultNicknamesCheckbox:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
defaultNicknamesCheckbox.Text:SetText("Enable Default Nicknames")
defaultNicknamesCheckbox:SetScript("OnClick", function(self)
    MMMConfig["DefaultNicknames"] = self:GetChecked()
    reloadLabel:Show()
end)

-- Add a checkbox for ElvuiNicknames
local elvuiNicknamesCheckbox = CreateFrame("CheckButton", "ElvuiNicknamesCheckbox", optionsPanel, "InterfaceOptionsCheckButtonTemplate")
elvuiNicknamesCheckbox:SetPoint("TOPLEFT", defaultNicknamesCheckbox, "BOTTOMLEFT", 0, -8)
elvuiNicknamesCheckbox.Text:SetText("Enable Elvui Nicknames")
elvuiNicknamesCheckbox:SetScript("OnClick", function(self)
    MMMConfig["ElvuiNicknames"] = self:GetChecked()
    reloadLabel:Show()
end)

-- Add a checkbox for GridNicknames
local gridNicknamesCheckbox = CreateFrame("CheckButton", "GridNicknamesCheckbox", optionsPanel, "InterfaceOptionsCheckButtonTemplate")
gridNicknamesCheckbox:SetPoint("TOPLEFT", elvuiNicknamesCheckbox, "BOTTOMLEFT", 0, -8)
gridNicknamesCheckbox.Text:SetText("Enable Grid Nicknames")
gridNicknamesCheckbox:SetScript("OnClick", function(self)
    MMMConfig["GridNicknames"] = self:GetChecked()
    reloadLabel:Show()
end)

-- Add a checkbox for CellNicknames
local cellNicknamesCheckbox = CreateFrame("CheckButton", "CellNicknamesCheckbox", optionsPanel, "InterfaceOptionsCheckButtonTemplate")
cellNicknamesCheckbox:SetPoint("TOPLEFT", gridNicknamesCheckbox, "BOTTOMLEFT", 0, -8)
cellNicknamesCheckbox.Text:SetText("Enable Cell Nicknames")
cellNicknamesCheckbox:SetScript("OnClick", function(self)
    MMMConfig["CellNicknames"] = self:GetChecked()
    reloadLabel:Show()
end)

-- Add a checkbox for VuhdoNicknames
local vuhdoNicknamesCheckbox = CreateFrame("CheckButton", "VuhdoNicknamesCheckbox", optionsPanel, "InterfaceOptionsCheckButtonTemplate")
vuhdoNicknamesCheckbox:SetPoint("TOPLEFT", cellNicknamesCheckbox, "BOTTOMLEFT", 0, -8)
vuhdoNicknamesCheckbox.Text:SetText("Enable Vuhdo Nicknames")
vuhdoNicknamesCheckbox:SetScript("OnClick", function(self)
    MMMConfig["VuhdoNicknames"] = self:GetChecked()
    reloadLabel:Show()
end)

-- Add a button to reset all settings
local resetButton = CreateFrame("Button", "ResetButton", optionsPanel, "UIPanelButtonTemplate")
resetButton:SetPoint("BOTTOMLEFT", 16, 16)
resetButton:SetSize(100, 22)
resetButton:SetText("Reset Settings")
resetButton:SetScript("OnClick", function(self)
    MMMConfig["DefaultNicknames"] = true
    MMMConfig["ElvuiNicknames"] = true
    MMMConfig["GridNicknames"] = true
    MMMConfig["CellNicknames"] = true
    MMMConfig["VuhdoNicknames"] = true
    defaultNicknamesCheckbox:SetChecked(true)
    elvuiNicknamesCheckbox:SetChecked(true)
    gridNicknamesCheckbox:SetChecked(true)
    cellNicknamesCheckbox:SetChecked(true)
    vuhdoNicknamesCheckbox:SetChecked(true)
    reloadLabel:Show()
end)

-- Add a label to reload the UI with default state hidden
reloadLabel:SetPoint("BOTTOMLEFT", resetButton, "BOTTOMRIGHT", 8, 0)
reloadLabel:SetText("Reload the UI to apply changes")
reloadLabel:Hide()

-- Hook into the OnShow event for the options panel
optionsPanel:SetScript("OnShow", function(self)
    -- Update the checkboxes to reflect the current settings
    cellNicknamesCheckbox:SetChecked(MMMConfig["CellNicknames"])
    defaultNicknamesCheckbox:SetChecked(MMMConfig["DefaultNicknames"])
    elvuiNicknamesCheckbox:SetChecked(MMMConfig["ElvuiNicknames"])
    gridNicknamesCheckbox:SetChecked(MMMConfig["GridNicknames"])
    vuhdoNicknamesCheckbox:SetChecked(MMMConfig["VuhdoNicknames"])
    
end)


-- Register the options panel
if InterfaceOptions_AddCategory then
	InterfaceOptions_AddCategory(optionsPanel)
else
	local category, layout = Settings.RegisterCanvasLayoutCategory(optionsPanel, optionsPanel.name);
	Settings.RegisterAddOnCategory(category);
	addon.settingsCategory = category
end


SLASH_MYTHIC_MINUS_MEDIA_OPTIONS1 = "/mmm"
function SlashCmdList.MYTHIC_MINUS_MEDIA_OPTIONS(msg)
    InterfaceOptionsFrame_OpenToCategory(MMMedia.name)
end