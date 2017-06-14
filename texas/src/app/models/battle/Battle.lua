
local Fighter = require("app.models.battle.Fighter")
local Game = require("app.models.battle.Game")

local server=require("app.models.battle.server")

local Battle =class("Battle")

function Battle:ctor(scene)
	self.scene = scene
	self.playertbl= {}
-----------test-------------------------	
	self.me=1
---------------------------------------------------
	self:init()
end
----interface--------------------

function Battle:get(k)
	if self[k] then
		return self[k]
	end
	return self.data[k]
end

function Battle:receive(msg)

end

------set maximum palyer--------------------
function Battle:maxpalyernum()
	return 6
end


----create widgets--
-----------init----------------------------
function Battle:init()
	local server = server.new()
		tbl = server:playerset()
	self:setplayerstate(tbl)
	local newgame = Game.new(self)
	self:gameprocess(newgame)
			
--------------test-------------------

-- ------------------------------------------
end
----------------------------------------------------------------------

function Battle:createplayer(idx)
	local new = Fighter.new(self,idx,false)
	table.insert(self.playertbl,idx,new)
end

function Battle:setplayerstate(tbl)
	for i,state in pairs(tbl) do
		self:createplayer(i)
		self.playertbl[i].state=state
	end

end

------test-----------------------
function Battle:gameprocess(game)
	local cardtbl = server:dealercards(2)
		self:perflop(game, cardtbl)
		
	local deskcards = server:dealercards(3)
		self:flop(game,deskcards)
	local deskcard1 = server:dealercard()
		self:turn(game,deskcard1)

	local deskcard1 = server:dealercard()
		self:river(game, deskcard1)
		cardtbl = server:playercards(2)
		self:showdown(game,cardtbl)
		local pokertbl = {}
			pokertbl[1] = true
			pokertbl[2] = true
			pokertbl[3] = true
			pokertbl[5] = true

		self:deskwin(game,pokertbl)
		xx.delay(7, function()
		game:result("flush",2)
		end)
end	


function Battle:perflop(game,cardtbl)
	game:sendtoplayers(cardtbl)
end

function Battle:flop(game,deskcards )
	xxui.delay(self.scene,2,function()
		game:sendtodesktop(deskcards)
	end)
end

function Battle:turn(game,deskcard1)
	xxui.delay(self.scene,4,function()				
		game:adddeskcard(deskcard1)			
	end)
end

function Battle:river(game,deskcard1)
	xxui.delay(self.scene,6,function()				
		game:adddeskcard(deskcard1)
	end)
end


function Battle:showdown(game,tbl)
	xxui.delay(self.scene,8,function()
		game:showdown(tbl)
	end)
end

function Battle:deskwin(game,tbl)
	xxui.delay(self.scene,10,function()
		game:deskwin(tbl)
	end)
end

----------------------------
return Battle