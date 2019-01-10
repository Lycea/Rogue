local function draw_entity(entity)
    entity:draw()
end


function render_all(entities,game_map,screen_width,screen_height)--could be adjusted to work without params,but lets see
    console.clear()
    game_map:draw()
    
    for key,entity in pairs(entities) do
      draw_entity(entity)
    end
end

