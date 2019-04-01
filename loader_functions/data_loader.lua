offset_level   = 0
offset_p_level = 2

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


local function load_single_entity(entity)
  local tmp_ai = nil
  local tmp_fighter = nil
  local tmp_item = nil
  local tmp_inventory = nil
  
  if entity.ai then
      if entity.ai.ai== "BasicMonster"then
         tmp_ai =BasicMonster() 
      else
         tmp_ai = ConfusedMonster(entity.ai.previous,entity.ai.number_of_turns)
      end
  end
  if entity.fighter then
      tmp_fighter = Fighter(entity.fighter.max_hp,entity.fighter.defense,entity.fighter.power)
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
  local tmp_entity=Entity(entity.x,entity.y,nil,entity.color,entity.name,entity.blocks,tmp_fighter,tmp_ai,entity.render_order,tmp_item,tmp_inventory)
  return tmp_entity
    
    --tmp_entity =Entity(x,y,tile,color,name,blocks,fighter,ai,render_order,item,inventory)
end

local function load_entitys(entity_list)
    print("----")
    print("loading entities")
    entities ={}
    --cgtalk /cgsociity
    --artstation
    --3dring
    for idx,entity in ipairs(entity_list) do
       local tmp_entity= load_single_entity(entity)
       table.insert(entities,tmp_entity)
        if entity.name == "Player"then
            player = tmp_entity
        end
    end
    
    print("----")
end

local function load_map(map_)
    print("----")
    print("loading up map")
    print(map_.width,map_.height)
    print(#map_.tiles)
    
    map = GameMap(map_.width,map_.height)
    for idx_y,row in ipairs(map_.tiles) do
        for idx_x,tile in ipairs(row) do
            map.tiles[idx_y][idx_x].blocked = tile.blocked
            
            map.tiles[idx_y][idx_x].explored = tile.explored
            map.tiles[idx_y][idx_x].block_sight = tile.block_sight
        end
    end
    
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
     
     load_map(save_.map)
     debuger.on()
     load_entitys(save_.entities)
     debuger.off()
     return true
   end
   
  
end


function save_game()
   --load_game()
    
   offset_level = 0
   file =io.open("save.json","w")
   
   entities_='{"entities":['
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
