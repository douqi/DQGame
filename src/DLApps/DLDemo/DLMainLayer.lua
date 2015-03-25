-- DLMainLayer

local M = class("DLMainLayer",
    function()
        return cc.Layer:create()
    end
)

DLMainLayer = M
M.__index = M


function M.scene()
    local scene = cc.Scene:create()
    local layer = M:create()
    scene:addChild(layer)
    return scene
end

---- init & uninit Only exist in DLMainLayer
function M.init()
    require("DLLang")
    DLResolution.init(640, 960)

end

--- FOR CALL IN DLHomeLayer, when change "DLApp"
function M.uninit()

end


function M:create()
    local node = M.new()
    node:initNode()
    
    --- list all the "Members"
    node.mTag = "DLMainLayer"

    -- load common resource sheet
    --- layoutUI
    node:layoutUI()

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

function M:onEnter()
    DDLOG(self.mTag .. " onEnter")

end


function M:onExit()
    DDLOG(self.mTag .. " onExit")

end

function M:onPause()

end

function M:onResume()

end

function M:layoutUI()
    DDLOG("DLMainLayer: layoutUI, tag = " .. self.mTag)
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
    DDLOG("DLMainLayer: tag = " .. self.mTag)
end


function M:addBgNode()
    -- use "relative coordinate" for node
    local node = self.mCoreNode
   
    local label = cc.Label:create()
    label:setString(DLLang.getString("GAME_NAME"))
    label:setSystemFontSize(48)
    label:setPosition(dz.p(0, 400))
    node:addChild(label)
    
   
end

function M:addMainNode()
    local node = self.mCoreNode
    
    local cb = DLCallback.create(self, self.buttonListener)
    local param  = {nImage="dz_trans.png", pImage="dz_trans.png", cached=true, listener=cb}
    
    --- 1. button move VERTICAL
    param.title = "VERTICAL"
    param.tag = param.title
    param.fScale = 0.7
    local button = DLButton.createWithBMFont(param)
    button:setPosition(dz.p(0, 150))
    button:setPreferredSize(cc.size(120, 80))
    node:addChild(button)
    
    --- 2. button move HORIZENTAL
    param.title = "HORIZENTAL"
    param.tag = param.title
    param.fScale = 0.7
    local button = DLButton.createWithBMFont(param)
    button:setPosition(dz.p(0, 0))
    button:setPreferredSize(cc.size(120, 80))
    node:addChild(button)
    
    --- 3. button move BOTH
    param.title = "BOTH"
    param.tag = param.title
    param.fScale = 0.7
    local button = DLButton.createWithBMFont(param)
    button:setPosition(dz.p(0, -150))
    button:setPreferredSize(cc.size(120, 80))
    node:addChild(button)
end

function M:addFooterNode()
    local node = self.mCoreNode
    
end

function M:buttonListener(tag, sender)
    DDLOG("in buttonListener ... " .. tostring(tag))
    local param = {mode = tag}
    require("DLPages/DLCPageBigMap")
    local scene = DLCPageBigMap.scene(param)
    DLScene.gotoScene(scene)
end

return DLMainLayer
