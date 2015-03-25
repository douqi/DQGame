-- DLHomeLayer

local M = {}
DLHomeLayer = M

function M.scene()
    local scene = CCScene:create()
    local layer = M.create()
    scene:addChild(layer)
    
    return scene
end

function M.initEnv()
	require("doozii")
    
    DLCommon.init()
    
	DLCommon.addSearchPath("DLRes/")
	DLRes.loadSheet("dz_sheet_uikit2.plist")
end

function M.create()
	M.initEnv()
	local param = {onEnter=M.onEnter, onExit=M.onExit}
	local layer = DLLayer.create(param)
    M.layer = layer
	M.layoutUI(layer)
	return layer
end

function M.onEnter()
	DDLOG("DLHomeLayer onEnter")
end

function M.onExit()
	DDLOG("DLHomeLayer onExit")
end

function M.unloadModule()
	local function unrequire(mPath)
		local mName = ""
		local lastSlashIndex = string.find(mPath, "/[^/]*$")
		if lastSlashIndex == nil then
			mName = mPath
		else
			mName = string.sub(mPath, lastSlashIndex + 1,string.len(mPath))
		end
		package.loaded[mPath] = nil
		_G[mName] = nil
	end

	for k,v in pairs(package.loaded) do
		local pre = string.sub(k, 1, 2)
		if pre == "DL" then
			local dzpre = string.sub(k, 1, 8)
			if dzpre ~= "DLDoozii" then
				DDLOG("unload module: %s", k)
				unrequire(k)
			end
		end
	end
end

function M.resetSearchPath()
	DLCommon.resetSearchPath()
	DLCommon.addSearchPath("DLRes/")
end

function M.gotoApp(appname)
    DLRes.unloadSheet("sheet_common.plist")
	M.resetSearchPath()

	local searchPathBase = "DLApps/" .. appname
	DLCommon.addSearchPath(searchPathBase)
	DLCommon.addSearchPath(searchPathBase .. "/DLFile")
	DLCommon.addSearchPath(searchPathBase .. "/Resources")
	DLCommon.addSearchPath(searchPathBase .. "/Resources/pages")
	DLCommon.addSearchPath(searchPathBase .. "/Resources/game")
    DLCommon.addSearchPath(searchPathBase .. "/Resources/ui")

	M.unloadModule()
	DLRes.loadSheet("sheet_common.plist")
	require("DLMainLayer")
    
    DLMainLayer.init()
	local scene = DLMainLayer.scene()
	scene:retain()
	
	--  GOTO the Game 
	local function delayFunc()
		DLScene.pushScene(scene)
		scene:release()	
	end
	DLCommon.scheduleOnce(M.layer, delayFunc, 0)
end

function M.gotoAppEx(appname)
	if DLMainLayer ~= nil and DLMainLayer.uninit ~= nil then
		DLMainLayer.uninit()		
        DLScene.popScene()
	end
	
	local function delayFunc( )
        M.gotoApp(appname)
	end
	DLTimer.create(delayFunc, 0, true)
end

function M.layoutUI(layer)
	
	M.gotoAppEx("DLDemo")
	return 
end

function M.sayHi()
    DDLOG("DLHomeLayer ---------> Hi")
end

return DLHomeLayer
