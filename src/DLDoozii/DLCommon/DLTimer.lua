local MODULE_NAME = "DLTimer"

module(MODULE_NAME, package.seeall)
---------- PRIVATE -------
local function hello()
    DDLOG(MODULE_NAME .. " say hello, loaded")
end
hello()

---------- PUBLIC --------
function create(handler, seconds, once)
    local timer = -1
    local scheduler = cc.Director:getInstance():getScheduler()
    local function onTimer(dt)
        --		DDLOG("dltimer on timer")
        if once ~= nil and once == true and timer ~= -1 then
            scheduler:unscheduleScriptEntry(timer)
        end
        handler(dt)
    end
    timer = scheduler:scheduleScriptFunc(onTimer, seconds, false)
    return timer
end

function cancel(timer)
    local scheduler = cc.Director:getInstance():getScheduler()
    scheduler:unscheduleScriptEntry(timer)
end
