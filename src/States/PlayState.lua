PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
	self.paddle = params.paddle
	self.bricks = params.bricks
	self.health = params.health
	self.score = params.score
	self.balls = {}
	table.insert(self.balls, params.ball)
	self.level = params.level
	self.highScores = params.highScores
	self.recoverPoints = 5000
	self.powers = {}

	for k, ball in pairs(self.balls) do
		ball.dx = math.random(-200, 200)
		ball.dy = math.random(-100, -120)
	end
end

function PlayState:update(dt)
	if self.paused then
		if love.keyboard.wasPressed('space') then
			self.paused = false
			gSounds['pause']:play()
		else
			return
		end
	elseif love.keyboard.wasPressed('space') then
		self.paused = true
		gSounds['pause']:play()
		return
	end

	self.paddle:update(dt)
	for k, ball in pairs(self.balls) do
		ball:update(dt)
	end

	for k, power in pairs(self.powers) do
		power:update(dt)
	end

	for k, ball in pairs(self.balls) do
		if ball:collides(self.paddle) then
			ball.y = ball.y - 8
			ball.dy = -ball.dy
	
			if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
				ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 -ball.x))
	
			elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
				ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
			end
	
			gSounds['paddle-hit']:play()
		end
	end

	for k, power in pairs(self.powers) do
		if self.paddle:collides(power) then

			if  power.power == 3 then
				self.health = self.health + 1
			elseif power.power == 4 then
				gStateMachine:change('game-over', {
					score = self.score,
					highScores = self.highScores
				})
			elseif power.power == 5 then
				self.paddle:increase()
			elseif power.power == 6 then
				self.paddle:decrease()
			elseif power.power == 9 then
				--bola extra
				newBall = Ball()
				newBall.skin = math.random(7)
				newBall.x = self.paddle.x + (self.paddle.width / 2) - 4
				newBall.y = self.paddle.y - 8
				newBall.dx = math.random(-200, 200)
				newBall.dy = math.random(-100, -120)
				table.insert(self.balls, newBall)
			end
			table.remove(self.powers, k)
		end
	end

	for k, brick in pairs(self.bricks) do
		for i, ball in pairs(self.balls) do
			if brick.inPlay and ball:collides(brick) then
				self.score = self.score + (brick.tier * 200 + brick.color * 25)
				
				if brick.tier == 0 and brick.color == 1 and math.random(100) < 40 then
					power = Power({
						x = brick.x,
						y = brick.y,
						power =  math.random(10)
					})
					table.insert(self.powers, power)
				end
	
				brick:hit()
	
				if self.score > self.recoverPoints then
					self.health = math.min(3, self.health + 1)
					self.recoverPoints = math.min(100000, self.recoverPoints * 2)
	
					gSounds['recover']:play()
				end
	
				if self:checkVictory() then
					gSounds['victory']:play()
	
					gStateMachine:change('victory', {
						level = self.level,
						paddle = self.paddle,
						health = self.health,
						score = self.score,
						ball = ball,
						highScores = self.highScores,
						recoverPoints = self.recoverPoints
					})
				end
	
	
				if ball.x + 2 < brick.x and ball.dx > 0 then
					ball.dx = -ball.dx
					ball.x = brick.x - ball.width
				elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
					ball.dx = -ball.dx
					ball.x = brick.x + brick.width
				elseif ball.y < brick.y then
					ball.dy = -ball.dy
					ball.y = brick.y - ball.width
				else
					ball.dy = -ball.dy
					ball.y = brick.y + brick.height
				end
	
				ball.dy = ball.dy * 1.02
				break
			end
		end
		
	end

	for k, ball in pairs(self.balls) do
		if ball.y >= VIRTUAL_HEIGHT then
			table.remove(self.balls, k)
		end
	end

	--TO CONTROL
	if table.getn(self.balls) == 0 then
		self.health = self.health - 1
		gSounds['hurt']:play()

		if self.health == 0 then
			gStateMachine:change('game-over', {
				score = self.score,
				highScores = self.highScores
			})
		else 
			gStateMachine:change('serve', {
				paddle = self.paddle,
				bricks = self.bricks,
				health = self.health,
				score = self.score,
				highScores = self.highScores,
				level = self.level,
				recoverPoints = self.recoverPoints
			})
		end
	end

	for k, brick in pairs(self.bricks) do
		brick:update(dt)
	end
	
	-- if love.keyboard.wasPressed('escape') then
	-- 	love.event.quit()
	-- end
	if love.keyboard.wasPressed('escape') then
		gStateMachine:change('start', {
			highScores = loadHighScores()
		})
	end
end

function PlayState:render()
	self.paddle:render()
	for k, ball in pairs(self.balls) do
		ball:render()
	end

	renderScore(self.score)
	renderHealth(self.health)

	for k, power in pairs(self.powers) do
		power:render()
	end
	-- if self.powers ~= nil then
	-- 	self.powers:render()
	-- end

	for k, brick in pairs(self.bricks) do
		brick:render()
	end

	for k, brick in pairs(self.bricks) do
		brick:renderParticles()
	end

	if self.paused then
		love.graphics.setFont(gFonts['large'])
		love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
	end
end

function PlayState:checkVictory()
	for k, brick in pairs(self.bricks) do
		if brick.inPlay then
			return false
		end
	end
	return true
end

