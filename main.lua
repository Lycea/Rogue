require("helper.aliases")
class_base= require("helper.classic")
console =require("helper.console")
game =require("game")

debuger = {
  on = function() print("Not able to turn debuger on , start in debug mode")end,
  off = function() print("Not able to turn debuger off , start in debug mode")end,
  start = function() print("Not able to start debuging , start in debug mode")end,
          }


local maj,min,rev=love.getVersion()
if maj >= 11 then
    require("helper.cindy").applyPatch()
end






function love.load(args)
  
  for idx, arg in pairs(args) do
      if arg == "-debug" then
        debuger = require("mobdebug")
        debuger.start()
        debuger.off()
        break
      end
  end
  --love.window.setMode(80*tile_size,50*tile_size)
  game.load()
  
  --love.keyboard.setKeyRepeat(true)
end


function love.update(dt)
  game.update(dt)
  
  
end

function love.draw()
  game.draw()
end


function love.keypressed(k,s,r)
  game.keyHandle(k,s,r,true)
  if key == "escape" then
    love.event.quit()
  end
  
end

function love.keyreleased(k)
    game.keyHandle(k,0,0,false)
end

function love.mousepressed(x,y,btn,t)
  game.MouseHandle(x,y,btn,t)
end

function love.mousemoved(x,y,dx,dy)
    game.MouseMoved(x,y)
end