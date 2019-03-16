Paddle = Class{}

PADDLE_WIDTH = 5
PADDLE_HEIGHT = 20
PADDLE_SPEED = 200

function Paddle:init(x, y, color)
  -- Paddle position
  self.x = x
  self.y = y

  -- Paddle size
  self.width = PADDLE_WIDTH
  self.height = PADDLE_HEIGHT

  -- Paddle color
  self.color = color or getColor('red')
end

function Paddle:moveDown(dt)
  -- Scale the velocity by dt so movement is framerate-independent
  if self.y < VIRTUAL_HEIGHT - PADDLE_HEIGHT - 2 then
    self.y = self.y + PADDLE_SPEED * dt
  else
    self.y = VIRTUAL_HEIGHT - PADDLE_HEIGHT - 2
  end
end

function Paddle:moveUp(dt)
  -- Scale the velocity by dt so movement is framerate-independent
  if self.y > BOARD_BORDER_TOP + 1 then
    self.y = self.y + -PADDLE_SPEED * dt
  else
    self.y = BOARD_BORDER_TOP + 1
  end
end

function Paddle:render()
  love.graphics.setColor(self.color)
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
