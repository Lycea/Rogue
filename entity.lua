Entity =class_base:extend()

function Entity:new(x,y,tile,color)
    self.x = x
    self.y = y
    self.tile = tile
    self.color = color
end

function Entity:move(dx,dy)
    self.x = self.x+dx
    self.y = self.y+dy
end

function Entity:draw()
  if fov_map[self.y][self.x]==true then
    love.graphics.setColor(255,0,0)
    love.graphics.rectangle("fill",self.x*tile_size,self.y*tile_size,tile_size,tile_size)
    love.graphics.setColor(colors.default)
  end
end
