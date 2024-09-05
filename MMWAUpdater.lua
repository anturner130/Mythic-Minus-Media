debug("MMWAUpdater.lua loaded")
MMWeakAuraUpdater = {}
MMWeakAuraUpdater.WeakAuras = {
    ["brII87rOnHy"] = {
        ["name"] = "Mythic- Core",
        ["version"] = 27,
        ["import"] = MMWACore
    }
}

-- Read all weakauras from WeakAurasSaved and print them to the console with name, version, and file.
function MMWeakAuraUpdater:CheckUpdateWeakAuras()
    if not WeakAuras or not WeakAurasSaved then
        debug("WeakAuras is not installed")
        return
    end

    WAsToUpdate = {}
    debug("Checking for updates to Mythic- Core")
    for name, pack in pairs(WeakAurasSaved.displays) do
        if MMWeakAuraUpdater.WeakAuras[pack.uid] then
            debug("Found " .. MMWeakAuraUpdater.WeakAuras[pack.uid].name)
            local wa = MMWeakAuraUpdater.WeakAuras[pack.uid]
            if pack.version < wa.version then
                debug("Updating " .. wa.name .. " to version " .. wa.version)
                -- Add to WAsToUpdate
                wa["prvVersion"] = pack.version
                WAsToUpdate[pack.uid] = wa
            end
        end
    end

    
    for key, wa in pairs(WAsToUpdate) do
        debug("Prompting user to update weakauras")
        MMWeakAuraUpdater:PromptToUpdateWeakAuras(WAsToUpdate)
        return
    end
    
    debug("No weakauras to update")
end

-- Create UI to prompt user to update weakauras
function MMWeakAuraUpdater:PromptToUpdateWeakAuras(WAsToUpdate)
    debug("MMWeakAuraUpdater:PromptToUpdateWeakAuras " .. #WAsToUpdate)
    -- check size of wasToUpdate array 
    if not WAsToUpdate then
        debug("No weakauras to update")
        return
    end

    debug("Prompting user to update weakauras")
    local text = "The following weakauras are out of date:\n"
    for key, wa in pairs(WAsToUpdate) do
        text = text .. wa.name .. "  v" .. wa.prvVersion .. " --> v" .. wa.version .. "\n"
    end

    -- Create a frame to prompt the user to update weakauras
    local frame = CreateFrame("Frame", "MMWeakAuraUpdaterFrame", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(300, 150)
    frame:SetPoint("CENTER")
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("CENTER", frame.TitleBg, "CENTER", 0, 0)
    frame.title:SetText("M- WeakAura Updater")
    frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.text:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -30)
    frame.text:SetText(text)
    frame.text:SetWidth(280)
    frame.text:SetWordWrap(true)
    frame.text:SetJustifyH("LEFT")
    frame.text:SetJustifyV("TOP")

    -- Create a button to update weakauras
    frame.updateButton = CreateFrame("Button", "MMWeakAuraUpdaterUpdateButton", frame, "UIPanelButtonTemplate")
    frame.updateButton:SetSize(100, 25)
    frame.updateButton:SetPoint("BOTTOM", frame, "BOTTOM", 10, 10)
    frame.updateButton:SetText("Update")
    frame.updateButton:SetScript("OnClick", function(self)
        for key, wa in pairs(WAsToUpdate) do
            debug("Updating " .. wa.name)
            MMWeakAuraUpdater:UpdateWeakAura(key, wa.import)
        end
        frame:Hide()
    end)
    frame:Show()
end

function MMWeakAuraUpdater:OnUpdateComplete()
    
end

-- Update weakauras
function MMWeakAuraUpdater:UpdateWeakAura(uid, import)
    debug("MMWeakAuraUpdater:UpdateWeakAura " .. uid)
    if not WeakAuras or not uid or not  import then
        debug("WeakAuras is not installed")
        return
    end

    debug("Updating " .. uid)
    WeakAuras.Import(import, uid, nil, nil)
end

