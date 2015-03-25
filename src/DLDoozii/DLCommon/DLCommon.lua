local MODULE_NAME = "DLCommon"

module(MODULE_NAME, package.seeall)
---------- PRIVATE -------
local function hello()
    DDLOG(MODULE_NAME .. " say hello, loaded")
end
hello()


local mMode = "debug"
local mWidth = 640
local mHeight = 960
local mSearchPath = nil

---------- PUBLIC --------
function init()
    --- Here should be load config from config.json... 
end

function getMode()
    return mMode
end

function gameWidth()
    return mWidth
end

function gameWidth()
    return mHeight
end


local function getScriptRootPath()
    local mode = getMode()
    if mode == "debug" then
        return "src/"
    else
        local path = cc.FileUtils:getInstance():getWritablePath() .. "LuaScripts/"
        return path 
    end
    
end
local function backupPath()
    if mSearchPath == nil then
        local tPath = cc.FileUtils:getInstance():getSearchPaths()
        mSearchPath = clone(tPath)
    end
end

function resetSearchPath()
    backupPath();
    cc.FileUtils:getInstance():purgeCachedEntries();
    cc.FileUtils:getInstance():setSearchPaths(mSearchPath);
end

function addSearchPath(path)
    backupPath();
    if cc.FileUtils:getInstance():isAbsolutePath(path) then
        cc.FileUtils:getInstance():addSearchPath(path)
    else 
        local tPath = getScriptRootPath() .. path
        cc.FileUtils:getInstance():addSearchPath(tPath);
    end
    
end

function getResFullPath(filename)
	local fullPath = cc.FileUtils:getInstance():fullPathForFilename(filename)
	return fullPath
end

function schedule(node, callback, delay)
    local action
    local function tFunc()
        if callback then
            callback(action)
        end
    end
    local delay = cc.DelayTime:create(delay)
    local sequence = cc.Sequence:create(delay, cc.CallFunc:create(tFunc))
    action = cc.RepeatForever:create(sequence)
    node:runAction(action)
    return action
end

function scheduleOnce(node, callback, delay)
    local delay = cc.DelayTime:create(delay)
    local action = cc.Sequence:create(delay, cc.CallFunc:create(callback))
    node:runAction(action)
end