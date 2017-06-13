-- mm.countdown --
module(..., package.seeall)

---xxui.slider----
slider = class("slider", function()
	return xxui.Widget.new()
end)

--[[
param = {
	node, img = {"back", "process", "button"},
	(maxval,minval,maxallow,minallow,startvalue)
}
--]]
function slider:ctor(param)
	local args = clone(param)
	self.core = cc.ControlSlider:create(unpack(args.img))
	self.core:addTo(self)
	local sz = self.core:getContentSize()
	self:setsize(sz)
	local anch = self.core:setAnchorPoint(cc.p(0, 0))
	args.img = nil
	self:set(args)
 	self:reset(args)
end

-- interface --
function slider:getval()
	return self.core:getValue()
end

function slider:setval(num)
	self.core:setValue(num)
end

function slider:reset(args)
	self:setmin(args.min or 0)
	self:setmax(args.max or 100)
	--设置允许滑动的最小（大）值
	self:setminallow(args.minallow or self:getmin())
	self:setmaxallow(args.maxallow  or self:getmax())
	local z = args.startvalue or self:getmin() 
	self:setval(z)
end

function slider:onchange(func)
	func = func or function() end
	self.core:registerControlEventHandler(func, cc.CONTROL_EVENTTYPE_VALUE_CHANGED)
end

function slider:setmin(num)
	self.core:setMinimumValue(num)
end
function slider:getmin()
	return self.core:getMinimumValue()
end

function slider:setmax(num)
	self.core:setMaximumValue(num)
end

function slider:getmax()
	return self.core:getMaximumValue()
end

--设置允许滑动的最小（大）值
function slider:setminallow(num)
	 self.core:setMinimumAllowedValue(num)
end

function slider:getminallow()
	return self.core:getMinimumAllowedValue()
end

function slider:setmaxallow(num)
	self.core:setMaximumAllowedValue(num)
end

function slider:getmaxallow()
	return self.core:getMaximumAllowedValue()
end
