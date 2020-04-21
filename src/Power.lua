Power = Class{}

function Power:init(params)
	self.x = params.x
	self.y = params.y
	self.width = 16
	self.height = 16
	self.power = params.power
	self.dy = 30
	self.inPlay = true
end

function Power:hit()

	-- gSounds['brick-hit-2']:stop()
	-- gSounds['brick-hit-2']:play()

	if self.tier > 0 then
		if self.color == 1 then
			self.tier = self.tier - 1
			self.color = 5
		else
			self.color = self.color - 1
		end
	else
		if self.color == 1 then
			self.inPlay = false
		else
			self.color = self.color -1
		end
	end
	
	if not self.inPlay then
		gSounds['brick-hit-1']:stop()
		gSounds['brick-hit-1']:play()
	end
end

function Power:update(dt)
	self.y = self.y + self.dy * dt

	if self.y >= VIRTUAL_HEIGHT then
		self.inPlay = false
	end

end

function Power:render()
	if self.inPlay == true then
		love.graphics.draw(gTextures['main'], gFrames['powers'][self.power], self.x, self.y)
	end
end