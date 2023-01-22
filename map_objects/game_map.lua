local BASE = (...)..'.' 
--print(BASE)
local i= BASE:find("game_map.$")
--print (i)
BASE=BASE:sub(1,i-1)
require(BASE.."tile")
require(BASE.."rectangle")



local GameMap = class_base:extend()


local max_monster_per_room = 3
local max_items_per_room = 1

function GameMap:new(width,height,bare,level)
  self.width = width
  self.height = height
  self.tiles = self.initialize_tiles(self)
  if level == nil then
      level = 1
  end
  
  self.dungeon_level = level
  if bare == false then
      print("creating map....")
    self.make_map(self)
  end
end

function GameMap:save()
    local dl = glib.data_loader
    local save_txt =""
    dl.offset_push()
    
    save_txt =save_txt..'"width":'..self.width..",\n"
    save_txt =save_txt..'"height":'..self.height..",\n"
    save_txt =save_txt..'"dungeon_level":'..self.dungeon_level..",\n"
    
    local tiles_tmp ={}
    local rows_tmp={}
    debuger:on()
    save_txt = save_txt..dl.add_offset()..'"tiles":'
    for idx_y,row in ipairs(self.tiles) do
        dl.offset_push()
        for idx_x,tile in ipairs(row)do
            if tile.empty == false then
                table.insert(tiles_tmp,dl.add_offset().."{"..tile:save({x=idx_x,y=idx_y}).."}\n")
            end
        end
        dl.offset_pop()

    end
    
    table.insert(rows_tmp,dl.add_offset().."[\n"..table.concat(tiles_tmp,",\n").."\n"..dl.add_offset().."]")
    debuger:off()
    dl.offset_pop()
    
    
    save_txt = save_txt..rows_tmp[1]..dl.add_offset()
    save_txt = save_txt.."\n"
    return save_txt
end



function GameMap:initialize_tiles()
  local tmp_tiles={}
  for y=1,self.height do
    tmp_tiles[y] ={}
    for x=1,self.width do
      --tmp_tiles[y][x]=Tile(false)
      tmp_tiles[y][x]=Tile(true)  --for generation purpose ?
      tmp_tiles[y][x].empty=true
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
    
    self.tiles[y][x].empty=false
  end
end

function GameMap:create_v_tunnel(y1,y2,x)
  for y=math.min(y1,y2),math.max(y1,y2) do
    self.tiles[y][x].blocked=false
    self.tiles[y][x].block_sight=false
    
    self.tiles[y][x].empty=false
  end
end

function GameMap:create_room(room)
  --walk tiles and make them passable
  for x=room.x1+1,room.x2 do
    for y=room.y1+1,room.y2 do
      self.tiles[y][x].blocked = false
      self.tiles[y][x].block_sight = false
      
      self.tiles[y][x].empty=false
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
  
  local last_center = 0
  for room=1 ,gvar.constants.max_rooms do
    --random size
    local w = math.random(gvar.constants.room_min_size,gvar.constants.room_max_size)
    local h = math.random(gvar.constants.room_min_size,gvar.constants.room_max_size)
    
    --random position
    local x = math.random(1,gvar.constants.map_width-w-1) 
    local y = math.random(1,gvar.constants.map_height-h-1) 
    
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
          gvar.player.x = center[1]
          gvar.player.y = center[2]
      else
          
        last_center = center
        local center_prev = rooms[num_rooms]:center() --get the previous room center
        local prev_x,prev_y = center_prev[1],center_prev[2]
        if math.random(0,50)%2==1 then
          --console.print(prev_x)
          self:create_h_tunnel(prev_x,center[1],prev_y)
          self:create_v_tunnel(prev_y,center[2],center[1])
        else
          self:create_v_tunnel(prev_y,center[2],prev_x)
          self:create_h_tunnel(prev_x,center[1],center[2])
          
        end
        
      end
      
      self:place_entities(new_room,gvar.entities,max_monster_per_room)
      
      table.insert(rooms,new_room)
      num_rooms = num_rooms+1
    else
      
    end
    
    
  end
  local tmp_stairs    = glib.Stairs(self.dungeon_level+1)
  local stairs_entity = glib.Entity(last_center[1],last_center[2],0,"black","stairs",false,nil,nil,glib.renderer.RenderOrder.ITEM,nil,nil,tmp_stairs)

  table.insert(gvar.entities,stairs_entity)
    
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
        if gvar.fov_map[y][x] == true then
          if wall == true then
            love.graphics.setColor(gvar.constants.colors.light_wall)
          else
            love.graphics.setColor(gvar.constants.colors.light_ground)
          end
          self.tiles[y][x].explored = true
          love.graphics.rectangle("fill",x*gvar.constants.tile_size,
              y*gvar.constants.tile_size,gvar.constants.tile_size,gvar.constants.tile_size)
        elseif self.tiles[y][x].explored then
          if wall == true then
            love.graphics.setColor(gvar.constants.colors.dark_wall)
          else
            love.graphics.setColor(gvar.constants.colors.dark_ground)
          end
          love.graphics.rectangle("fill",x*gvar.constants.tile_size,
              y*gvar.constants.tile_size,gvar.constants.tile_size,gvar.constants.tile_size)
        end
        --love.graphics.setColor(colors.default)
        --love.graphics.rectangle("line",x*tile_size-tile_size,y*tile_size-tile_size,tile_size,tile_size)
      end
    end
    love.graphics.setColor(gvar.constants.colors.default)
end





function GameMap:place_entities(room,entities,max_monster_per_room)
    
  local monster_number_level_idx = {
      {2,1},
      {3,2},
      {5,5},
      {6,7},
  }
  
  local item_number_level_idx ={
        {2,1},
        {3,3},
        {5,7},
        {7,11}
  }
    
  local number_of_monsters = glib.random_utils.get_value_from_table(monster_number_level_idx,self.dungeon_level) --math.random(0,max_monster_per_room)
  local number_of_items = glib.random_utils.get_value_from_table(item_number_level_idx,self.dungeon_level)--floor(math.random(0,max_items_per_room))
  
  local item_changes ={}
  
  -- generate monster chance list
  local monster_chances ={}
  
  local monsters = sort_dict(gvar.enemie_lookup)
  for idx,name in ipairs(monsters) do
      monster_chances[name] = glib.random_utils.get_value_from_table( gvar.enemie_lookup[name].chances,self.dungeon_level)
  end
  
  -- TODO fix naming ...
  -- generate item chance list
  
  local items = sort_dict(gvar.item_lookup)

  print("-----\nitem list---")

  for idx,item_name in ipairs(items) do
    item_changes[item_name] = glib.random_utils.get_value_from_table(gvar.item_lookup[item_name].chances,self.dungeon_level)
    print(idx,item_name,item_changes[item_name])
  end
  print("-------------")
  
  
  
  for i=1,number_of_monsters do
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
      local monster_choice = glib.random_utils.random_choice_from_dict(monster_chances)--enemie_lookup
     -- print(monster_choice)
      
      local mob = gvar.enemie_lookup[monster_choice]
      local stats_= glib.Fighter(mob.hp,mob.def,mob.power,mob.exp)
      local behaviour_ =glib.ai[mob.ai]()
      
      monster = glib.Entity(x,y,0,mob.color,mob.name,mob.blocking,stats_,behaviour_,mob.render)
      
      table.insert(entities,monster)
    end
  end
  
  
  for i=1,number_of_items do
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
        local item = nil
        local item_choice = glib.random_utils.random_choice_from_dict(item_changes)
        
        local num = math.random(0,100)
        print(item_choice)
        local item_tmp = gvar.item_lookup[item_choice]
        local item_comp = nil
        local equippment_component = nil
        local message_component = nil
        
        if item_tmp.type == "item" then
            if item_tmp.message then
               message_component =glib.msg_renderer.Message(item_tmp.message.text,gvar.constants.colors[item_tmp.message.color]) 
            end
            
            item_comp = glib.inventory.Item(glib.item_functions[item_tmp["function"]],item_tmp.is_ranged,message_component,item_tmp.arguments)
        else
            equippment_component =glib.Equipable(item_tmp.slot,item_tmp.health,item_tmp.def,item_tmp.power)
        end
        
        
        local collectable = glib.Entity(x,y,0,item_tmp.color,item_tmp.name,item_tmp.blocking,nil,nil,item_tmp.render,item_comp,nil,nil,nil,nil,equippment_component)
          
        table.insert(entities,collectable)
    end
  end
end

return GameMap