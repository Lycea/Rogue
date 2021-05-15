local menues = require("menue")

local renderer ={}
renderer.RenderOrder = class_base:extend()

renderer.RenderOrder.CORPSE = 1
renderer.RenderOrder.ITEM = 2
renderer.RenderOrder.ACTOR = 3
renderer.RenderOrder.DEFAULT = renderer.RenderOrder.CORPSE




local function draw_entity(entity)
    entity:draw()
end


function recursive_print(table,level,par)
  local offset = level or 0
  
  for key,val in pairs(table) do
    if type(val) == type({}) then
      print(string.rep(" ",offset)..key..":")
      
      if val == par then
        --print(string.rep(" ",offset).."circlic dep... ignoring")
        
      else
        recursive_print(val,offset+1,table)
      end
      
    else
      print(string.rep(" ",offset)..key..":   "..(type( val) ==type(true) and( val==true and "true" or "false"   )or val ))
      --tile_info=tile_info.._.."  ".. (type( val) ==type(true) and( val==true and "true" or "false"   )or val ).."\n"
    end
    
  end
end


local function get_mob_under_mouse(x,y)
    local entity_to_get = nil
   
    for idx,entity in pairs(gvar.entities) do
      if entity.x == x and entity.y == y then
        entity_to_get = entity
      end
    end
    debuger.on()
    if entity_to_get ~= nil then
      recursive_print(entity_to_get,4)
      print("------")
    end
    debuger.off()
end

local function get_tile_under_mouse(x,y)
    
    debuger.on()
    local map_tile = gvar.map.tiles[y][x] 
    local fov_tile = gvar.fov_map[y][x]
    
    local tile_info=""
    for _,val in pairs (map_tile) do
        tile_info=tile_info.._.."  ".. (type( val) ==type(true) and( val==true and "true" or "false"   )or val ).."\n"
    end
    
    
    debuger.off()
    
    return tile_info
end

function renderer.get_name_under_mouse()
    local names ={}
    local mouse_x ,mouse_y = floor(gvar.mouse_coords[1]/gvar.constants.tile_size),floor(gvar.mouse_coords[2]/gvar.constants.tile_size)
    for i,entity in ipairs(gvar.entities) do
        --print(entity.x,entity.y,floor(mouse_coords[1]/tile_size),floor(mouse_coords[2]/tile_size))
       if entity.x == mouse_x and entity.y == mouse_y then
          table.insert(names,entity.name:upper()) 
       end
    end
    
    
    --debug tile info
    if mouse_x >0 and  mouse_x<gvar.constants.map_width and mouse_y>0 and mouse_y < gvar.constants.map_height then
       --table.insert(names, get_tile_under_mouse(mouse_x,mouse_y))
       
       if gvar.clicked == true then
          get_mob_under_mouse(mouse_x,mouse_y)
          gvar.clicked = false
       end
    end
    --print("------------------")
    return table.concat(names,", ")
end


function renderer.render_bar(name,x,y,width,value,max,bar_col,back_col,string_col,show_num)
  local bar_width = math.floor(value/max*width)
  local bar_start = x+love.graphics.getFont():getWidth(name) +10
  
  --love.graphics.setColor(string_col or colors.default)
  --love.graphics.print(name,x,y)
  
  glib.msg_renderer.MessageLog.print_colored(name,x,y,string_col)
  
  love.graphics.setColor(back_col)
  love.graphics.rectangle("fill",bar_start,y,width,gvar.constants.tile_size)
  love.graphics.setColor(bar_col)
  love.graphics.rectangle("fill",bar_start,y,bar_width,gvar.constants.tile_size)
  love.graphics.setColor(gvar.constants.colors.default)
  love.graphics.rectangle("line",bar_start,y,width,gvar.constants.tile_size)
  
end


function renderer.draw_entities()
  --sort with a halfway stable sort
    table.sort(gvar.entities,
        function (a,b) 
            local r =false
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
    
    for key,entity in pairs(gvar.entities) do
      draw_entity(entity)
    end
end


function renderer.draw_turn_infos(dungeon_level)
  love.graphics.rectangle("line",0,0,(gvar.constants.map_width+1)*10,(gvar.constants.map_height+1)*10)
    
    love.graphics.print(renderer.get_name_under_mouse(),0,0)
    
    --render_bar("hp: ",tile_size*3,(map_height+3)*tile_size,10*tile_size,player.fighter.hp,player.fighter.max_hp,colors.red,colors.dark_red)
    renderer.render_bar("hp: ",gvar.constants.tile_size*3,(gvar.constants.map_height+3)*gvar.constants.tile_size,
        10*gvar.constants.tile_size,gvar.player.fighter.hp,gvar.player.fighter:get_hp(),
        gvar.constants.colors.light_red,gvar.constants.colors.dark_red)
    
    
    --exp bar (?)
    renderer.render_bar("exp: ",
        gvar.constants.tile_size*3,
        (gvar.constants.map_height+5)*gvar.constants.tile_size,
        10*gvar.constants.tile_size,gvar.player.level.current_xp,gvar.player.level:expToNextLevel(),
        gvar.constants.colors.light_blue,gvar.constants.colors.blue)
    
    gvar.message_log:draw()
    
    love.graphics.print("Depth: "..dungeon_level,gvar.constants.tile_size*3,(gvar.constants.map_height+7)*gvar.constants.tile_size)
    --menue("This is a test header,it tests heading",{"blah","test","noch was","meh"},0,0,scr_width)
end


function renderer.draw_inventory()
  menues.invi_menue("Press key next to item to use or ESC to exit",gvar.player.inventory,gvar.constants.tile_size*1,gvar.constants.tile_size*1,gvar.constants.tile_size*30,gvar.constants.scr_height -gvar.constants.tile_size*2)
  
  menues.menue("Stats",{"Defense: "..gvar.player.fighter:get_def(),"Attack: "..gvar.player.fighter:get_power()},gvar.constants.tile_size*35,gvar.constants.tile_size*1,gvar.constants.tile_size*20,gvar.constants.tile_size*10)
  
  --equippment information
  
  local slot_main = "Main hand"
  if gvar.player.equippment.main_hand ~= nil then
      local off_info =gvar.player.equippment.main_hand.equippable
      
      slot_main=slot_main.."\n  Name: "..gvar.player.equippment.main_hand.name
      slot_main=slot_main.."\n  Power: "..off_info.power or 0
      slot_main=slot_main.."\n  Def: "..off_info.def or 0
      slot_main=slot_main.."\n  Hp: "..off_info.health or 0
      
  end
  
  local slot_off = "\nOff hand:"
  if gvar.player.equippment.off_hand ~= nil then
      local off_info =gvar.player.equippment.off_hand.equippable
      
      slot_off=slot_off.."\n  Name: "..gvar.player.equippment.off_hand.name
      slot_off=slot_off.."\n  Power: "..off_info.power or 0
      slot_off=slot_off.."\n  Def: "..off_info.def or 0
      slot_off=slot_off.."\n  Hp: "..off_info.health or 0
  end
  
  menues.menue("Equipment",{slot_main.."\n"..slot_off} ,gvar.constants.tile_size*35,gvar.constants.tile_size*12,gvar.constants.tile_size*20,gvar.constants.tile_size*39)

end

function renderer.dummy_draw() end


--special state draws lu
local draw_state_specials ={

  }



function renderer.init()
    draw_state_specials={[glib.GameStates.SHOW_INVENTORY] = renderer.draw_inventory,
  
            mt={
             __index=function(table,key) 
              return  renderer.dummy_draw
             end
             
                }
    }  
 
 setmetatable(draw_state_specials,draw_state_specials.mt)
end

function renderer.render_all(entities,game_map,screen_width,screen_height)--could be adjusted to work without params,but lets see
    --console.clear()
    
    
    if gvar.show_main_menue ==true then
      menues.main_menue()
      return
    end
    
    game_map:draw()
    
    renderer.draw_entities()
    
    --the bottom layer with hp,ep,level,log etc, also mouse under info
    renderer.draw_turn_infos(game_map.dungeon_level)
    
    
    
    draw_state_specials[gvar.game_state]()
    
    if gvar.game_state == glib.GameStates.LEVEL_UP then
        local x_off = gvar.constants.scr_width/2 -gvar.constants.tile_size*10
        local y_off = gvar.constants.scr_height/2 -gvar.constants.tile_size*6.5
        menues.level_up_menue("Select a state to increase:",x_off,y_off,gvar.constants.tile_size*20,gvar.constants.tile_size*13)
    end
    
    
    if gvar.game_state == glib.GameStates.TARGETING then
      
      love.graphics.setColor(255,0,0)
      --love.graphics.rectangle("line",targeting_tile.x*tile_size,targeting_tile.y*tile_size,tile_size,tile_size)
      love.graphics.circle("line",gvar.targeting_tile.x*gvar.constants.tile_size +gvar.constants.tile_size/2,
          gvar.targeting_tile.y*gvar.constants.tile_size +gvar.constants.tile_size/2,
          (gvar.target_range or 1)*(gvar.constants.tile_size/2+1))
      love.graphics.setColor(255,0,0,75)
      love.graphics.circle("fill",gvar.targeting_tile.x*gvar.constants.tile_size +gvar.constants.tile_size/2,
          gvar.targeting_tile.y*gvar.constants.tile_size +gvar.constants.tile_size/2,
          (gvar.target_range or 1)*(gvar.constants.tile_size/2+1))

      
      love.graphics.setColor(gvar.constants.colors.default)
      
    end
    
    -- Draw a health bar for this entity, if it was attacked before
    if gvar.player.last_target ~= 0 then
        renderer.render_bar("enemy's hp:",
            (gvar.constants.scr_width)-20*gvar.constants.tile_size,
            (gvar.constants.map_height+3)*gvar.constants.tile_size,
            10*gvar.constants.tile_size,
            gvar.player.last_target.fighter.hp,
            gvar.player.last_target.fighter:get_hp(),
            gvar.constants.colors.desaturated_green,
            gvar.constants.colors.green
        )
            
    end
    

end

return renderer
