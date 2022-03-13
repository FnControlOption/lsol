-- iconwidget

local log = require 'log'

local Widget = require 'ui_widget'
local Util = require 'util'

local IconWidget = {
	-- icon name
	-- baizeCmd and optional param
}
IconWidget.__index = IconWidget
setmetatable(IconWidget, {__index = Widget})

function IconWidget.new(o)
	o.enabled = true

	local fname = 'assets/icons/' .. o.icon .. '.png'
	local imageData = love.image.newImageData(fname)
	if not imageData then
		log.error('could not load', fname)
	else
		o.img = love.graphics.newImage(imageData)
		assert(o.img)
		o.imgWidth = imageData:getWidth()
		o.imgHeight = imageData:getHeight()
		-- log.trace('loaded', fname, o.imgWidth, o.imgHeight)
	end
	return setmetatable(o, IconWidget)
end

function IconWidget:draw()
	-- very important!: reset color before drawing to canvas to have colors properly displayed
	local cx, cy, cw, ch = self.parent:screenRect()
	local wx, wy, ww, wh = self:screenRect()

	if wy < cy then
		return
	end
	if wy + wh > cy + ch then
		return
	end

	if self.enabled then
		local mx, my = love.mouse.getPosition()
		if self.baizeCmd and Util.inRect(mx, my, self:screenRect()) then
			love.graphics.setColor(1,1,1,1)
			if love.mouse.isDown(1) then
				wx = wx + 2
				wy = wy + 2
			end
		else
			love.graphics.setColor(1,1,1,1)
		end
	else
		love.graphics.setColor(0.5,0.5,0.5,1)
	end
	if self.img then
		love.graphics.draw(self.img, wx, wy)
	end

	if self.text then
		love.graphics.setFont(self.parent.font)
		love.graphics.print(self.text, wx + 36 + 4, wy + 2)
	end

	if _G.BAIZE.settings.debug then
		love.graphics.rectangle('line', wx, wy, ww, wh)
	end

end

return IconWidget
