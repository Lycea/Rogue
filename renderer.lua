RenderOrder = class_base:extend()
RenderOrder.CORPSE = 1
RenderOrder.ITEM = 2
RenderOrder.ACTOR = 3

local function draw_entity(entity)
    entity:draw()
end


function render_all(entities,game_map,screen_width,screen_height)--could be adjusted to work without params,but lets see
    --console.clear()
    game_map:draw()
    
    table.sort(entities,function (a,b) return a.render_order < b.render_order  end)
    for key,entity in pairs(entities) do
      draw_entity(entity)
    end
    
    love.graphics.print("HP: "..player.fighter.hp.."/"..player.fighter.max_hp,10,screen_height -2*10)
end

