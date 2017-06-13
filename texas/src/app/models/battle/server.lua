

local server=class("server")

function server:ctor()
	self.data={}
	self.playertbl={}

	self:init()	
end

function server:init()
	self:playerinital()
	
end

function server:playerinital()
	local maxplayernum=6
	local tbl=self.playertbl
	for i=1, maxplayernum do
		tbl[i]=false
	end
end	

function server:playerset()
	local tbl={}
		tbl[1]=true
		tbl[2]=true
		tbl[4]=true
		tbl[3]=true
		tbl[5]=true
		tbl[6]=true
	return tbl

end

function server:dealercard()
	local card={}
	local cls={"club","diamond","heart","spade"}
	card.cls=cls[math.random(4)]
	card.idx=math.random(13)
	return card
end	

function server:dealercards(num)
	local cards={}	
	for i=1,num do
	cards[i]=self:dealercard()
	end
	return cards
end

function server:playercards(num)
	local cardtbl={}
	for i, state in pairs(tbl) do
			if state then
				math.randomseed(os.time()+1)
				cardtbl[1]=self:dealercards(num)
			end
		end
	return cardtbl

end

function server:deskcards(num)
	math.randomseed(os.time())
	local deskcards=self:dealercards(num)
	return deskcards
end
		
function server:deskcard()
	local card=self:dealercard()
	return card
end

return server