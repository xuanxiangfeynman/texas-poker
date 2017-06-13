
require "app.xx.init"
require "app.models.init"

GM = require("app.control.GameManager").new()

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    self:init()
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

--------------implementation-------------------------------




-----------create widgets-------------------------------

function MainScene:init()

xxui.create{
	node=self,img=xxres.scene("login")
}

mm.button.new{
	node=self, btn="login",name="login",
	anch=cc.p(0.5,0.5),align=cc.p(0.5,0.2),
	func=function() 
		GM:pushscene("room")
	end
}

end


return MainScene
