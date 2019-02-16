function get_constants()
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
        message_x = 40,
        message_width =12,
        message_height = 5,
        
    }
    
    
    return constants
end
