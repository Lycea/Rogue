local BASE = (...)..'.' 
--print(BASE)
local i= BASE:find("game_map.$")
--print (i)
BASE=BASE:sub(1,i-1)
require(BASE.."tile")
require(BASE.."rectangle")



GameMap = class_base:extend()


local max_monster_per_room = 3

function GameMap:new(width,height)
  self.width = width
  self.height = height
  self.tiles = self.initialize_tiles(self)
  self.make_map(self)
end



function GameMap:initialize_tiles()
  local tmp_tiles={}
  for y=1,self.height do
    tmp_tiles[y] ={}
    for x=1,self.width do
      --tmp_tiles[y][x]=Tile(false)
      tmp_tiles[y][x]=Tile(true)  --for generation purpose ?
    end
  end
  return tmp_tiles
end

------------------------------
  --------map generation start
  
  

function GameMap:create_h_tunnel(x1,x2,y)
  for x=math.min(x1,x2),math.max(x1,x2) do
    --print(x,y)
    self.tiles[y][x].blocked=false
    self.tiles[y][x].block_sight=false
  end
end

function GameMap:create_v_tunnel(y1,y2,x)
  for y=math.min(y1,y2),math.max(y1,y2) do
    self.tiles[y][x].blocked=false
    self.tiles[y][x].block_sight=false
  end
end

function GameMap:create_room(room)
  --walk tiles and make them passable
  for x=room.x1+1,room.x2 do
    for y=room.y1+1,room.y2 do
      self.tiles[y][x].blocked = false
      self.tiles[y][x].block_sight = false
    end
  end

end


--function GameMap:make_map(max_rooms,room_min_size,room_max_size,map_width,map_height,player)
function GameMap:make_map()
  --sample rooms 
  --local room1 = Rect(20,15,10,15)
  --local room2 = Rect(35,15,10,15)
  
  
  --self:create_room(room1)
  --self:create_room(room2)
  
  --self:create_h_tunnel(25, 40, 23)
  ------------------
  local rooms={}
  local num_rooms =0
  
  for room=1 ,max_rooms do
    --random size
    local w = math.random(room_min_size,room_max_size)
    local h = math.random(room_min_size,room_max_size)
    
    --random position
    local x = math.random(1,map_width-w-1) 
    local y = math.random(1,map_height-h-1) 
    
    local new_room = Rect(x,y,w,h)
    
    local intersection = false
    for k,other_room in pairs(rooms) do
      if new_room:intersect(other_room)then
        intersection = true
        break
      end
    end
    
    --room is okey
    if intersection == false then
      self:create_room(new_room)
      local center = new_room:center()
      
      if num_rooms == 0 then
          player.x = center[1]
          player.y = center[2]
      else
        local center_prev = rooms[num_rooms]:center() --get the previous room center
        local prev_x,prev_y = center_prev[1],center_prev[2]
        if math.random(0,50)%2==1 then
          console.print(prev_x)
          self:create_h_tunnel(prev_x,center[1],prev_y)
          self:create_v_tunnel(prev_y,center[2],center[1])
        else
          self:create_v_tunnel(prev_y,center[2],prev_x)
          self:create_h_tunnel(prev_x,center[1],center[2])
          
        end
        
      end
      
      self:place_entities(new_room,entities,max_monster_per_room)
      
      table.insert(rooms,new_room)
      num_rooms = num_rooms+1
    else
      
    end
    
    
  end
  
end


---------map generation end
--------------------------------

function GameMap:is_blocked(x,y)
    --print(x,y)
    if self.tiles[y][x].blocked then
      return true
    end
      
    return false
end



function GameMap:draw()
    
    for y=1,self.height,1 do
      for x=1,self.width,1 do
        local wall =self.tiles[y][x].block_sight
        if fov_map[y][x] == true then
          if wall == true then
            love.graphics.setColor(colors.light_wall)
          else
            love.graphics.setColor(colors.light_ground)
          end
          self.tiles[y][x].explored = true
          love.graphics.rectangle("fill",x*tile_size,y*tile_size,tile_size,tile_size)
        elseif self.tiles[y][x].explored then
          if wall == true then
            love.graphics.setColor(colors.dark_wall)
          else
            love.graphics.setColor(colors.dark_ground)
          end
          love.graphics.rectangle("fill",x*tile_size,y*tile_size,tile_size,tile_size)
        end
        --love.graphics.setColor(colors.default)
        --love.graphics.rectangle("line",x*tile_size-tile_size,y*tile_size-tile_size,tile_size,tile_size)
      end
    end
    love.graphics.setColor(colors.default)
end



function GameMap:place_entities(room,entities,max_monster_per_room)
  local number_of_monsters = math.random(0,max_monster_per_room)
  
  for i=0,number_of_monsters do
    local x,y
    x= math.random(room.x1+1,room.x2-1)
    y= math.random(room.y1+1,room.y2-1)
    
    local free_space = true
    for k,entity in pairs(entities)do
      if entity.x == x and entity.y ==y then
        free_space = false
        break
      end
    end
    --no mob on that grid field right now
    if free_space == true then
      local monster
      if math.random(0,100)<80 then
        local stats_= Fighter(10,0,3)
        local behaviour_ =BasicMonster()
        
        monster = Entity(x,y,0,"darker_green","Goblin",true,stats_,behaviour_,RenderOrder.ACTOR)
      else
        local stats_= Fighter(16,1,4)
        local behaviour_ =BasicMonster()
        
        monster = Entity(x,y,0,"desaturated_green","Orc",true,stats_,behaviour_,RenderOrder.ACTOR)
      end
      
      table.insert(entities,monster)
    end
  end
end
