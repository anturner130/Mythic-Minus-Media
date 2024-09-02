MMAPI = {}

-- Returns the alias for a given name or nil if it doesn't exist
function MMAPI:GetName(name)
    if not name then
        return nil
    end
    -- Convert unit ID to player name
    name = UnitName(name)

    -- Returns the table entry or nil if it doesn't exist
    return MMAlias[name]
end

setglobal("MMAPI", MMAPI)
