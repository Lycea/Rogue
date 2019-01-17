Entity =class_base:extend()



function get_blocking_entitis_at_location(destin_x,destin_y)
  for k,entity in pairs(entities) do
    if entity.x == destin_x and entity.y == destin_y and entity.name ~= "Player" then
      return entity
    end
  end
  return nil
end

--import pather , import after helper,it may need it
print(...)
local BASE= ...
local idx =string.find(BASE,"entity")
BASE =BASE:sub(0,idx -1)

require(BASE.."components.paths")


local base_pathmaker = paths()
paths:setBlocked(
    function(x,y)
      if map:is_blocked(x,y) == false and get_blocking_entitis_at_location(x,y)==nil then
        return false
      else
        return true
      end
    end
    )


function Entity:new(x,y,tile,color,name,blocks,fighter,ai)
    self.x = x
    self.y = y
    
    self.tile = tile
    self.color = color
    
    self.name = name
    self.blocks = blocks or false
    self.fighter =fighter 
    self.ai = ai
    
    --set the parent to access it in the module
    if self.fighter then
      self.fighter.owner = self
    end
    
    if self.ai then
      print(self)
      
      self.ai.owner = self
      print(self.ai.owner)
    end
    
end




function Entity:move(dx,dy)
    self.x = self.x+dx
    self.y = self.y+dy
end

function Entity:move_to(dx,dy)
    self.x = dx
    self.y = dy
end

function Entity:move_towards4(target_x,target_y)
  local dx = target_x - self.x
  local dy = target_y - self.y
  
  local distance = math.sqrt(dx^2+dy^2)
  
  dx =math.floor(dx/distance+0.5)
  dy =math.floor(dy/distance+0.5)
  
  console.print(dx.." "..dy)
  if  map:is_blocked(self.x+dx,self.y+dy)==false and
      get_blocking_entitis_at_location(self.x+dx,self.y+dy)==nil then
      self:move(dx,dy)
  end
end


function Entity:move_breadth(target)
  local tmp_path =paths:gen_map_breadth(self,target)
  if tmp_path then
    self:move_to(tmp_path[1][1],tmp_path[1][2])
  else
    self:move_towards4(target.x,target.y)
  end
end






function Entity:move_towards8(target_x,target_y)
  local dx = target_x - self.x
  local dy = target_y - self.y
  
  local distance = math.sqrt(dx^2+dy^2)
  
  dx =math.floor(dx/distance)
  dy =math.floor(dy/distance)
  
  if  map:is_blocked(self.x+dx,self.y+dy)==false and
      get_blocking_entitis_at_location(self.x+dx,self.y+dy)==nil then
        
      self:move(dx,dy)
  end
end


function Entity:angle_to(other)
    return math.deg( math.atan(other.y-self.y,other.y-self.x))
end


function Entity:distance_to(other)
   local dx = other.x-self.x
   local dy = other.y-self.y
   return math.sqrt(math.pow(dx,2)+math.pow(dy,2))
end



function Entity:draw()
  if fov_map[self.y][self.x]==true then
    
    love.graphics.setColor( colors[self.color] or {255,0,0})
    love.graphics.rectangle("fill",self.x*tile_size,self.y*tile_size,tile_size,tile_size)
    love.graphics.setColor(colors.default)
  end
end


