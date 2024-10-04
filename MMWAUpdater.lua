debug("MMWAUpdater.lua loaded")
MMWeakAuraUpdater = {}

-- Read all weakauras from WeakAurasSaved and print them to the console with name, version, and file.
function MMWeakAuraUpdater:CheckUpdateWeakAuras()
    debug("MMWeakAuraUpdater:CheckUpdateWeakAuras")
    if not WeakAuras or not WeakAurasSaved then
        debug("WeakAuras is not installed")
        return
    end

    MMWeakAuraUpdater.WeakAuras = MMWAs
    local hasUpdate = false
    for _, wa in ipairs(MMWeakAuraUpdater.WeakAuras) do
        wa.found = false    

        -- Iterate through all installed weakauras and check if they are out of date
        for name, data in pairs(WeakAurasSaved.displays) do
            if data.uid == wa.uid then
                debug("WeakAura found: " .. wa.name)
                wa.prvVersion = data.version
                wa.update = wa.prvVersion < wa.version
                wa.found = true
                hasUpdate = hasUpdate or wa.update
                break
            end
        end

         -- Set defaults in case the weakaura is not found
        if not wa.found then
            wa.uid = nil
            wa.prvVersion = 0
            wa.update = true 
            hasUpdate = true
        end
    end

    if hasUpdate then
        MMWeakAuraUpdater:PromptToUpdateWeakAuras()
    else
        debug("No weakauras to update")
    end
end

-- Create UI to prompt user to update weakauras
function MMWeakAuraUpdater:PromptToUpdateWeakAuras()
    debug("MMWeakAuraUpdater:PromptToUpdateWeakAuras " .. #MMWeakAuraUpdater.WeakAuras)
    -- check size of wasToUpdate array
    if not MMWeakAuraUpdater.WeakAuras then
        debug("No weakauras to update")
        return
    end

    local text = ""
    for _, wa in ipairs(MMWeakAuraUpdater.WeakAuras) do
        if wa.update then
            text = text .. wa.name .. "  v" .. wa.prvVersion .. " --> v" .. wa.version .. "\n"
        end
    end

    local scalingHeight = 20 * #MMWeakAuraUpdater.WeakAuras
    -- Create a frame to prompt the user to update weakauras
    local frame = CreateFrame("Frame", "MMWeakAuraUpdaterFrame", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(350, 60 + scalingHeight)
    frame:SetPoint("CENTER")
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("CENTER", frame.TitleBg, "CENTER", 0, 0)
    frame.title:SetText("M- WeakAura Updater")
    frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.text:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -30)
    frame.text:SetText("The following WeakAuras are out of date:")
    frame.text:SetWidth(320)
    frame.text:SetHeight(20)
    frame.text:SetJustifyH("CENTER")
    frame.text:SetJustifyV("TOP")
    frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.text:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -50)
    frame.text:SetText(text)
    frame.text:SetWidth(320)
    frame.text:SetHeight(20 + scalingHeight)
    frame.text:SetWordWrap(true)
    frame.text:SetJustifyH("LEFT")
    frame.text:SetJustifyV("TOP")


    -- Create a button to update weakauras
    frame.updateButton = CreateFrame("Button", "MMWeakAuraUpdaterUpdateButton", frame, "UIPanelButtonTemplate")
    frame.updateButton:SetSize(100, 25)
    frame.updateButton:SetPoint("BOTTOM", frame, "BOTTOM", 10, 10)
    frame.updateButton:SetText("Update")
    frame.updateButton:SetScript("OnClick", function(self)
        MMWeakAuraUpdater:UpdateWeakAuras(1)
        frame:Hide()
    end)
    frame:Show()
end

-- Update weakauras
function MMWeakAuraUpdater:UpdateWeakAuras(index)
    if not MMWeakAuraUpdater.WeakAuras then
        debug("WeakAuras is not installed")
        return
    end
    -- Check bounds
    if not MMWeakAuraUpdater.WeakAuras[index] then
        debug("All weakauras updated")
        return
    end

    local cb = function(success, msg)
        if success then
            debug("WeakAura updated successfully")
            MMWeakAuraUpdater:UpdateWeakAuras(index + 1)
        else
            debug("Failed to update WeakAura")
        end
    end

    local wa = MMWeakAuraUpdater.WeakAuras[index]
    if not wa.update then
        MMWeakAuraUpdater:UpdateWeakAuras(index + 1)
        return
    end
    -- Update through the WeakAuras API
    WeakAuras.Import(wa.embed, wa.uid, cb, nil)
end
