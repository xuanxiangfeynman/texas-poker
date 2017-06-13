 local Fighter = require("app.models.battle.Fighter")


local Game=class("Game")

function Game:ctor(battle)
	self.battle=battle
	self.playertbl=battle:get("playertbl")
	self.scene=battle:get("scene")
	self.me=battle:get("me")

	self.data={cards={}}
	self.poker={}

	self: init()
end

---------interface--------------------
function Game:get(k)
	if self[k] then
		return self[k]
	end
	return self.data[k]
end

function Game:loaddeskcard(data)
	table.insert(self.data.cards,data)
	return self.data.cards
end

function Game:loaddeskcards(data)
	local tbl={}
	for s,v in pairs(data or {}) do
		local i =tonumber(s)
		tbl[i]=v
	end
	self.data.cards=tbl 
	return table.len(tbl)
end
----implementation---------------------
-------------send card to desktop------------------------------
function Game:sendtodesktop(deskcards)
	local len=self:loaddeskcards(deskcards)
	for i=1,len do
		local poker=self:newdeskpoker(i)
		xxui.delay(poker,0.2*(i-1),
			function()
				self:movedeskcard(poker,i,150,280,"flip")			
			end)
	end
end

function Game:adddeskcard(deskcard)
	local  tbl =self:loaddeskcard(deskcard)
	local len=#tbl	
	local poker=self:newdeskpoker(len)
	self:movedeskcard(poker,len,150,280,"flip")
end
-------initial time=0.2;dx=100,dy=100--
-----mode:"flip" or other function
function Game:movedeskcard(poker,i,disx,disy,mode)
	local time =0.2
	local x,y=poker:getPosition()
			-- print("x=",x,"y=",y)
	local d=disx or 100
	local dx=(i-3)*d
	local dy=disy or 100 	
	poker:moveto(time,cc.p(x+dx,y-dy),
		function()
			self:showdeskpoker(poker, true, mode)
		end)			
end

function Game:newdeskpoker(i)
	local poker=mm.poker.new(self.scene)
	table.insert(self.poker,poker)
	self:loaddeskpoker(i)
	return poker
end


function Game:loaddeskpoker(i)
	local data=self:get("cards")
	i=i or #data
	local poker=self.poker[i]
	poker:load(data[i])
end

function Game:loaddeskpokers()
	for i,poker in pairs(self.poker) do
		self:loaddeskpoker(i)
	end
end

function Game:showdeskpoker(poker,bool,mode)	
	poker:scale(2)
	poker:show(true,mode)
	-- poker:skewTo(0, 5, 0)

end

---------------send card to player-------------------------------------
------mycard is the cardmsg of mine----------------
function Game:sendtoplayers(mycard) 
	print(mycard[2])
	self:polling(0.1,function(ft)
		if ft.state then
			ft:obtain(2)						
		end		
	end, function()	
		if mycard then
			local ft = self.playertbl[self.me]		
			ft:loadcards(mycard)			
			ft:showpoker(true,"flip")
			print("flip")
		end	
	end)
end


function Game:polling(time,func,oncomplete)
	local co
	co = coroutine.create(function()
		for i, ft in pairs(self.playertbl) do
			if func then func(ft) end
			ft:delay(time, function()
				coroutine.resume(co)
			end)
				coroutine.yield()
		end
		if oncomplete then oncomplete() end
	end)
		coroutine.resume(co)
end
---------------------------------------------------
function Game:deskwin(tbl)		
	for i=1,5 do
		if tbl[i] then
			local poker=self.poker[i]	
			poker:highlight()
		end
	end
	local ft = self.playertbl[self.me]
end
---------------------------------------------------
function Game:showdown(cardstbl)
	local tbl=self.playertbl
	for i, player in pairs(tbl) do
			if player.state and (i~=self.me) then
				player:loadcards(cardstbl[i])
				player:showpoker(true)
			end
	end
end


--------widgets----------------------------

----------init()--------------------------
function Game:init()
	self:gameplayer(self.playertbl)
-----------test----------------	
	-- self:createbuttons()
--------------------------------	
end
------------------------------------------
function Game:gameplayer(playertbl)
	local tbl=playertbl
	for i, player in pairs(tbl) do
		tbl[i]:playerstate()
	end
end

-----
function Game:result(rank,idx,cardtbl)
	self:dark(self.scene)
	self:createrank(rank)	
		
	local ft = self.playertbl[idx]
	ft:setopacity(1,true)
	ft:win("straight",1)
end

function Game:dark(node)
	if node == self.scene then
		local ch=node:getChildren()
		dump(ch)
		for _, child in pairs(ch) do
			child:setopacity(0.4,true)
		end
	else 
		node:setopacity(0.4,true)
	end
end

function Game:createrank(rank)
	
	local lback = self:rankimg(self.scene,"back", cc.p(0.55,0.47), cc.p(1,0.5))

	lback:setRotation(-3)
	local rback = self:rankimg(self.scene,"back", cc.p(0.5,0.47), cc.p(1,0.5))
	rback:setFlippedX(true)
	rback:setRotation(-3)
	local light = self:rankimg(self.scene,"light",cc.p(0.5,0.76))
	local rank = self:rankimg(light,rank,cc.p(0.5,0.5))
	local lflower = self:rankimg(rank,"flower", cc.p(-0.08,0.5))
	
	local rflower = self:rankimg(rank,"flower", cc.p(-0.08,0.5))
	rflower:setFlippedX(true)

end

function Game:rankimg(node,name,align,anch)
		local path = "obj/rank/rank_"..name..".png"
		local img = xxui.create{
			node = node, img = path,
			align = align,
			anch = anch or cc.p(0.5,0.5),
		}
		return img
end

---------------------------------
return Game