Brick = Class{}

paletteColors = {

	[1] = {
		['r'] = 0,
		['g'] = 0,
		['b'] = 255,
	},

	[2] = {
		['r'] = 0,
		['g'] = 255,
		['b'] = 0,
	},

	[3] = {
		['r'] = 255,
		['g'] = 0,
		['b'] = 0,
	},

	[4] = {
		['r'] = 255,
		['g'] = 0,
		['b'] = 255
	},

	[5] = {
		['r'] = 255,
		['g'] = 255,
		['b'] = 0
	}
}

function Brick:init(x, y)
	self.color = 1
	self.tier = 0

	self.x = x
	self.y = y
	self.width = 32
	self.height = 16


	self.inPlay = true

	self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

	self.psystem:setParticleLifetime(0.5, 1)
	self.psystem:setLinearAcceleration(-15, 0, 15, 80)
	self.psystem:setEmissionArea('normal', 10, 10)
end

function Brick:hit()

    self.psystem:setColors(
		paletteColors[self.color].r,
		paletteColors[self.color].g,
		paletteColors[self.color].b,
		0.3,
		paletteColors[self.color].r,
		paletteColors[self.color].g,
		paletteColors[self.color].b,
		0.1
    )
    self.psystem:emit(64)

	gSounds['brick-hit-2']:stop()
	gSounds['brick-hit-2']:play()

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

function Brick:update(dt)
	self.psystem:update(dt)
end

function Brick:render()
	if self.inPlay then
		love.graphics.draw(gTextures['main'], gFrames['bricks'][1 + ((self.color - 1) * 4) + self.tier], self.x, self.y)
	end
end

function Brick:renderParticles()
	love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end
