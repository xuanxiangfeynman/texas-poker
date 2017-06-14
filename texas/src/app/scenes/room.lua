
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
	self:square()
	self:addfriend()
	self:adjust()
	self:dialog()
end

function room:square()
	self:newbtn(self, "square", cc.p(0.04,0.94), _,function() 
		local bg = mm.window.new(self, 2.5, true)
		bg:setpos{align = cc.p(0,1), anch = cc.p(0,1),}
		local bt ={"return", "change", "standup", "cardkind"}
		for i, name in pairs(bt) do
			self:newimg(bg, name, cc.p(0.5,1.13-0.22*i), cc.p(0,1))
			self:newbtn(bg, name.."btn", cc.p(0.5,1.13-0.22*i), cc.p(1,1))		
		end
	end)
end

function room:addfriend()
	local img = self:newimg(self, "circle", cc.p(0.89,0.94))
	self:newbtn(img, "addfriend")
end

function room:adjust()
	local img = self:newimg(self, "circle", cc.p(0.96,0.94))
	self:newbtn(img, "addfriend")
end

function room:dialog()
	local img = self:newimg(self, "circle", cc.p(0.04,0.08))
	self:newbtn(img, "addfriend")
end

function room:newbtn(node, name, align, anch, func)
	local btn=xxui.create{
		node=node, btn=xxres.button(name), name = name,
		anch=anch or cc.p(0.5,0.5), align=align or cc.p(0.5,0.5),
		func=func or function()end
	}		
	return btn
end

function room:newtxt(node, name, align)
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

function room:newimg(node,name,align,anch,path)
	local path = path or"button"
	path = "ui/"..path.."/"..name..".png"
	local img = xxui.create{
		node = node, img = path,
		anch = anch or cc.p(0.5,0.5), align = align or cc.p(0.5,0.5),
	}
	return img
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
