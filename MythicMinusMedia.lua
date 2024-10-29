local LSM = LibStub("LibSharedMedia-3.0")
MMMedia = {}
MMMedia["name"] = "Mythic Minus Media"
MMMedia.loaded = false
MMMedia.loaders = {}         -- Runs after this addon is loaded
MMMedia.externalLoaders = {} -- Runs after external addon is loaded
local wasLoaded = false


local DEBUG = true
DEBUG = DEBUG and UnitName("player") == "Turnerz" --safe guard so releases never have debug on
function debug(msg)
    if DEBUG then print("|cFF00FF00[DEBUG]|r " .. msg) end
end

MMMedia.loaders["debug"] = function()
    DEBUG = true
    debug("debug loader")
end

-- Define the slash command handler
SLASH_MMDEBUG1 = '/mmdebug'
function SlashCmdList.MMDEBUG(msg, editBox)
    if msg == '0' then
        MMMConfig.debug = false
        print("MMDebug: Debugging disabled.")
    else
        MMMConfig.debug = true
        print("MMDebug: Debugging enabled.")
    end
end

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" then
        -- Check if arg1 is equal to or greater than the name of this addon
        if not MMMedia.loaded and arg1 >= "MythicMinusMedia" then
            debug("MythicMinusMedia loaded")
            MMMedia.loaded = true

            -- Create the config table if it doesn't exist
            if not MMMConfig then
                debug("Creating MMMConfig")
                MMMConfig = {
                    ["CellNicknames"] = true,
                    ["DefaultNicknames"] = true,
                    ["ElvuiNicknames"] = true,
                    ["GridNicknames"] = true,
                    ["VuhdoNicknames"] = true,
                    ["debug"] = false
                }
            end

            -- Execute the loaders
            for key, loader in pairs(MMMedia.loaders) do
                debug("Running loader for " .. key)
                if MMMConfig[key] and MMMConfig[key] == true then
                    loader()
                end
            end
        end

        -- Execute the external loader
        if MMMedia.externalLoaders[arg1] and MMMedia.externalLoaders[arg1] == true then
            debug("Running external loader for " .. arg1)
            MMMedia.externalLoaders[arg1]()
        end

        if(arg1 == "WeakAuras" and not wasLoaded)
        then
            debug("Updating WeakAuras." .. arg1)
            wasLoaded = true
            MMWeakAuraUpdater:CheckUpdateWeakAuras()
        end
    end
end)


if WeakAuras then
    debug("WeakAuras installed and already loaded")
    wasLoaded = true
    MMWeakAuraUpdater:CheckUpdateWeakAuras()
    return
end

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")

--Sounds
-- register trump stroke with purple name

LSM:Register("sound", "Trump Stroke", [[Interface\Addons\MythicMinusMedia\Media\Sounds\trump_stroke.ogg]])
LSM:Register("sound", "Mario Jump", [[Interface\Addons\MythicMinusMedia\Media\Sounds\mario_jump.ogg]])

-- --Fonts
LSM:Register("font", "Expressway", [[Interface\Addons\MythicMinusMedia\Media\Fonts\Expressway.TTF]])

