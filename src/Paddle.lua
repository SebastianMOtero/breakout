Paddle = Class{}

function Paddle:init(skin)
	self.x = VIRTUAL_WIDTH / 2 - 32
	self.y = VIRTUAL_HEIGHT - 32
	self.dx = 0 

	self.height = 16
	
	self.skin = skin
	self.size = 2
	self.width = 32 * self.size
end

function Paddle:collides(target)
	if self.x > target.x + target.width or target.x > self.x + self.width then
		return false
	end

	if self.y > target.y + target.height or target.y > self.y + self.height then
		return false
	end

	return true
end

function Paddle:update(dt)
	if love.keyboard.isDown('left') then
		self.dx = -PADDLE_SPEED
	elseif love.keyboard.isDown('right') then
		self.dx = PADDLE_SPEED
	else
		self.dx = 0
	end

	if self.dx < 0 then
		self.x = math.max(0, self.x + self.dx * dt)
	else
		self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
	end
end

function Paddle:render()
	love.graphics.draw(gTextures['main'], gFrames['paddles'][self.size + 4 * (self.skin - 1)], self.x, self.y)
end

function Paddle:increase()
	if self.size < 4 then
		self.size = self.size + 1
		self.width = 32 * self.size
	end
end

function Paddle:decrease()
	if self.size > 1 then
		self.size = self.size - 1
		self.width = 32 * self.size
	end
end
