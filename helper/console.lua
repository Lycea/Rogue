local console = {}

local buffer = {}
local buffer_max = 30
local cons_x = 605
local cons_y = 145
local cons_w = 200
local cons_h = 450



function console.print(text)
 -- if #buffer>=buffer_max then
 --   table.remove(buffer,buffer_max)
 -- end
  
  while #buffer >= buffer_max do
    table.remove(buffer,buffer_max)
  end
  
  table.insert(buffer,1,text)

end

function console.log(text)
 -- if #buffer>=buffer_max then
 --   table.remove(buffer,buffer_max)
 -- end
  
  while #buffer >= buffer_max do
    table.remove(buffer,buffer_max)
  end
  
  table.insert(buffer,1,text)

end


function console.setPos(x,y)
  cons_x = x
  cons_y = y
end

function console.setSize(w,h)
  cons_w = w
  cons_h = h
  
  --font magic to get a nice height and right buffer for it 
  f = love.graphics.getFont()
  local height = f:getHeight()
  buffer_max = math.floor(h/height)
end


function console.draw()
  love.graphics.rectangle("line",cons_x,cons_y,cons_w,cons_h)
  love.graphics.print(table.concat(buffer,"\n"),cons_x+5,cons_y+5)
end

function console.clear()
    buffer = {}
end





return console