-- DLLang

local M = {}
DLLang = M

--[[
local  localizedStr = DLLang.getString("LEVEL_TITLE")
]]--

function M.getString(key, default)
    local lang = cc.Application:getInstance():getCurrentLanguage()
    --	DDLOG("lang = " .. tostring(lang))
    local mLang = 0
    if lang == cc.LANGUAGE_CHINESE then
        mLang = require("DLLang/DLLangCn.lua")
    else
        mLang = require("DLLang/DLLangEn.lua")
    end

    local desc = mLang[key] or default

    return desc
end

function M.sayHi()
    DDLOG("DLLang ---------> Hi")
end

return DLLang