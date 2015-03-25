local MODULE_NAME = "DLScene"

module(MODULE_NAME, package.seeall)
---------- PRIVATE -------
local function hello()
    DDLOG(MODULE_NAME .. " say hello, loaded")
end
hello()

---------- PUBLIC --------
function getRunningScene()
    return cc.Director:getInstance():getRunningScene()
end

function gotoScene(scene)
	-- currentScene = scene
	-- The first scene is in Cocos2d-x.
	local cs = getRunningScene()
	if cs then
		cc.Director:getInstance():replaceScene(scene)
	else
        cc.Director:getInstance():runWithScene(scene)
	end
end

function pushScene(scene)
    cc.Director:getInstance():pushScene(scene)
end

function popScene()
    cc.Director:getInstance():popScene()
end