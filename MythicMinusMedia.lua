local LSM = LibStub("LibSharedMedia-3.0")
MMMedia = {}

--Sounds
LSM:Register("sound","Macro", [[Interface\Addons\MythicMinusMedia\Media\Sounds\macro.mp3]])
LSM:Register("sound","01", [[Interface\Addons\MythicMinusMedia\Media\Sounds\1.ogg]])
LSM:Register("sound","02", [[Interface\Addons\MythicMinusMedia\Media\Sounds\2.ogg]])
LSM:Register("sound","03", [[Interface\Addons\MythicMinusMedia\Media\Sounds\3.ogg]])
LSM:Register("sound","04", [[Interface\Addons\MythicMinusMedia\Media\Sounds\4.ogg]])
LSM:Register("sound","05", [[Interface\Addons\MythicMinusMedia\Media\Sounds\5.ogg]])
LSM:Register("sound","06", [[Interface\Addons\MythicMinusMedia\Media\Sounds\6.ogg]])
LSM:Register("sound","07", [[Interface\Addons\MythicMinusMedia\Media\Sounds\7.ogg]])
LSM:Register("sound","08", [[Interface\Addons\MythicMinusMedia\Media\Sounds\8.ogg]])
LSM:Register("sound","09", [[Interface\Addons\MythicMinusMedia\Media\Sounds\9.ogg]])
LSM:Register("sound","10", [[Interface\Addons\MythicMinusMedia\Media\Sounds\10.ogg]])
LSM:Register("sound","Dispel", [[Interface\Addons\MythicMinusMedia\Media\Sounds\Dispel.ogg]])
-- --Fonts
LSM:Register("font","Expressway", [[Interface\Addons\MythicMinusMedia\Media\Fonts\Expressway.TTF]])
-- --StatusBars
-- LSM:Register("statusbar","Atrocity", [[Interface\Addons\MythicMinusMedia\Media\StatusBars\Atrocity]])
-- Open WA Options
function MMMedia.OpenWA()
    WeakAuras.OpenOptions()
end


