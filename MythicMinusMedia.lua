local LSM = LibStub("LibSharedMedia-3.0")
MMMedia = {}
MMMedia["name"] = "Mythic Minus Media"
MMMedia.loaded = false
MMMedia.loaders = {}         -- Runs after this addon is loaded
MMMedia.externalLoaders = {} -- Runs after external addon is loaded

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 == "MythicMinusMedia" then
            MMMedia.loaded = true

            -- Create the config table if it doesn't exist
            if not MMMConfig then
                MMMConfig = {
                    ["CellNicknames"] = true,
                    ["DefaultNicknames"] = true,
                    ["ElvuiNicknames"] = true,
                    ["GridNicknames"] = true,
                    ["VuhdoNicknames"] = true
                }
            end

            -- Execute the loaders
            for key, loader in pairs(MMMedia.loaders) do
                if MMMConfig[key] then
                    loader()
                end
            end
        end

        -- Execute the external loader
        if MMMedia.externalLoaders[arg1] then
            print("Running external loader for " .. arg1)
            MMMedia.externalLoaders[arg1]()
        end
    end
end)


frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")

--Sounds
LSM:Register("sound", "Trump Stroke", [[Interface\Addons\MythicMinusMedia\Media\Sounds\trump_stroke.ogg]])

-- --Fonts
LSM:Register("font", "Expressway", [[Interface\Addons\MythicMinusMedia\Media\Fonts\Expressway.TTF]])
