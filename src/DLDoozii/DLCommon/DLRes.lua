local MODULE_NAME = "DLRes"

module(MODULE_NAME, package.seeall)
---------- PRIVATE -------
local function hello()
    DDLOG(MODULE_NAME .. " say hello, loaded")
end
hello()

---------- PUBLIC --------
local res = {}
function loadSheet(resPath)
--	local fullPath = DLCommon.getResFullPath(resPath)
	local fullPath = resPath
	if fullPath ~= nil then
		local refCount = res[fullPath]
		if (refCount == nil) or (refCount == 0) then 
			refCount = 1
			local cache = cc.SpriteFrameCache:getInstance()
            cache:addSpriteFrames(fullPath)
		else
			refCount = refCount + 1
		end
		res[fullPath] = refCount
	end
end

function unloadSheet(resPath)
--	local fullPath = DLCommon.getResFullPath(resPath)
	local fullPath = resPath
	if fullPath ~= nil then
		local refCount = res[fullPath]
		if (refCount == nil) or (refCount < 1) then
		else
			refCount = refCount - 1
			res[fullPath] = refCount
			if refCount < 1 then
                local cache = cc.SpriteFrameCache:getInstance()
                cache:removeSpriteFramesFromFile(fullPath)	
			end
		end 
	end
end


local S_FILE_INFO = {}
function loadFileInfo(fi)
    local ref = S_FILE_INFO[fi] or 0
    if ref == 0 then
        local mgr = ccs.ArmatureDataManager:getInstance()
        mgr:addArmatureFileInfo(fi)
    end
    ref = ref + 1
    S_FILE_INFO[fi] = ref
end

function unloadFileInfo(fi)
    local ref = S_FILE_INFO[fi] or 0
    ref = ref - 1

    if ref <= 0 then
        ref = 0
        local mgr = ccs.ArmatureDataManager:getInstance()
        mgr:removeArmatureFileInfo(fi)
    end

    S_FILE_INFO[fi] = ref
end
