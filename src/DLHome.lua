-- DLHome
function __G__TRACKBACK__(msg)
	print("----------------------------------------")
	print("LUA ERROR: " .. tostring(msg) .. "\n")
	print(debug.traceback())
	print("----------------------------------------")
end

local function main()
	-- avoid memory leak
	collectgarbage("setpause", 100)
	collectgarbage("setstepmul", 5000)

    cc.FileUtils:getInstance():addSearchPath("src")
    cc.FileUtils:getInstance():addSearchPath("res")

    
    -- MUST setContentScaleFactor BEFORE USE "item of it"   
--    cc.Director:getInstance():setContentScaleFactor(2.0)

    -- run
	 require("DLDoozii/DLHomeLayer")
	 local homeScene = DLHomeLayer.scene()
	 DLScene.gotoScene(homeScene)
	 
end

xpcall(main, __G__TRACKBACK__)