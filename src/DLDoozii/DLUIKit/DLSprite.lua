local MODULE_NAME = "DLSprite"

module(MODULE_NAME, package.seeall)
---------- PRIVATE -------
local function hello()
    DDLOG(MODULE_NAME .. " say hello, loaded")
end
hello()

---------- PUBLIC --------
function create(fileName, cached)
	if	cached ~= nil and cached == true then
		local sprite = cc.Sprite:createWithSpriteFrameName(fileName)
		return sprite
	end

--	local fullPath = DLCommon.getResFullPath(fileName)
	local fullPath = fileName
	if fullPath ~= nil then
		local sprite = cc.Sprite:create(fullPath)
		return sprite
	end
	return nil
end

function createScale9Sprite(fileName, cached)
	if	cached ~= nil and cached == true then
		local sprite = cc.Scale9Sprite:createWithSpriteFrameName(fileName)
		return sprite
	end

--	local fullPath = DLCommon.getResFullPath(fileName)
	local fullPath = fileName
	if fullPath ~= nil then
		local sprite = cc.Scale9Sprite:create(fullPath)
		return sprite
	end
	return nil
end