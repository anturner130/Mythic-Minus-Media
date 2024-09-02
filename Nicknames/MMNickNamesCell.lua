MMMedia.loaders["CellNicknames"] = function()
    debug("CellNicknames loader")
    if not Cell then return end

    local F = Cell.funcs

    function F:GetNickname(shortname, fullname)
        local name
        if Cell.vars.nicknameCustomEnabled then
            name = Cell.vars.nicknameCustoms[fullname] or
                Cell.vars.nicknameCustoms[shortname] or
                Cell.vars.nicknames[fullname] or
                Cell.vars.nicknames[shortname] or
                shortname
        else
            name = (MMAPI and MMAPI:GetName(fullname)) or
                (MMAPI and MMAPI:GetName(shortname)) or
                Cell.vars.nicknames[fullname] or
                Cell.vars.nicknames[shortname] or
                shortname
        end
        return name or _G.UNKNOWNOBJECT
    end
end
