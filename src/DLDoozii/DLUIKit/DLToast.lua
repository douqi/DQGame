local MODULE_NAME = "DLToast"
module(MODULE_NAME, package.seeall)

---------- PRIVATE -------
local function TEST_CODE()
    local param = {bk_img="ds_icon_toast.png", text_color=DLConfig.DEFAULT_TITLE_COLOR, pos={x=160, y=50}}
    DLToast.show("Hello World")
end

---------- PUBLIC ------
function show(msg, delay, param)
    param = param or {}
    local node = DLScene.getRunningScene()
--    local node = cc.Node:create()
    
    local bg = param.bg
    local cached = true 
    if bg then
        cached = param.cached or false
    else
        bg = "dz_toast_bk.png"
        cached = true
    end
    
    local pos = param.pos or dz.xp(DLCommon.gameWidth()*0.5, DLCommon.gameHeight()*0.1)
    local size = param.size or cc.size(360,60) 
    local color = param.color or cc.c3b(240,190,80)
    
    local ds = DLSprite.createScale9Sprite(bg,cached)
    ds:setPreferredSize(size)
    ds:setPosition(pos)
  
    local label = cc.Label:createWithSystemFont("", "Helvetica", 28, cc.size(size.width, 0),cc.TEXT_ALIGNMENT_CENTER,cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
    label:setString(msg)
    label:setColor(color)
    label:setPosition(cc.p(size.width*0.5, size.height*0.5))
    ds:addChild(label, 10)
    
    ds:setCascadeOpacityEnabled(true)
    ds:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1, 1),  cc.FadeOut:create(delay+1), cc.RemoveSelf:create()))
  
    node:addChild(ds, 1000)  
end

