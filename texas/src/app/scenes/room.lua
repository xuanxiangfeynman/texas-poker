
require "app.xx.init"
require "app.models.init"

GM = require("app.control.GameManager").new()




local Battle=require"app.models.battle.Battle"

local room =class("room",function()
	return display.newScene("room")

end)


function room:ctor()
	-- self.data={}
	xx.delay(2,function()
		print("delay")
	end)
--------test data----------
----------------------------
	self:init()	

	self.battle=Battle.new(self)

end


function room:onEnter()
	self:loadtime()
	self.clock = xx.schedule(function()
		self:loadtime()
	end, 60)
end


function room:onExit()
	self.clock = xx.unschedule(self.clock)
end


--------interface-----


function room:get(k)
	if self[k] then
		return self[k]
	end
	return self.data[k]
end





    
-----implementation---
function room:loadtime()
	local w=self.panel:getleaf("time")
	w:load(os.date("%H:%M"))
end


---create widgets----	


function room:init()
	local panel = xxui.create{
		node = self, img = xxres.scene("room"), name = "background",
		anch = cc.p(0.5,0.5), align = cc.p(0.5,0.5), 
	}	

	self:setsize(panel)
	self:createinfo(panel)
	self:createbtns()
	self.panel=panel
end

function room:createinfo(panel)

	self:newtime(panel)
	self:newtxt(panel, "pot", cc.p(0.5,0.7))
	self:newtxt(panel,"whitehand",cc.p(0.4,0.44))
	self:newtxt(panel, "poker", cc.p(0.6,0.44))
end


function room:createbtns()
	self:newbtn("square")
	self:newbtn("addfriend")
	self:newbtn("adjust")
	self:newbtn("dialog")

end

function room:newbtn(name,func)
	local location = {
		square= cc.p(0.04,0.94),
		addfriend= cc.p(0.89,0.94),
		adjust= cc.p(0.96,0.94), 
		dialog= cc.p(0.04,0.08)
	}
	local btn=xxui.create{
		node=self,btn=xxres.button(name),
		anch=cc.p(0.5,0.5),align=location[name],
		func=func or function()end
	}	
	if name ~="square" then
		xxui.create{
			node=btn,img=xxres.button("circle"),
			anch=cc.p(0.5,0.5),align=cc.p(0.5,0.5)
		}
	end
	return btn
end

function room:newtxt(node,name,align)
	local color=cc.c3b(149,183,155)
	local txt=xx.translate{name,":"}
	xxui.create{
		node=node,txt=txt,size=33,color=color,
		font="txt",
		anch=cc.p(1,0.5),align=align,
	}
	xxui.create{
		node=node,txt="",name=name,size=33,color=color,
		font="txt",
		anch=cc.p(0,0.5),align=align,
	}

end

function room:newtime(panel)
	local color=cc.c3b(181,181,181)
	local time=xxui.create{
		node=panel,txt="",name="time",
		size=31,color=color,align=cc.p(0.08,0.92)
	}
end




-----test----------

return room
