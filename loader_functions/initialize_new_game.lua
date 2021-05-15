
local init_functions ={}


function init_functions.get_game_variables()
  local entities ={}
  
  gvar.constants.message_width = gvar.constants.scr_width-gvar.constants.message_x
  gvar.constants.message_height = 6

  local message_log = glib.msg_renderer.MessageLog(gvar.constants.message_x,gvar.constants.message_width,gvar.constants.message_height)
  --math.randomseed(love.math.getRandomSeed())
    
    
  --fight stuff /stat stuff that makes a player a player
  local stats_ = glib.Fighter(45,2,5,0)
  local invi_ = glib.inventory.Inventory(26)
  
  local equipment_component =glib.equipment()
  --final init
  local player = glib.Entity( math.floor(20),math.floor(20),0,"default","Player",true,stats_,nil,glib.renderer.RenderOrder.ACTOR,nil,invi_,nil,glib.Level(nil,0,20),equipment_component)
  player.last_target = 0
  table.insert(entities,player)
  

  
  return player,entities,message_log
end

function init_functions.init_map()
 --init map
  gvar.entities ={}
  
  table.insert(gvar.entities,gvar.player)
  local level = 0
  if gvar.map.dungeon_level then
      level = gvar.map.dungeon_level
  end
  

  
  
  local map = glib.map_generator(gvar.constants.map_width,gvar.constants.map_height,false,level+1)
  local fov_map=glib.fov_functions.compute_fov(map)
  print("Player_x:"..gvar.player.x)
  print("Player_y:"..gvar.player.y)
  
  
  
  return map,fov_map
end


function init_functions.get_constants()
    local window_title = "DungeonGame"
    
    local scr_width ,scr_height= love.graphics.getDimensions()
    
    local colors ={
      window_title = window_title,
          --room colors
      dark_wall = {0,0,100},
      dark_ground ={50,50,150},
      light_wall = {130,110,50},
      light_ground = {200,180,50},
      --some more
      desaturated_green= {63, 127, 63},
      darker_green= {0, 127, 0},
      
      dark_red ={191, 0, 0},
      red ={255, 0, 0},
      light_red ={255,114,114},
      orange = {255,127,0},
      
      white ={255,255,255},
      black ={0,0,0},
      default ={255,255,255},
      
      violet ={127,0,255},
      yellow={255,255,0},
      blue = {0,0,255},
      light_blue ={30,144,255},
      green = {0,255,0}
    }
    
    
    local constants ={
        scr_width=scr_width,
        scr_height = scr_height,
        tile_size = 10,
        
        colors = colors,
        --map settings
        map_width  = 80,
        map_height = 50,
        
        room_max_size =10,
        room_min_size =6,
        max_rooms =20,
        
        --fov settings
        fov_light_walls = true,
        fov_radius = 10,
        
        --log info
        message_x = 35,
        message_width =12,
        message_height = 5,
        
    }
    
    
    return constants
end


return init_functions
