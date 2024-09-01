MMMedia.loaders["DefaultNicknames"] = function()
    -- Create a function to override the name display
    local function OverrideRaidFrameNames(frame)
        -- Check if the frame has a unit associated (e.g., "raid1", "raid2")
        if frame.unit then
            -- Example: Replace the name with "Player" for demonstration
            -- You can replace this with any custom logic to set the name
            local customName = "Player" -- Replace with desired name or logic

            -- Get the name of the unit (original)
            local unitName = GetUnitName(frame.unit, true)
            local name = MMAPI and MMAPI:GetName(unitName)

            -- Example custom logic: Append " [Custom]" to all raid names
            frame.name:SetText(name or unitName)
        end
    end

    -- Hook into the CompactUnitFrame_UpdateName function
    hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
        -- Only override if it's a raid frame
        if frame:IsForbidden() then return end
        OverrideRaidFrameNames(frame)
    end)
end
