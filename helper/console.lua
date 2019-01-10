local console = {}

local buffer = {}
local buffer_max = 30


function console.print(text)
 -- if #buffer>=buffer_max then
 --   table.remove(buffer,buffer_max)
 -- end
  
  while #buffer >= buffer_max do
    table.remove(buffer,buffer_max)
  end
  
  table.insert(buffer,1,text)

end



function console.draw()
  love.graphics.rectangle("line",605,145,200,450)
  love.graphics.print(table.concat(buffer,"\n"),610,150)
end

function console.clear()
    buffer = {}
end




return console