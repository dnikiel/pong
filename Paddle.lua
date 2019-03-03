Paddle = Class{}

PADDLE_WIDTH = 5
PADDLE_HEIGHT = 20
PADDLE_SPEED = 200

function Paddle:init(x, y)
  self.x = x
  self.y = y
  self.width = 5
  self.height = 20
end

function Paddle:moveDown(dt)
  if self.y < VIRTUAL_HEIGHT - 50 then
    self.y = self.y + PADDLE_SPEED * dt
  end
end

function Paddle:moveUp(dt)
  if self.y > 30 then
    self.y = self.y + -PADDLE_SPEED * dt
  end
end

function Paddle:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
