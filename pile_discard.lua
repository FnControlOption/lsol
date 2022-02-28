-- class Discard, derived from Pile

local Pile = require 'pile'

local Discard = {}
Discard.__index = Discard
setmetatable(Discard, {__index = Pile})

function Discard.new(o)
	o.category = 'Discard'
	o.fanType = 'FAN_NONE'
	o.moveType = 'MOVE_NONE'
	o = Pile.new(o)
	table.insert(_G.BAIZE.piles, o)
	table.insert(_G.BAIZE.discards, o)
	return setmetatable(o, Discard)
end

function Discard:push(c)
	Pile.push(self, c)
	-- Discard cards are always prone
	c:flipDown()
end

function Discard:canAcceptCard(c)
	return 'Cannot move a single card to a Discard'
end

function Discard:canAcceptTail(tail)
	if #self.cards ~= 0 then
		return 'Can only move cards to an empty Discard'
	end
	for _, c in ipairs(tail) do
		if c.prone then
			return 'Cannot move a face down card to a Discard'
		end
	end
	if #tail ~= #_G.BAIZE.deck / #_G.BAIZE.discards then
		return 'Can only move a full set of cards to a Discard'
	end
	return _G.BAIZE.script:tailMoveError(tail)	-- check cards are conformant
end

function Discard:tailTapped(tail)
	-- do nothing
end

function Discard:collect()
	-- override Pile.collect to do nothing
end

function Discard:conformant()
	-- no Baize that contains any discard piles should be Conformant,
	-- because there is no use showing the collect all FAB
	-- because that would do nothing
	-- because cards are not collected to discard piles
	return false
end

function Discard:complete()
	if #self.cards == 0 then
		return true
	end
	if #self.cards == #_G.BAIZE.deck / #_G.BAIZE.discards then
		return true
	end
	return false
end

function Discard:unsortedPairs()
	-- you can only put a sorted sequence into a Discard, so this will always be zero
	return 0
end

function Discard:draw()
	local b = _G.BAIZE
	local x, y = self:screenPos()

	love.graphics.setColor(1, 1, 1, 0.1)
	love.graphics.setLineWidth(1)
	love.graphics.rectangle('fill', x, y, b.cardWidth, b.cardHeight, b.cardRadius, b.cardRadius)
end

return Discard
