local MODULE_NAME = "DLButton"

module(MODULE_NAME, package.seeall)
---------- PRIVATE -------
local function hello()
    DDLOG(MODULE_NAME .. " say hello, loaded")
end
hello()

---------- PUBLIC --------
function create(param)
	local nImage 	= param.nImage
	local pImage 	= param.pImage
	local cached 	= param.cached
	local listener 	= param.listener
	local tag 		= param.tag or 0
	local title 	= param.title or ""
    local bZoom     = true
	local hScale 	= param.scale or 1.02
	local fColor	= param.color or cc.c3b(169, 76, 0)
	local event 	= param.event or cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE

	if pImage == nil or pImage == nImage then
		pImage = nImage
		if param.scale then
		     bZoom = false
		end
	else
		hScale = 1.0
		bZoom = false
	end
	
	local nSprite = DLSprite.createScale9Sprite(nImage, cached)
	local pSprite = DLSprite.createScale9Sprite(pImage, cached)
	pSprite:setScale(hScale)

    local nSize     = param.size or nSprite:getPreferredSize()
    
--	local pTitleButton = cc.LabelTTF:create(title, "Helvetica", 28)
--	pTitleButton:setColor(fColor)
--    pTitleButton:enableOutline(cc.c4b(0,0,0,255), 1)
    local pTitleButton =  cc.Label:createWithSystemFont(title, "Helvetica", 28)
    pTitleButton:setColor(fColor)
    pTitleButton:enableOutline(fColor, 1)
    
	local pButton = cc.ControlButton:create(pTitleButton, nSprite)
	pButton:setBackgroundSpriteForState(pSprite, cc.CONTROL_STATE_HIGH_LIGHTED)
	pButton:setPreferredSize(nSize)
	
    pButton:setZoomOnTouchDown(bZoom)
    
	local function tListener()
		if listener ~= nil then
		  if pButton:isEnabled() then
		    listener(tag, pButton)
		  end
		end
	end
	
    pButton:registerControlEventHandler(tListener, event)
	
	param.nSprite = nSprite
	param.pSprite = pSprite
	pButton.param = param
	return pButton
end


function createByNode(param)
	local nImage 	= param.nImage
	local pImage 	= param.pImage
	local listener 	= param.listener
	local tag 		= param.tag or 0
	local title 	= param.title or ""
	local nSize 	= param.size or param.nImage:getContentSize()
	local fColor	= param.color or cc.c3b(169, 76, 0)
	
	
	local nSprite = DLSprite.createScale9Sprite("dz_trans.png", true)
	nImage:setPosition(nSize.width*0.5, nSize.height*0.5)
	nSprite:addChild(nImage)
	
    local pSprite = nil
    if pImage ~= nil and pImage ~= nImage then
        pSprite = DLSprite.createScale9Sprite("dz_trans.png", true)
        pImage:setPosition(nSize.width*0.5, nSize.height*0.5)
        pSprite:addChild(pImage)
    end
    
	
	
	local pTitleButton = cc.LabelTTF:create(title, "Helvetica", 28)
	pTitleButton:setColor(fColor)
	local pButton = cc.ControlButton:create(pTitleButton, nSprite)
	if pSprite == nil then
	   pButton:setZoomOnTouchDown(true)
	else
        pButton:setBackgroundSpriteForState(pSprite, cc.CONTROL_STATE_HIGH_LIGHTED)
        pButton:setZoomOnTouchDown(false)
	end
	
	pButton:setPreferredSize(nSize)
	
	local function tListener()
		if listener ~= nil then
		  if pButton:isEnabled() then
		    listener(tag, pButton)
		  end
		end
	end
    pButton:registerControlEventHandler(tListener, cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)
	
	param.nSprite = nSprite
	param.pSprite = pSprite
	pButton.param = param
	return pButton
end

function createWithBMFont(param)
    local nImage    = param.nImage
    local pImage    = param.pImage
    local cached    = param.cached
    local listener  = param.listener
    local tag       = param.tag or 0
    local title     = param.title or ""
    local bZoom     = true
    local hScale    = param.scale or 1.02
    local font      = param.font or "dzfont.fnt"
    local fColor    = param.fColor or cc.c3b(0,0,0)
    local fScale    = param.fScale or 1
    local event     = param.event or cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE

    if pImage == nil or pImage == nImage then
        pImage = nImage
        if param.scale then
            bZoom = false
        end
    else
        hScale = 1.0
    end
    local nSprite = DLSprite.createScale9Sprite(nImage, cached)
    local pSprite = DLSprite.createScale9Sprite(pImage, cached)
    pSprite:setScale(hScale)
    local nSize     = param.size or nSprite:getPreferredSize()

        
    local pTitleButton = cc.LabelBMFont:create(title, font)
    pTitleButton:setColor(fColor)
     pTitleButton:setScale(fScale)
    local pButton = cc.ControlButton:create(pTitleButton, nSprite)
    pButton:setBackgroundSpriteForState(pSprite, cc.CONTROL_STATE_HIGH_LIGHTED)
    pButton:setZoomOnTouchDown(bZoom)
    
    pButton:setPreferredSize(nSize)
    
    local function tListener()
        if listener ~= nil then
          if pButton:isEnabled() then
            listener(tag, pButton)
          end
        end
    end
    pButton:registerControlEventHandler(tListener, cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)
    
    param.nSprite = nSprite
    param.pSprite = pSprite
    pButton.param = param
    return pButton
end


function selected(button)
	
	
	local nSprite = button.param.nSprite
	nSprite:retain()
	local pSprite = button.param.pSprite
	pSprite:retain()
	
	--- 1. clear the state
	local tsn = DLSprite.createScale9Sprite("dz_trans.png", true)
	local tsp = DLSprite.createScale9Sprite("dz_trans.png", true)
	button:setBackgroundSpriteForState(tsn, cc.CONTROL_STATE_NORMAL)
    button:setBackgroundSpriteForState(tsp, cc.CONTROL_STATE_HIGH_LIGHTED)
	
	--- 2. set the right state
    button:setBackgroundSpriteForState(pSprite, cc.CONTROL_STATE_NORMAL)
    button:setBackgroundSpriteForState(nSprite, cc.CONTROL_STATE_HIGH_LIGHTED)
	
	nSprite:release()
	pSprite:release()	
end

function unselected(button)
	local nSprite = button.param.nSprite
	nSprite:retain()
	local pSprite = button.param.pSprite
	pSprite:retain()
	
	--- 1. clear the state
	local tsn = DLSprite.createScale9Sprite("dz_trans.png", true)
	local tsp = DLSprite.createScale9Sprite("dz_trans.png", true)
    button:setBackgroundSpriteForState(tsn, cc.CONTROL_STATE_NORMAL)
    button:setBackgroundSpriteForState(tsp, cc.CONTROL_STATE_HIGH_LIGHTED)
	
	--- 2. set the right state
	
    button:setBackgroundSpriteForState(nSprite, cc.CONTROL_STATE_NORMAL)
    button:setBackgroundSpriteForState(pSprite, cc.CONTROL_STATE_HIGH_LIGHTED)
	nSprite:release()
	pSprite:release()
end

function setSelected(button, flag)
	if flag then
		selected(button, flag)
	else
		unselected(button, flag)
	end
end
