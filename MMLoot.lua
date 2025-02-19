local _, addon = ...
addon.TEXTURE = [[Interface\ChatFrame\ChatFrameBackground]]

local BACKDROP = {
    bgFile = addon.TEXTURE,
    edgeFile = addon.TEXTURE,
    edgeSize = 1,
}

local backdropMixin = {}
function backdropMixin:CreateBackdrop(backdropAlpha, borderAlpha)
    if not self.SetBackdrop then
        Mixin(self, BackdropTemplateMixin)
    end

    self:SetBackdrop(BACKDROP)
    self:SetBackdropColor(0, 0, 0, backdropAlpha or 0.5)
    self:SetBackdropBorderColor(0, 0, 0, borderAlpha or 1)
end

local frame = Mixin(CreateFrame("Frame", "MMLootFrame", UIParent), backdropMixin)
frame:SetPoint("CENTER")
frame:SetSize(600, 400)
frame:SetFrameStrata("DIALOG")
frame:SetToplevel(true)
frame:Hide()
frame:CreateBackdrop()

local editbox = Mixin(CreateFrame("EditBox", nil, frame), backdropMixin)
editbox:SetPoint("TOPLEFT", 5, -5)
editbox:SetPoint("BOTTOMRIGHT", -5, 30)
editbox:SetFontObject(ChatFontNormal)
editbox:SetMultiLine(true)
editbox:SetAutoFocus(false)
editbox:CreateBackdrop()
editbox:SetScript("OnEscapePressed", function()
    editbox:ClearFocus()
end)
editbox:SetScript("OnShow", function()
    editbox:SetFocus(true)
end)

local submit = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
submit:SetPoint("BOTTOM", -25, 5)
submit:SetSize(50, 20)
submit:SetText("Paste")
submit:SetScript("OnClick", function()
    if not RCLootCouncilML.running then
        print("MMLoot: No RCLootCouncil session active")
        return
    end

    for _, line in ipairs({ string.split("\n", editbox:GetText()) }) do
        ProcessLootLine(line)
    end

    editbox:SetText("")
    frame:Hide()
end)

editbox:SetScript('OnEnterPressed', function()
    if IsControlKeyDown() then
        submit:Click()
    end
end)

local close = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
close:SetPoint("BOTTOM", 25, 5)
close:SetSize(50, 20)
close:SetText("Close")
close:SetScript("OnClick", function()
    frame:Hide()
end)

function ProcessLootLine(line)
    local sessionID, shortName = line:match("([^,]+),([^,]+)")

    local name, realm = UnitFullName(shortName)

    if name == nil then
        -- Player not in raid
        print("MMLoot: " .. shortName .. " is not in the raid. Not awarding anything to them")
        return
    end

    if realm == nil then
        realm = GetRealmName()
    end

    RCLootCouncilML:Award(tonumber(sessionID), name .. "-" .. realm, "automated", nil)

    return sessionID, name
end

SLASH_MMLOOT1 = "/mmloot"
SlashCmdList["MMLOOT"] = function()
    if frame:IsShown() then
        frame:Hide()
    else
        if not RCLootCouncilML.running then
            print("MMLoot: No RCLootCouncil session active")
            return
        end
        frame:Show()
    end
end
