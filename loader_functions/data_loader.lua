offset_level   = 0
offset_p_level = 2


local file_version = {1,1,0,0}


local loading_version= {}
local version_string =""
-----------------------------
--save game helper functions
-----------------------------


-----Increases offset level
function offset_push()
    offset_level= offset_level+1
end

-----Decreased offset level
function offset_pop()
  offset_level = offset_level-1
end

-----Insert offset
function add_offset()
    return string.rep(" ",offset_p_level*offset_level)
end


function save_game()
   --load_game()
    
   offset_level = 0
   file =io.open("save.json","w")
   
   entities_='{'..'"file_version":['..table.concat(file_version,",")..'], \n "entities":['
   offset_push()
   for idx,entity in pairs(entities) do
       offset_push()
       entities_= entities_.."\n"..add_offset().."{\n"..entity:save()..add_offset().."},"
       offset_pop()
   end
   entities_ = string.sub(entities_,0,-1)
   entities_ = entities_.."\n],"

   map_ = '"map":{'..map:save().."\n}}"
    file:write(entities_..map_)
    file:close()    
end

-----------------------------
--load game helper functions
-----------------------------

local function load_single_entity(entity)
  local tmp_ai         = nil
  local tmp_fighter    = nil
  local tmp_item       = nil
  local tmp_inventory  = nil
  local tmp_stairs     = nil
  local tmp_level      = nil
  local tmp_equippment = nil
  local tmp_equippable = nil
  
  if entity.ai then
      if entity.ai.ai== "BasicMonster"then
         tmp_ai =BasicMonster() 
      else
         local prev_ai = BasicMonster()
         tmp_ai = ConfusedMonster(prev_ai,entity.ai.number_of_turns)
      end
  end
  if entity.fighter then
      tmp_fighter = Fighter(entity.fighter.max_hp,entity.fighter.defense,entity.fighter.power,entity.fighter.xp)
      tmp_fighter.hp = entity.fighter.hp
  end
  if entity.item then
      tmp_item = Item(item_function[entity.item.use_function],entity.item.targeting,"test_msg",entity.item.function_args)
  end
  if entity.inventory then
      tmp_inventory = Inventory(entity.inventory.capacity)
      
      for idx,item in ipairs(entity.inventory.items) do
        tmp_inventory:add_item( load_single_entity(item))
      end
      
      --[[for idx,item in ipairs(entity.inventory.items) do
          tmp_item_ = nil
          tmp_item_ = Item(item_function[item.use_function],item.targeting,"test_msg",item.function_args)
          tmp_item_.name =item.name
          tmp_inventory:add_item(tmp_item_)
      end]]
  end
  
  if entity.stairs then
    tmp_stairs = stairs(entity.stairs.floor)
  end
  
  
  if entity.level then
    tmp_level = Level(entity.level.current_level,entity.level.current_xp,entity.level.level_base,entity.level.level_up_factor)
  end

  
  
  if entity.equippment then
    local main_equip = nil
    local off_equip = nil
    
    tmp_equippment = Equipment()
    debuger.on()
    if entity.equippment.main_hand then
        main_equip =tmp_inventory.item_stacks[entity.equippment.main_hand.invi_idx].item_type
        
        tmp_equippment:toggle_equip(main_equip)
    end
    
    if entity.equippment.off_hand then
        off_equip =tmp_inventory.item_stacks[entity.equippment.off_hand.invi_idx].item_type
        tmp_equippment:toggle_equip(off_equip)
    end
    debuger.off()
    
  end
  
  
  
  if entity.equippable then
    tmp_equippable = Equipable(entity.equippable.slot,entity.equippable.health,entity.equippable.def,entity.equippable.power)
  end
  
  
  
  
  local tmp_entity=Entity(entity.x,entity.y,nil,entity.color,entity.name,entity.blocks,tmp_fighter,tmp_ai,entity.render_order,tmp_item,tmp_inventory,tmp_stairs,tmp_level,tmp_equippment,tmp_equippable)
  return tmp_entity
    
    --tmp_entity =Entity(x,y,tile,color,name,blocks,fighter,ai,render_order,item,inventory)
end

local function load_entitys(entity_list)
    print("\n\n----")
    print("loading entities")
    
    entities ={}

    for idx,entity in ipairs(entity_list) do
       local tmp_entity= load_single_entity(entity)
       table.insert(entities,tmp_entity)
        if entity.name == "Player"then
            player = tmp_entity
            player.last_target = 0
        end
    end
    
    print("----")
end

local function load_map(map_)
    print("\n\n----")
    print("loading up map")
    print(map_.width,map_.height)
    print(#map_.tiles)
    debuger:on()
    map = GameMap(map_.width,map_.height,true,map_.dungeon_level)
    
    --check which version is used since we changed something in there then
    if loading_version == "1.0.0.0" then
        --load up the old way, every , single,tile
        for idx_y,row in ipairs(map_.tiles) do
            for idx_x,tile in ipairs(row) do
                map.tiles[idx_y][idx_x].blocked = tile.blocked
                
                map.tiles[idx_y][idx_x].explored = tile.explored
                map.tiles[idx_y][idx_x].block_sight = tile.block_sight
                map.tiles[idx_y][idx_x].empty = false
            end
        end
    else
        --load up the new way, all tiles by tile x and y
        for idx_y,tile in ipairs(map_.tiles) do
            local xpos,ypos = tile.x,tile.y
            map.tiles[tile.y][tile.x].blocked = tile.blocked
            
            map.tiles[tile.y][tile.x].explored = tile.explored
            map.tiles[tile.y][tile.x].block_sight = tile.block_sight
            map.tiles[tile.y][tile.x].empty = false
        
        end
    end
    debuger:off()
    print("----")
end

function load_game()
  
   local file = io.open("save.json","r")
   local error_ ,save_= pcall(json.decode,file:read("*all"))
   file:close()
   
   print(error_,save_)
   
   if error_ == false then
      return false
   else
     loading_version = save_.file_version
     version_string  = table.concat(loading_version,".")
     
     print("loading save version:  "..version_string,".")
 
     load_map(save_.map)
     load_entitys(save_.entities)
     return true
   end
   
  
end



