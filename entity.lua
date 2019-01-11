Entity =class_base:extend()

function Entity:new(x,y,tile,color,name,blocks)
    self.x = x
    self.y = y
    
    self.tile = tile
    self.color = color
    
    self.name = name
    self.blocks = blocks or false
end

function Entity:move(dx,dy)
    self.x = self.x+dx
    self.y = self.y+dy
end

function Entity:draw()
  if fov_map[self.y][self.x]==true then
    
    love.graphics.setColor( colors[self.color] or {255,0,0})
    love.graphics.rectangle("fill",self.x*tile_size,self.y*tile_size,tile_size,tile_size)
    love.graphics.setColor(colors.default)
  end
end


function get_blocking_entitis_at_location(destin_x,destin_y)
  for k,entity in pairs(entities) do
    if entity.x == destin_x and entity.y == destin_y then
      return entity
    end
  end
  return nil
end
