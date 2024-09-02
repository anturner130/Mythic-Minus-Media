MMMedia.loaders["ElvuiNicknames"] = function()
	debug("ElvuiNicknames loader")
	if ElvUF and ElvUF.Tags then
		ElvUF.Tags.Events['MMNickName'] = 'UNIT_NAME_UPDATE'
		ElvUF.Tags.Events['MMNickName:Short'] = 'UNIT_NAME_UPDATE'
		ElvUF.Tags.Events['MMNickName:Medium'] = 'UNIT_NAME_UPDATE'
		ElvUF.Tags.Methods['MMNickName'] = function(unit)
			local name = UnitName(unit)
			return name and MMAPI and MMAPI:GetName(name) or name
		end

		ElvUF.Tags.Methods['MMNickName:veryshort'] = function(unit)
			local name = UnitName(unit)
			name = name and MMAPI and MMAPI:GetName(name) or name
			return string.sub(name, 1, 5)
		end

		ElvUF.Tags.Methods['MMNickName:short'] = function(unit)
			local name = UnitName(unit)
			name = name and MMAPI and MMAPI:GetName(name) or name
			return string.sub(name, 1, 8)
		end

		ElvUF.Tags.Methods['MMNickName:medium'] = function(unit)
			local name = UnitName(unit)
			name = name and MMAPI and MMAPI:GetName(name) or name
			return string.sub(name, 1, 10)
		end
	end
end
