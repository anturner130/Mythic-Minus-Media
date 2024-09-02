MMMedia.loaders["VuhdoNicknames"] = function()
    debug("VuhdoNicknames loader")
    if not NickTag then return end

    -- Override the GetNickname function
    function NickTag:GetNickname(playerName, default, silent)
        if name and default and name ~= default then
            return name
        end
        name = MMAPI and MMAPI:GetName(playerName)
        if name then
            return name
        end
        return default
    end
end
