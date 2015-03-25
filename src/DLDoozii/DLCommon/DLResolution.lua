local MODULE_NAME = "DLResolution"

module(MODULE_NAME, package.seeall)
---------- PRIVATE -------
local function hello()
    DDLOG(MODULE_NAME .. " say hello, loaded")
end
hello()

local SCALE_X
local SCALE_Y

local REF_WIDTH
local REF_HEIGHT

local DES_WIDTH
local DES_HEIGHT

---------- PUBLIC --------
SCALE_MIN       = 1.0
SCALE_MAX       = 1.0

---------------------------
--@return #cc.p
function dz.p(x, y)
    return cc.p(x, y)
end

---------------------------
--@return # change "relative coordinate" to "absolute coordinate" 
function dz.xp(x, y)
    local tx = x * SCALE_X 
    local ty = y * SCALE_Y
    return cc.p(tx, ty)
end

---------------------------
--@return # change "relative x" to "absolute x"
function dz.dpx(x)
    local tx = x * SCALE_X --/REF_WIDTH * DES_WIDTH
    return tx
end

---------------------------
--@return # change "relative y" to "absolute y"
function dz.dpy(y)
    local ty = y * SCALE_Y -- /REF_HEIGHT * DES_HEIGHT
    return ty
end

---------------------------
--@return # change "absolute coordinate" to "relative coordinate"
function dz.dp(x, y)
    local tx = x / SCALE_X
    local ty = y / SCALE_Y
    return cc.p(tx, ty)
end


function init(wd, hi)
	-- body
	-- REF_WIDTH  	= 320.0
	-- REF_HEIGHT 	= 480.0
	REF_WIDTH  	= wd
	REF_HEIGHT 	= hi
	SCALE_MIN		= 1.0
	SCALE_MAX		= 1.0

	DES_WIDTH 	= REF_WIDTH
	DES_HEIGHT	= REF_HEIGHT

	local glView = cc.Director:getInstance():getOpenGLView()

	local frameSize = glView:getFrameSize()

	local scaleX = frameSize.width 	/ REF_WIDTH 
	local scaleY = frameSize.height / REF_HEIGHT
	SCALE_MAX = math.max(scaleX, scaleY)
	SCALE_MIN = math.min(scaleX, scaleY)


	DES_HEIGHT 	= frameSize.height / SCALE_MIN
	DES_WIDTH 	= frameSize.width  / SCALE_MIN
	
	--- transform to Design 
	SCALE_X = DES_WIDTH / REF_WIDTH
	SCALE_Y = DES_HEIGHT / REF_HEIGHT
	SCALE_MAX = math.max(SCALE_X, SCALE_Y)
	SCALE_MIN = math.min(SCALE_X, SCALE_Y)

	DDLOG("DES_WIDTH_HEIGHT = (%f, %f)", DES_WIDTH, DES_HEIGHT)
	glView:setDesignResolutionSize(DES_WIDTH, DES_HEIGHT, cc.ResolutionPolicy.SHOW_ALL)
end