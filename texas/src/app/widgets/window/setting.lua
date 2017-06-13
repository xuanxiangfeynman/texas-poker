module(..., package.seeall)

setting = class("setting", mm.window)

function setting:ctor(stage)
	setting.super.ctor(self, stage, 2, true)
	self:init()
	self:setTitle("setting")
end

-- implementation --
function setting:event(name)
	print("control ", name)
end 


-- create widgets --
function setting:init()
	self:createbtn()
	for i, name in pairs {"music", "sound"} do
		self:createboard(i, name)
	end
end

function setting:createbtn()
	local btn = self:setBtn("logout")
	btn["logout"]:setTouchEvent(function()
		print("function: logout()")
	end)
end