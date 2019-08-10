local BASE = (...)..'.' 
--print(BASE)
local i= BASE:find("game_map.$")
--print (i)
BASE=BASE:sub(1,i-1)
require(BASE.."tile")
require(BASE.."rectangle")



GameMap = class_base:extend()


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
  if bare ~= false then
    self.make_map(self)
  end
end

function GameMap:save()
    local save_txt =""
    offset_push()
    
    save_txt =save_txt..'"width":'..self.width..",\n"
    save_txt =save_txt..'"height":'..self.height..",\n"
    save_txt =save_txt..'"dungeon_level":'..self.dungeon_level..",\n"
    
    local tiles_tmp ={}
    local rows_tmp={}
    
    save_txt = save_txt..add_offset()..'"tiles":[\n'
    for idx_y,row in ipairs(self.tiles) do
        tiles_tmp={}
        offset_push()
        for idx_x,tile in ipairs(row)do
            table.insert(tiles_tmp,add_offset().."{"..tile:save().."}\n")
        end
        offset_pop()
        table.insert(rows_tmp,add_offset().."[\n"..table.concat(tiles_tmp,",\n").."\n"..add_offset().."]")
    end
    
    offset_pop()
    
    
    save_txt = save_txt..table.concat(rows_tmp,",\n")..add_offset()
    save_txt = save_txt.."\n"..add_offset().."]\n"
    return save_txt
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
  
  local last_center = 0
  for room=1 ,constants.max_rooms do
    --random size
    local w = math.random(constants.room_min_size,constants.room_max_size)
    local h = math.random(constants.room_min_size,constants.room_max_size)
    
    --random position
    local x = math.random(1,constants.map_width-w-1) 
    local y = math.random(1,constants.map_height-h-1) 
    
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
      
      self:place_entities(new_room,entities,max_monster_per_room)
      
      table.insert(rooms,new_room)
      num_rooms = num_rooms+1
    else
      
    end
    
    
  end
  local tmp_stairs    = stairs(self.dungeon_level+1)
  local stairs_entity = Entity(last_center[1],last_center[2],0,"black","stairs",false,nil,nil,RenderOrder.ITEM,nil,nil,tmp_stairs)

  table.insert(entities,stairs_entity)
    
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
            love.graphics.setColor(constants.colors.light_wall)
          else
            love.graphics.setColor(constants.colors.light_ground)
          end
          self.tiles[y][x].explored = true
          love.graphics.rectangle("fill",x*constants.tile_size,
              y*constants.tile_size,constants.tile_size,constants.tile_size)
        elseif self.tiles[y][x].explored then
          if wall == true then
            love.graphics.setColor(constants.colors.dark_wall)
          else
            love.graphics.setColor(constants.colors.dark_ground)
          end
          love.graphics.rectangle("fill",x*constants.tile_size,
              y*constants.tile_size,constants.tile_size,constants.tile_size)
        end
        --love.graphics.setColor(colors.default)
        --love.graphics.rectangle("line",x*tile_size-tile_size,y*tile_size-tile_size,tile_size,tile_size)
      end
    end
    love.graphics.setColor(constants.colors.default)
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
    
  local number_of_monsters = get_value_from_table(monster_number_level_idx,self.dungeon_level) --math.random(0,max_monster_per_room)
  local number_of_items = get_value_from_table(item_number_level_idx,self.dungeon_level)--floor(math.random(0,max_items_per_room))
  
  local item_changes ={
      --healing_potion= 70,
      --lightning_scroll= get_value_from_table({{10,1},{15,3}},self.dungeon_level),
      --fireball_scroll = get_value_from_table({{10,2},{15,4}},self.dungeon_level),
      --sword= get_value_from_table({{5,1},{7,3}},self.dungeon_level),
      --shield= get_value_from_table({{5,1},{7,3}},self.dungeon_level),
      --confusing_scroll= 5
  }
  
  -- generate monster chance list
  monster_chances ={}
  for idx,monster_stats in pairs(enemie_lookup)do
      monster_chances[idx] = get_value_from_table(monster_stats.chances,self.dungeon_level)
  end
  
  -- TODO fix naming ...
  -- generate item chance list
  item_changes = {}
  
  for idx,item_stats in pairs(item_lookup) do
    item_changes[idx] = get_value_from_table(item_stats.chances,self.dungeon_level)
  end
  
  
  
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
      local monster_choice = random_choice_from_dict(monster_chances)--enemie_lookup
     -- print(monster_choice)
      
      
      
      local mob = enemie_lookup[monster_choice]
      local stats_= Fighter(mob.hp,mob.def,mob.power,mob.exp)
      local behaviour_ =ai_list[mob.ai]()
      
      monster = Entity(x,y,0,mob.color,mob.name,mob.blocking,stats_,behaviour_,mob.render)
      
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
        local item_choice = random_choice_from_dict(item_changes)
        
        local num = math.random(0,100)
        print(item_choice)
        local item_tmp = item_lookup[item_choice]
        local item_comp = nil
        local equippment_component = nil
        local message_component = nil
        
        if item_tmp.type == "item" then
            if item_tmp.message then
               message_component =Message(item_tmp.message.text,constants.colors[item_tmp.message.color]) 
            end
            item_comp = Item(item_function[item_tmp["function"]],item_tmp.is_ranged,message_component,item_tmp.arguments)
        else
            equippment_component =Equipable(item_tmp.slot,item_tmp.health,item_tmp.def,item_tmp.power)
        end
        
        
        local collectable = Entity(x,y,0,item_tmp.color,item_tmp.name,item_tmp.blocking,nil,nil,item_tmp.render,item_comp,nil,nil,nil,nil,equippment_component)--equippment,equippable)
                            --Entity(x,y,0,"orange","health",false,nil,nil,RenderOrder.ITEM,item_comp)
          
        table.insert(entities,collectable)
        
        
        --if item_choice == "healing_potion" then
        --  local item_comp=Item(item_function.heal,false,nil,{amount=4})
        --  item = Entity(x,y,0,"orange","health",false,nil,nil,RenderOrder.ITEM,item_comp)
          
        --if item_choice == "fireball_scroll" then
         --   local item_comp = Item(item_function.cast_fireball,true,Message("Hit enter to set target",constants.colors.green),{damage=10,radius=5})
         --   item = Entity(x,y,0,"red","fireball_scroll",false,nil,nil,RenderOrder.ITEM,item_comp)
        --elseif item_choice == "confusing_scroll" then
        --    local item_comp = Item(item_function.cast_confuse,true,Message("Hit enter to set target",constants.colors.green),{})
        --    item = Entity(x,y,0,"blue","confusing_scroll",false,nil,nil,RenderOrder.ITEM,item_comp)
       --if item_choice == "shield" then
            --hp,def,pow
        --    local equip =Equipable(EquipmentSlots.HAND_LEFT,3,5,0)
        --    item = Entity(x,y,0,"green","shield",false,nil,nil,RenderOrder.ITEM,nil,nil,nil,nil,nil,equip)
        --elseif item_choice == "sword" then
            --hp,def,pow
        --    local equip =Equipable(EquipmentSlots.OFF_HAND,0,0,5)
        --    item = Entity(x,y,0,"light_blue","sword",false,nil,nil,RenderOrder.ITEM,nil,nil,nil,nil,nil,equip)
        --else
        --  local item_comp = Item(item_function.cast_lightning,false,nil,{damage=20,max_range=5})
        --  item = Entity(x,y,0,"yellow","lightning_rune",false,nil,nil,RenderOrder.ITEM,item_comp)
        --end
        --table.insert(entities,item)
    end
  end
end
