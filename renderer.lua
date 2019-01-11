local function draw_entity(entity)
    entity:draw()
end


function render_all(entities,game_map,screen_width,screen_height)--could be adjusted to work without params,but lets see
    --console.clear()
    camera:set()
    game_map:draw()
    
    --scompute_fov(map)
    
    for key,entity in pairs(entities) do
      if entity.name=="Player" then
        camera:unset()
        local tmp_x,tmp_y = player.x,player.y
        player.x = math.floor((screen_width/2-tile_size)/tile_size)
        player.y = math.floor((screen_height/2-tile_size)/tile_size)
        
        entity:draw()
        
        love.graphics.rectangle("fill",player.x*tile_size,player.y*tile_size,tile_size,tile_size)
        
        player.x = tmp_x
        player.y = tmp_y
        camera:set()
      else
        draw_entity(entity)
      end
    end
    camera:unset()
end

