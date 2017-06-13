module(..., package.seeall)

sharing = class("sharing", mm.window)

function sharing:ctor(stage)
	sharing.super.ctor(self, stage, 2, true)
	self:init()
	self:setTitle("sharing")
end

-- implementation --
function sharing:event(name)
	print("control ", name)
end 

-- create widgets --
function sharing:init()
	for i, name in pairs {"wechat", "friends"} do
		self:createboard(i, name)
	end
end