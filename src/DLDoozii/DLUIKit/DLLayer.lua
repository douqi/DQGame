local MODULE_NAME = "DLLayer"

module(MODULE_NAME, package.seeall)
---------- PRIVATE -------
local function hello()
    DDLOG(MODULE_NAME .. " say hello, loaded")
end
hello()

---------- PUBLIC --------
function create(param)
    local layer = cc.Layer:create()
    --	layer:setKeypadEnabled(true)

    -- 1. register callback "onEnter" + "onExit"
    local onEnter = param.onEnter
    local onExit  = param.onExit
    local function tListener(tag)
        DDLOG("tListener status = " .. tag)
        if tag == "enter" then
            if onEnter ~= nil then
                onEnter()
            end
        elseif tag == "exit" then
            if onExit ~= nil then
                onExit()
            end
        end
    end
    layer:registerScriptHandler(tListener)

    return layer
end