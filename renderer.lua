require("menue")

RenderOrder = class_base:extend()
RenderOrder.CORPSE = 1
RenderOrder.ITEM = 2
RenderOrder.ACTOR = 3




local function draw_entity(entity)
    entity:draw()
end


local function get_tile_under_mouse(x,y)
    
    debuger.on()
    local map_tile = map.tiles[y][x] 
    local fov_tile = fov_map[y][x]
    
    local tile_info=""
    for _,val in pairs (map_tile) do
        tile_info=tile_info.._.."  ".. (type( val) ==type(true) and( val==true and "true" or "false"   )or val ).."\n"
    end
    
    
    debuger.off()
    
    return tile_info
end

function get_name_under_mouse()
    local names ={}
    local mouse_x ,mouse_y = floor(mouse_coords[1]/constants.tile_size),floor(mouse_coords[2]/constants.tile_size)
    for i,entity in ipairs(entities) do
        --print(entity.x,entity.y,floor(mouse_coords[1]/tile_size),floor(mouse_coords[2]/tile_size))
       if entity.x == mouse_x and entity.y == mouse_y then
          table.insert(names,entity.name:upper()) 
       end
    end
    
    --debug tile info
    --if mouse_x >0 and  mouse_x<constants.map_width and mouse_y>0 and mouse_y < constants.map_height then
    --   table.insert(names, get_tile_under_mouse(mouse_x,mouse_y))
    --end
    --print("------------------")
    return table.concat(names,", ")
end


function render_bar(name,x,y,width,value,max,bar_col,back_col,string_col,show_num)
  local bar_width = math.floor(value/max*width)
  local bar_start = x+love.graphics.getFont():getWidth(name) +10
  
  --love.graphics.setColor(string_col or colors.default)
  --love.graphics.print(name,x,y)
  
  print_colored(name,x,y,string_col)
  
  love.graphics.setColor(back_col)
  love.graphics.rectangle("fill",bar_start,y,width,constants.tile_size)
  love.graphics.setColor(bar_col)
  love.graphics.rectangle("fill",bar_start,y,bar_width,constants.tile_size)
  love.graphics.setColor(constants.colors.default)
  love.graphics.rectangle("line",bar_start,y,width,constants.tile_size)
  
end


function draw_entities()
  --sort with a halfway stable sort
    table.sort(entities,
        function (a,b) 
            r =false
            if a.render_order < b.render_order then
                r = true
            elseif a.render_order == b.render_order then
                if a.name<b.name then
                    r=true
                else
                    r=false
                end
            end
            return r
        end)
    
    for key,entity in pairs(entities) do
      draw_entity(entity)
    end
end


function draw_turn_infos(dungeon_level)
  love.graphics.rectangle("line",0,0,(constants.map_width+1)*10,(constants.map_height+1)*10)
    
    love.graphics.print(get_name_under_mouse(),0,0)
    
    --render_bar("hp: ",tile_size*3,(map_height+3)*tile_size,10*tile_size,player.fighter.hp,player.fighter.max_hp,colors.red,colors.dark_red)
    render_bar("hp: ",constants.tile_size*3,(constants.map_height+3)*constants.tile_size,
        10*constants.tile_size,player.fighter.hp,player.fighter:get_hp(),
        constants.colors.light_red,constants.colors.dark_red)
    
    
    --exp bar (?)
    render_bar("exp: ",
        constants.tile_size*3,
        (constants.map_height+5)*constants.tile_size,
        10*constants.tile_size,player.level.current_xp,player.level:expToNextLevel(),
        constants.colors.light_blue,constants.colors.blue)
    
    message_log:draw()
    
    love.graphics.print("Depth: "..dungeon_level,constants.tile_size*3,(constants.map_height+7)*constants.tile_size)
    --menue("This is a test header,it tests heading",{"blah","test","noch was","meh"},0,0,scr_width)
end


function draw_inventory()
  invi_menue("Press key next to item to use or ESC to exit",player.inventory,constants.tile_size*1,constants.tile_size*1,constants.tile_size*30,constants.scr_height -constants.tile_size*2)
  
  menue("Stats",{"Defense: "..player.fighter:get_def(),"Attack: "..player.fighter:get_power()},constants.tile_size*35,constants.tile_size*1,constants.tile_size*20,constants.tile_size*10)
  
  --equippment information
  
  slot_main = "Main hand"
  if player.equippment.main_hand ~= nil then
      off_info =player.equippment.main_hand.equippable
      
      slot_main=slot_main.."\n  Name: "..player.equippment.main_hand.name
      slot_main=slot_main.."\n  Power: "..off_info.power or 0
      slot_main=slot_main.."\n  Def: "..off_info.def or 0
      slot_main=slot_main.."\n  Hp: "..off_info.health or 0
      
  end
  
  slot_off = "\nOff hand:"
  if player.equippment.off_hand ~= nil then
      off_info =player.equippment.off_hand.equippable
      
      slot_off=slot_off.."\n  Name: "..player.equippment.off_hand.name
      slot_off=slot_off.."\n  Power: "..off_info.power or 0
      slot_off=slot_off.."\n  Def: "..off_info.def or 0
      slot_off=slot_off.."\n  Hp: "..off_info.health or 0
  end
  
  menue("Equipment",{slot_main.."\n"..slot_off} ,constants.tile_size*35,constants.tile_size*12,constants.tile_size*20,constants.tile_size*39)

end

function dummy_draw() end


--special state draws lu
local draw_state_specials ={
  [GameStates.SHOW_INVENTORY] = draw_inventory,
  
    mt={
     __index=function(table,key) 
      return  dummy_draw
     end
     
     }
  }
setmetatable(draw_state_specials,draw_state_specials.mt)



function render_all(entities,game_map,screen_width,screen_height)--could be adjusted to work without params,but lets see
    --console.clear()
    
    
    if show_main_menue ==true then
      main_menue()
      return
    end
    
    game_map:draw()
    
    draw_entities()
    
    --the bottom layer with hp,ep,level,log etc, also mouse under info
    draw_turn_infos(game_map.dungeon_level)
    
    
    
    draw_state_specials[game_state]()
    
    if game_state == GameStates.LEVEL_UP then
        local x_off = constants.scr_width/2 -constants.tile_size*10
        local y_off = constants.scr_height/2 -constants.tile_size*6.5
        level_up_menue("Select a state to increase:",x_off,y_off,constants.tile_size*20,constants.tile_size*13)
    end
    
    
    if game_state == GameStates.TARGETING then
      
      love.graphics.setColor(255,0,0)
      --love.graphics.rectangle("line",targeting_tile.x*tile_size,targeting_tile.y*tile_size,tile_size,tile_size)
      love.graphics.circle("line",targeting_tile.x*constants.tile_size +constants.tile_size/2,
          targeting_tile.y*constants.tile_size +constants.tile_size/2,
          (target_range or 1)*(constants.tile_size/2+1))
      love.graphics.setColor(255,0,0,75)
      love.graphics.circle("fill",targeting_tile.x*constants.tile_size +constants.tile_size/2,
          targeting_tile.y*constants.tile_size +constants.tile_size/2,
          (target_range or 1)*(constants.tile_size/2+1))

      
      love.graphics.setColor(constants.colors.default)
      
    end
    
    -- Draw a health bar for this entity, if it was attacked before
    if player.last_target ~= 0 then
        render_bar("enemy's hp:",
            (constants.scr_width)-20*constants.tile_size,
            (constants.map_height+3)*constants.tile_size,
            10*constants.tile_size,
            player.last_target.fighter.hp,
            player.last_target.fighter:get_hp(),
            constants.colors.desaturated_green,
            constants.colors.green
        )
            
    end
    

end

