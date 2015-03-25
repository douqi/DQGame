-- DLCPageBigMap

local M = class("DLCPageBigMap",
    function()
        return cc.Layer:create()
    end
)

DLCPageBigMap = M
M.__index = M


function M.scene(param)
    local scene = cc.Scene:create()
    local layer = M:create(param)
    scene:addChild(layer)
    return scene
end

function M:create(param)
    local node = M.new()
    node:initNode()
    --- list all the "Members"
    node.mTag = "DLCPageBigMap"
    
    node.mLabel    = nil
    node.mSprite   = {}
    node.mParam = param
    node.mCenter    = {}

    --- layoutUI
    node:layoutUI()
    
    node:enableTouch()
    return node
end

function M:initNode()
    local function tListener(tag)
        DDLOG("tListener status = " .. tag)
        if tag == "enter" then
            if self.onEnter ~= nil then
                self:onEnter()
            end
        elseif tag == "exit" then
            if self.onExit ~= nil then
                self:onExit()
            end
        end
    end
    self:registerScriptHandler(tListener)
end

function M:enableTouch()
    local function onTouch(event, x, y)
        if event == "began" then
            return self:onTouchBegan(event, x, y)
        elseif event == "moved" then
            return self:onTouchMoved(event, x, y)
        elseif event == "ended" then
            return self:onTouchEnded(event, x, y)
        end
    end

    self:setTouchEnabled(true)
    self:registerScriptTouchHandler(onTouch)
end

function M:onEnter()
    DDLOG("DLCPageBigMap: onEnter".. self.mTag)

end


function M:onExit()
    DDLOG("DLCPageBigMap: onExit".. self.mTag)

end

function M:onPause()

end

function M:onResume()

end

function M:layoutUI()
    DDLOG("DLCPageBigMap: layoutUI, tag = " .. self.mTag)
    local node = cc.Node:create()
    node:setPosition(dz.xp(320, 480))
    self:addChild(node)
    self.mCoreNode = node

    --- 1. add bg + title
    self:addBgNode()

    --- 2. add main buttons
    self:addMainNode()

    ---- 3. add other buttons
    self:addFooterNode()

end


function M:sayHi()
    DDLOG("DLCPageBigMap: tag = " .. self.mTag)
end


function M:addBgNode()
    -- use "relative coordinate" for node
    local node = self.mCoreNode
    
    --- add back button
    local cb = DLCallback.create(self, self.buttonListener)
    local param  = {nImage="dz_btn_back_n.png", pImage="dz_btn_back_s.png", cached=true, listener=cb}
    param.tag = 0
    local button = DLButton.create(param)
    button:setPosition(dz.xp(80, 900))
    self:addChild(button)
   
end

function M:addMainNode()
    local node = self.mCoreNode

    --- add Sprites
    self.mSprite.xy = {}
    
    self.mSprite.node = cc.Node:create()
    node:addChild(self.mSprite.node)

    local ds = DLSprite.create("gi_demo_ads.jpg", false)
    ds:setScale(DLResolution.SCALE_MAX)
    self.mSprite.node:addChild(ds)

    self.mSprite.xy["0-0"] = ds
    
    --- add label
    local label = cc.LabelBMFont:create("(0,0)", "dzfont.fnt")
    node:addChild(label)
    self.mLabel = label
end

function M:addFooterNode()
    local node = self.mCoreNode
    
end



function M:onTouchBegan(event, px, py)
    self.mCenter = {x = px, y = py}
    return true
end

function M:onTouchMoved(event, px, py)
    local label = self.mLabel
    label:setString(string.format("(%d, %d)", px, py))
    
    self:resetCenter(px, py)
    return
end


function M:onTouchEnded(event, px, py)
    
    return
end

function M:optimize(px, py)
    local node = self.mSprite.node
    local nc = {x = px, y = py}
    local sprites = self.mSprite
    
    local dx = nc.x - self.mCenter.x
    local dy = nc.y - self.mCenter.y

    local x1 = node:getPositionX()
    local x2 = x1 + dx

    local y1 = node:getPositionY()
    local y2 = y1 + dy

    ---- try load and release sprites
    do 
        local width 
        local height
        if dz.dpx(1) > dz.dpy(1) then
            width = dz.dpx(640)
            height = dz.dpx(960)
        else
            width = dz.dpy(640)
            height = dz.dpy(960)
        end
        
        local pix1 = math.floor((x2 + width) / width)
        local pix2 = pix1 - 1
        
        local piy1 = math.floor((y2 + height) / height)
        local piy2 = piy1 - 1

        local arrLoad = {cc.p(pix1,piy1),cc.p(pix1,piy2),cc.p(pix2,piy1),cc.p(pix2,piy2),}

        for i=1, #(arrLoad) do
            local pi = arrLoad[i]
            if sprites.xy[string.format("%d-%d", pi.x, pi.y)] == nil then
                local ds = DLSprite.create("gi_demo_ads.jpg", false)
                ds:setScale(DLResolution.SCALE_MAX)
                ds:setPosition(dz.p(0-width*pi.x, 0-height*pi.y))
                node:addChild(ds)
                sprites.xy[string.format("%d-%d", pi.x, pi.y)] = ds
            end 
        end

        local arrUnload = {}
        if dx > 0 and dy > 0 then
            arrUnload = {cc.p(pix2-1, piy2-1), cc.p(pix2, piy2-1), cc.p(pix2-1, piy2)}
        elseif dx > 0 and dy < 0 then
            arrUnload = {cc.p(pix2-1, piy1+1), cc.p(pix2, piy1+1), cc.p(pix2-1, piy1)}
        elseif dx < 0 and dy > 0 then
            arrUnload = {cc.p(pix1+1, piy2-1), cc.p(pix1, piy2-1), cc.p(pix1+1, piy2)}
        elseif dx < 0 and dy < 0 then 
            arrUnload = {cc.p(pix1+1, piy1+1), cc.p(pix1, piy1+1), cc.p(pix1+1, piy1)}   
        end
        
        for i=1, #(arrUnload) do
            local pi = arrUnload[i]
            if sprites.xy[string.format("%d-%d", pi.x, pi.y)] ~= nil then
                local ds = sprites.xy[string.format("%d-%d", pi.x, pi.y)]
                ds:removeFromParent(true)
                sprites.xy[string.format("%d-%d", pi.x, pi.y)] = nil
            end 
        end
    end
    ----
    node:setPosition(dz.p(x2, y2))
    self.mCenter = nc
end


function M:resetCenter(px,py)
    local node = self.mSprite.node
    local nc = {x = px, y = py}
    
    local mode = self.mParam.mode
    local sprites = self.mSprite
    if mode == "VERTICAL" then
        self:optimize(self.mCenter.x, py)
    elseif mode == "HORIZENTAL" then
        self:optimize(px, self.mCenter.y)
    elseif mode == "BOTH" then
        self:optimize(px, py)
    end
end


function M:buttonListener(tag, sender)
    DDLOG("in buttonListener ... " .. tostring(tag))
    
    local scene = DLMainLayer.scene()
    DLScene.gotoScene(scene)
end

return DLCPageBigMap
