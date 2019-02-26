-- Pong game made with lua and love2d.

push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_WIDTH = 5
PADDLE_HEIGHT = 20

function love.load()
  -- This is replaced with push:setupScreen
  --
  -- love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
  --   fullscreen = false,
  --   resizable = false,
  --   vsync = true
  -- })

  love.graphics.setDefaultFilter('nearest', 'nearest')

  -- More "retro-looking" font object
  retroFont = love.graphics.newFont('font.ttf', 8)

  love.graphics.setFont(retroFont)

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end

function love.draw()
  push:start()

  -- Draw welcome text
  love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

  -- Draw first paddle (left side)
  love.graphics.rectangle('fill', 10, 30, PADDLE_WIDTH, PADDLE_HEIGHT)

  -- Draw second paddle (right side)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, PADDLE_WIDTH, PADDLE_HEIGHT)

  -- Draw ball (center)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

  push:finish()
end
