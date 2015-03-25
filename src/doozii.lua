-- doozii

local M = {}
doozii = M

-- define the global function DDLOG
_G["DDLOG"] = function(...)
	print(string.format(...))
end

local function DLRequire(modpath, modname)
    local pathName = modpath..modname
    require(pathName)
    package.loaded[pathName] = package.loaded[modname]
    package.loaded[modname] = nil
end

-- 
DLRequire("DLDoozii/DLCommon/", "DLConstants")

DLRequire("DLDoozii/DLCommon/", "DLCommon")
DLRequire("DLDoozii/DLCommon/", "DLResolution")
DLRequire("DLDoozii/DLCommon/", "DLScene")
DLRequire("DLDoozii/DLCommon/", "DLRes")
DLRequire("DLDoozii/DLCommon/", "DLCallback")
DLRequire("DLDoozii/DLCommon/", "DLTimer")

DLRequire("DLDoozii/DLUIKit/", "DLLayer")
DLRequire("DLDoozii/DLUIKit/", "DLSprite")
DLRequire("DLDoozii/DLUIKit/", "DLButton")
DLRequire("DLDoozii/DLUIKit/", "DLToast")





function M.sayHi()
    DDLOG("doozii ---------> Hi")
end


return doozii

