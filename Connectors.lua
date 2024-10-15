-- Desc: Contains all the connectors for to interact with other addons or weakauras

-- Connections for Northern Sky WA's
if NSAPI then
    -- Get the name of a spell
    function NSAPI:GetName(name)
        return MMAPI:GetName(name)
    end
end

-- Connections for Liquid WA's
LiquidAPI = LiquidAPI or {}
function LiquidAPI:GetName(name)
    return MMAPI:GetName(name)
end

-- Connections for BrikNicknames
-- Get a BrikNicknames object but rename to something way better lmao
local Briknames = BrikNicknames
if Briknames then
    -- Iterate over all the names and add them to the MMAlias table
    local lastNick = nil
    local namesList = {}
    for nick, name in pairs(MMAlias) do
        if nick ~= lastNick then
            if lastNick then
                Briknames:AddAlias(lastNick, namesList)
            end
            lastNick = nick
            namesList = {}
        end
        -- Add the names to the list
        table.insert(namesList, name)
    end
    -- Add the last name in the list
    Briknames:AddAlias(lastNick, namesList)
end
