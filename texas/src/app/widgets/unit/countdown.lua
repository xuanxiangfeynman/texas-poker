-- mm.countdown --
module(..., package.seeall)

countdown = class("countdown", function()
	return xxui.Widget.new()
end)

function countdown:ctor(stage)
	self:init(stage)
end

-- interface --
function countdown:count(time, func)
	self:setVisible(true)
	self.timer:progressFromTo(time, 100, 0)
	self:shownum(time, function()
		if func then func() end
		self:setVisible(false)
	end)
end

-- implementation --
function countdown:shownum(time, func)
	local w = xxui.create {
		node = self, txt = "", size = 100,
		color = cc.c3b(186, 210, 210), pos = "center"
	}
	local i = time
	xxui.schedule(self, 1, time, function()
		w:load(i)
		i = i - 1
	end, function()
		w:removeSelf()
		func()
	end)
end

-- create widgets --
function countdown:init(stage)
	local panel = xxui.create {
		node = self, img = xxres.grid("countdown")
	}
	self:setsize(panel)
	self:set {node = stage, pos = "center"}
	self.timer = xxui.ProgressTimer.new {
        node = panel, kind = "ring",
        content = xxres.grid("timer"),
        dir = "anticlockwise", pos = "center"
    }
end