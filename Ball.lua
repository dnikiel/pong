Ball = Class{}

function Ball:init(x, y)
  -- Ball position
  self.x = x
  self.y = y
  -- Ball starting destination
  self.dx = math.random(2) == 1 and 100 or -100
  self.dy = math.random(-50, 50)
  -- Ball size
  self.width = 4
  self.height = 4
end

function Ball:move(dt)
  -- Scale the velocity by dt so movement is framerate-independent
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt
end

function Ball:reset()
  self.x = VIRTUAL_WIDTH / 2 - 2
  self.y = VIRTUAL_HEIGHT / 2 - 2

  self.dx = math.random(2) == 1 and 100 or -100
  self.dy = math.random(-50, 50)
end

function Ball:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
