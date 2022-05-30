-- Reserve.lua

local Pile = require 'pile'
local Util = require 'util'

local Reserve = {}
Reserve.__index = Reserve
setmetatable(Reserve, {__index = Pile})

function Reserve.new(o)
	o = Pile.new(o)
	o.category = 'Reserve'
	assert(o.fanType)
	o.moveType = 'MOVE_ONE'
	table.insert(_G.BAIZE.piles, o)
	table.insert(_G.BAIZE.reserves, o)
	return setmetatable(o, Reserve)
end

-- vtable functions

function Reserve:acceptCardError(c)
	return 'Cannot move a card to a Reserve'
end

function Reserve:acceptTailError(c)
	return 'Cannot move a card to a Reserve'
end

-- use Pile.tailTapped

-- use Pile.collect

function Reserve:unsortedPairs()
	-- they're all unsorted, even if they aren't
	if #self.cards == 0 then
		return 0
	end
	return #self.cards - 1
end

function Reserve:movableTails()
	-- same as Cell:movableTails
	local tails = {}
	if #self.cards > 0 then
		local tail = {self:peek()}
		assert(tail[1].prone==false)				-- top card should never be face down
		local homes = Util.findHomesForTail(tail)
		for _, home in ipairs(homes) do
			table.insert(tails, {tail=tail, dst=home.dst})
		end
	end
	return tails
end

return Reserve
