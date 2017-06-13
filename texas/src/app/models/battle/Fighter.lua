
local Fighter=class("Fighter", function()
		 return xxui.Widget.new()

	end)

local ALIGN={
	cc.p(0.56, 0.42), cc.p(0.3, 0.42),

	cc.p(0.14, 0.58), cc.p(0.8,1),
	cc.p(0.98,0.58), cc.p(0.83, 0.42)
}


function Fighter:ctor(battle,idx,state)
	self.battle = battle
	self.scene = battle:get("scene")
	self.idx = idx
	self.state = state
	self.data = {cards = {}}
	self.account = {money = 16000, mybet = 970, raise = 0, blinds = "big"}
	self.pot = {total = 1600, maxbet = 1000, minraise = 0}
---------test data----------------
	self.poker={}
--------------------------------
	self:init()
end
----interface-----
function Fighter:get(k)
	if self[k] then
		return self[k]
	end
	return self.data[k]
end

function Fighter:is(k)
	local i = self.battle:get(k)
	return self.idx == i
end

-------load poker data-----
function Fighter:loadcard(data)
	table.insert(self.data.cards,data)
end

function Fighter:loadcards(data)
	local tbl={}
	for s,v in pairs(data or {}) do
		local i =tonumber(s)
		tbl[i]=v
	end
	self.data.cards=tbl 
	return table.len(tbl)
end

function Fighter:myround()
	self:timecount(10)
	if self:is("me") then 
		xxui.delay(w, time, func)
	else 
		xxui.delay(w, time, func)
	end	
end

----implemenation------------------

-----------------------------------------
function Fighter:fold(fighter)
	local x=display.cx
	local y=display.cy
	for i, poker in pairs(self.poker) do
		local xo,yo=poker:getPosition()	
		poker:moveto(0.1,cc.p(x,y),function()
			poker:setVisible(false)			
			poker:setpos{pos = cc.p(xo,yo)}				
			-- if fighter:is("me") then
			-- 	poker:delay(0.5,function()	
			-- 		poker:setVisible(true)
			-- 	end)
			-- end						
		end)
	end		
	self.state=false
	self:playerstate()
	self:removebtns()
	self:headinfo("fold")
end


function Fighter:call(text,num)
	if text == xx.translate{"all in"} then	 
		self.account.mybet = self.account.money
		self.account.money = 0
		self:headinfo("all in")
	elseif text == xx.translate{"check"} then
		print("check")
		self:headinfo("check")
	else
		self.account.money = self.account.money - num
		self.account.mybet = self.pot.maxbet
		self:headinfo("call")
	end
		self:removebtns()
end

function Fighter:raise()
	if self.account.raise == 0 then 
		 slider = self:slidercreate(self.scene,
			self.pot.maxbet,self.account.money,
			self.pot.maxbet+self.pot.minraise)	
		local potbtn = self:potbtncreate(slider)
	else
		if self.account.raise == self.account.money then
			self.account.mybet = self.account.money
			self.pot.maxbet = self.account.mybet   ----different with the callbtn all in-----
			self.account.money = 0
			self:headinfo("all in")
		else
			self.pot.maxbet = self.account.raise
			self.account.mybet = self.account.raise
			self.account.money = self.account.money -self.account.raise
			self.account.raise = 0
			
			print("test",self.account.raise)
			self:headinfo("raise")
		end
		self:removebtns()
	end
end
----show the playerstate------------
function Fighter:playerstate()
  	if not self.state then
  		self:setopacity(0.2,true)
 	end
end

-----------create a newpokers widgets----
------i: the card data in self.poker[i]---------
function Fighter:newpoker(i)
	local poker=mm.poker.new(self.scene)
	table.insert(self.poker,poker)
	self:loadpoker(i)
	return poker
end

function Fighter:loadpoker(i)
	local data=self:get("cards")
	i=i or #data
	local poker=self.poker[i]
	poker:load(data[i])
end

function Fighter:loadpokers()
	for i,poker in pairs(self.poker) do
		self:loadpoker(i)
	end
end

function Fighter:showpoker(bool)
	self:loadpokers()
	for i, poker in pairs(self.poker) do
		xxui.delay(poker,0.2*(i-1),
			function()
				poker:show(bool,"flip")
			end)
	end
end

function Fighter:obtain(num)
	local co 
	co = coroutine.create(function()
		for i = 1, num do
			local poker = self:newpoker(i)
			poker:move(self, i, function()
				if not self:is("me") then
					local angl=30*(i-1.5)
					poker:setRotation(angl)
				end
			end)
			self:delay(0.6,function()
				coroutine.resume(co)
			end)
			coroutine.yield()
		end		
	end)
	coroutine.resume(co)
end

function Fighter:cardpos(cover)	
	local x, y = self:getPosition()
	local i = self:seatnum()
	if  i == 1 then
		x = x+335
		y = y-160	
	elseif i == 5 then
		x = x-160
		y = y-200
	else
		x = x+25
		y = y-200		
	end
	return cc.p(x, y)
end

function Fighter:seatnum()
	local me = self.battle:get("me")
	local i =self.idx - me
	i = i >= 0 and i or i+6
	return i+1
end


function Fighter:getalign()
	local i = self:seatnum()
	return ALIGN[i]
end

-------create widgets-----
function Fighter:init()	
	self:createplayer()	
	if self:is("me") then
		self:buttons()
		-- self:timecount(10)
	end		
	self :createchip(self.account.mybet)
	self:blinds()
end

function Fighter:createplayer()
	local panel =xxui.create{
			node=self, img=xxres.panel("head_back"),
			name="head_back",
			anch=cc.p(0.5,0.5),align=cc.p(0.5,0.5)
		}
	
	self:createinfo(panel)
	self:setsize(panel)
	self:set{
			node=self.scene, anch=cc.p(0.5,0.5),
			align=self:getalign()
		}
end


function Fighter:createinfo(panel)
	local i = self:seatnum()
	local me=self.battle:get("me")
	local text="任盈盈"..i.."号"
	xxui.create{
		node = panel, txt = text, name = "name",
		size = 37, color = cc.c3b(242,242,242),
		anch = cc.p(0.5,0.5), align = cc.p(0.5,0.86),		
	}
	xxui.create{
		node = panel, img = xxres.panel("head"), name="head",
		anch = cc.p(0.5,0.5), align = cc.p(0.5,0.5)
	}
	xxui.create{
		node = panel, img =xxres.panel("head_frame"),
		anch = cc.p(0.5,0.5), align = cc.p(0.5,0.5),
	}
	xxui.create{
		node = panel, txt= self.account.money, name = "score",
		size =37, color = cc.c3b(252,222,143),
		anch=cc.p(0.5,0.5),align=cc.p(0.5,0.14),
	}
end



--------------my buttons----------------------
function Fighter:buttons()
	local text = xx.translate{"fold"}
	local num = 0
	local foldbtn = self:newtxtbtn{
			node = self.scene, mode = "red",
			btnalign = cc.p(0.5,0.08), name = "foldbtn",
			text = text,
			zorder = 2,
			func = function()
				self:fold()
			end
		}
	if self.account.mybet < self.pot.maxbet then		
		if self.account.money <= self.pot.maxbet then
			text = xx.translate{"all in"}
			num = self.account.money
		else 
			num = self.pot.maxbet - self.account.mybet
			text = xx.translate{"call"}..num 
		end
	else
		text = xx.translate{"check"}
	end
	local callbtn = self:newtxtbtn{
			node = self.scene, mode = "green",
			btnalign = cc.p(0.7,0.08), name = "callbtn",
			text = text,
			zorder = 2,
			func = function()
				print(text)
				self:call(text,num)
			end
		}
	if text ~= xx.translate{"all in"} then
		local txt = xx.translate{"raise"}
		local 	raisebtn = self:newtxtbtn{
					node = self.scene, mode = "orange",
					btnalign = cc.p(0.9,0.08), name = "raisebtn",
					text = txt, 
					zorder =2,
					func = function()	
						print(txt)					
						self:raise()
					end
				}
	end
end

function Fighter:removebtns()
	local btns = {"callbtn","raisebtn","foldbtn","slider"}
	for i = 1, 4 do
		if self.scene:getchild(btns[i]) then
			local w = self.scene:getchild(btns[i])
			w:removeSelf()
		end
	end	
end
--[[
param={ node, mode,(btnalign, text, func,txtalign ....)}
--]]
----mode:color of the btn red, green or orange 
function Fighter:newtxtbtn(param)
	local args = clone(param)	
	local btn = xxui.create{
		node =args.node, btn = xxres.button(args.mode), name = args.name,
		anch = cc.p(0.5,0.5), align = args.btnalign or cc.p(0.5,0.5), 
		zorder= args.zorder,
		func = args.func or function() end
	}
	local txt = xxui.create{
		node = btn, txt = args.text, name ="btntxt",
		anch = cc.p(0.5,0.5), align = args.txtalign or cc.p(0.5,0.5),
		size = args.txtsize, color = args.txtcolor,
		font = args.font or "dft",
	}
	return btn
end

function Fighter:potbtncreate(node)
	local btnback = xxui.create{
			node = node, img = xxres.icon("pot_double"),
			anch = cc.p(1,0.5), align =cc.p(0.1,0.36),
			zorder=-2
		}
	for i = 1, 3 do 
		self:newtxtbtn{
			node = btnback, mode = "pot_black",
			btnalign = cc.p(0.27*i-0.1,0.5),
			text = i.."/"..i+1,
			txtsize = 35, txtcolor = cc.c3b(241,243,240),
			txtalign = cc.p(0.5,0.7),
			font = "dft",
			func = function()				
				self.account.raise = math.floor(self.pot.total *i/(i+1))
				self:raise()
			end
		}		
	end
	btnback:rotation(90)
	return btnback 
end

function Fighter:slidercreate(node,minallow,maxallow,startvalue)
	local min = (9*minallow - maxallow)/8
	local max = (9*maxallow - minallow)/8
------adjust the position of the slider button-------
-------------------------------------------------
	local w = mm.slider.new {
			node = node, img = self:sliderimg(), name = "slider",
			anch = cc.p(0, 0.5), align = cc.p(0.9, 0.1),
			min = min, max = max,
			zorder = 0,
			minallow = minallow, maxallow = maxallow,
			startvalue = startvalue or minallow
		}
 	w:rotation(-90)
 	
 	local align = self:sliderinfopos(w)
 	local text = math.ceil(w:getval())
 	local info = self:sliderinfo(w,align,text)
 	local btn = self.scene:getchild("raisebtn")
 	local txt = btn:getchild("btntxt")
 		 txt:load(xx.translate{"raise"}..text)
 		 self.account.raise = text

 	w:onchange(function()
 		local align = self:sliderinfopos(w)
 		local text = math.ceil(w:getval())		
 		info:set{align = align}	
 		txt = info:getchild("infotxt")
 		txt:load(text)	
 		
 		if text >= maxallow then
 			self.account.raise = maxallow
 			text = xx.translate{"all in"}
 		else
 			self.account.raise = text
 			text =xx.translate{"raise"}..text
 		end
 		local btn = self.scene:getleaf("raisebtn")
 		txt = btn:getchild("btntxt")
 		txt:load(text)	 		
 		print("raise", self.account.raise)
		end)
 	return w
end

function Fighter:sliderimg()
	local img = {
		xxres.grid("slider_back"),
		xxres.grid("slider_process"),
		xxres.grid("slider_button")
	} 
	return img
end
---w is the slider-----------------
function Fighter:sliderinfo(w,align,text)
	local info = xxui.create{
		node = w,img = xxres.grid("slider_info"),
		anch = cc.p(0.8,0.5), align = align,
		zorder = 5
 	}
 	local infotxt = xxui.create{
 		node = info, txt = text, name = "infotxt",
 		pos = "center",
 		size = 62, color = cc.c3b(80,80,80)
 	}
 	infotxt:rotation(90)
 	return info
end

function Fighter:sliderinfopos(w)
	local v = w:getval()
	local min = w:getmin()
	local max = w:getmax()
	local y = 1.6
	local x = (v - min)/(max-min)+0.05
	return cc.p(x,y)
end

function Fighter:headinfo(name)
	local panel = self:getchild("head_back")
	xxui.create{
		node = panel, img = xxres.panel(name), 
		anch = cc.p(0.5,0.5), align = cc.p(0.5,0.86),
		zorder = 2,
	}
	local name = panel:getchild("name")
	name:setVisible(false)

end

-----color = "blue", "orange", "red", "green", "purple"
function Fighter:createchip(num,color)
	local color = color or "red"
	local posit = {
	cc.p(-0.4,0.86), cc.p(0.55,1.04),
	cc.p(1.45,0.86), cc.p(-0.02,-0.02),
	cc.p(-0.45,0.8), cc.p(0.4,1.03),
	}
	local panel = self:getchild("head_back")
	local i = self:seatnum()
	local back = xxui.create{
		node = panel, img = xxres.icon("chip_back"),
		anch = cc.p(0.5,0.5), align = posit[i],
		name = "chip",
	}
	local dir
	if i == 2 or i == 3 then  
		dir = cc.p(0.1,0.5)
	else
		dir = cc.p(0.9,0.5)
	end 
	local coin = xxui.create{
		node = back, img = xxres.icon("chip_"..color),
		anch = cc.p(0.5,0.5), align = dir,
	}
	local txt = xxui.create{
		node = back, txt = num, name = "chipnum",
		anch = cc.p(0.5,0.5), align = cc.p(0.5,0.5),
		size = 37, color = cc.c3b(252,222,143),
	}
end

function Fighter:timecount(time)
	local panel = self:getchild("head_back")
	local timer =xxui.ProgressTimer.new{
		node = panel, kind = "ring",
		content = xxres.grid("countdown"),
		dir = "anticlockwise", pos = "center"
	}
	timer:setVisible(true)
	timer:progressFromTo(time,100,0)
end

function Fighter:blinds()
	local panel = self:getchild("head_back")
	if self.account.blinds == "big" then 
		local icon = xxui.create{
			node = panel, img = xxres.panel("blinds"),
			name = "blinds", 
			anch = cc.p(0.5,0.5), align = cc.p(-0.05,0.25),
		}
	end
end

function Fighter:win(type,i)	
	local frame = xxui.create{
		node = self:getchild("head_back"), img = xxres.panel("head_victory"),
		anch = cc.p(0.5,0.5), align = cc.p(0.5,0.5),
	}
	self:headinfo(type)
	self:pokerhl(i)
	self:winscore()
end
-- :getchild("head_back")
function Fighter:winscore()
	local score = xxui.create{
		node = self, txt = "+1200", 
		name = "score", zorder = 2,
		anch = cc.p(0.5,0.5), align = cc.p(0,0), 
		size = 75, color = cc.c3b(250, 247, 2),
	}
	score:setOpacity(0)
	score:moveby(0.5,cc.p(0,100),function()
		-- score:fadeout(0.5,true)
		end)	
	score:fadein(0.1,false)
end

function Fighter:pokerhl(i)
	if i == 3 then 
		for j = 1, 2 do 
			local poker = self.poker[j]
			poker:highlight()
		end
	end
	if i  then 
		local poker = self.poker[i]
		poker:highlight()
	end	
end
-------------------------------------------------

return Fighter

