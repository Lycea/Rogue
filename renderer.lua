require("menue")

RenderOrder = class_base:extend()
RenderOrder.CORPSE = 1
RenderOrder.ITEM = 2
RenderOrder.ACTOR = 3




local function draw_entity(entity)
    entity:draw()
end


function get_name_under_mouse()
    local names ={}
    for i,entity in ipairs(entities) do
        --print(entity.x,entity.y,floor(mouse_coords[1]/tile_size),floor(mouse_coords[2]/tile_size))
       if entity.x == floor(mouse_coords[1]/constants.tile_size) and entity.y == floor(mouse_coords[2]/constants.tile_size) then
          table.insert(names,entity.name:upper()) 
       end
    end
    --print("------------------")
    return table.concat(names,", ")
end


local function render_bar(name,x,y,width,value,max,bar_col,back_col,string_col,show_num)
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



function render_all(entities,game_map,screen_width,screen_height)--could be adjusted to work without params,but lets see
    --console.clear()
    
    
    if show_main_menue ==true then
      main_menue()
      return
    end
    
    game_map:draw()
    
    
    
    table.sort(entities,function (a,b) return a.render_order < b.render_order  end)
    for key,entity in pairs(entities) do
      draw_entity(entity)
    end
    
    love.graphics.rectangle("line",0,0,(constants.map_width+1)*10,(constants.map_height+1)*10)
    
    love.graphics.print(get_name_under_mouse(),0,0)
    
    --render_bar("hp: ",tile_size*3,(map_height+3)*tile_size,10*tile_size,player.fighter.hp,player.fighter.max_hp,colors.red,colors.dark_red)
    render_bar("hp: ",constants.tile_size*3,(constants.map_height+3)*constants.tile_size,
        10*constants.tile_size,player.fighter.hp,player.fighter:get_hp(),
        constants.colors.light_red,constants.colors.dark_red)
    
    
    --exp bar (?)
    render_bar("exp: ",constants.tile_size*3,(constants.map_height+5)*constants.tile_size,
        10*constants.tile_size,player.level.current_xp,player.level:expToNextLevel(),
        constants.colors.light_blue,constants.colors.blue)
    
    message_log:draw()
    
    love.graphics.print("Depth: "..game_map.dungeon_level,constants.tile_size*3,(constants.map_height+7)*constants.tile_size)
    --menue("This is a test header,it tests heading",{"blah","test","noch was","meh"},0,0,scr_width)
    
    if game_state == GameStates.SHOW_INVENTORY then
        invi_menue("Press key next to item to use or ESC to exit",player.inventory,constants.tile_size*1,constants.tile_size*1,constants.tile_size*30,constants.scr_height -constants.tile_size*2)
    end
    
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
    

end

