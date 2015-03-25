local MODULE_NAME = "DLCallback"

module(MODULE_NAME, package.seeall)
---------- PRIVATE -------
local function hello()
    DDLOG(MODULE_NAME .. " say hello, loaded")
end
hello()

---------- PUBLIC --------
function create(object, func)
    local function invoke(...)
        return func(object, ...)
    end

    return invoke
end