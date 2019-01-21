RenderOrder = class_base:extend()
RenderOrder.CORPSE = 1
RenderOrder.ITEM = 2
RenderOrder.ACTOR = 3




local function draw_entity(entity)
    entity:draw()
end


local function render_bar(name,x,y,width,value,max,bar_col,back_col,string_col,show_num)
  local bar_width = math.floor(value/max*width)
  local bar_start = x+love.graphics.getFont():getWidth(name) +10
  
  --love.graphics.setColor(string_col or colors.default)
  --love.graphics.print(name,x,y)
  
  print_colored(name,x,y,string_col)
  
  love.graphics.setColor(back_col)
  love.graphics.rectangle("fill",bar_start,y,width,tile_size)
  love.graphics.setColor(bar_col)
  love.graphics.rectangle("fill",bar_start,y,bar_width,tile_size)
  love.graphics.setColor(colors.default)
  love.graphics.rectangle("line",bar_start,y,width,tile_size)
  
end



function render_all(entities,game_map,screen_width,screen_height)--could be adjusted to work without params,but lets see
    --console.clear()
    game_map:draw()
    
    table.sort(entities,function (a,b) return a.render_order < b.render_order  end)
    for key,entity in pairs(entities) do
      draw_entity(entity)
    end
    
    love.graphics.rectangle("line",0,0,(map_width+1)*10,(map_height+1)*10)
    --love.graphics.print("HP: "..player.fighter.hp.."/"..player.fighter.max_hp,10,screen_height -2*10)
    
    --render_bar("hp: ",tile_size*3,(map_height+3)*tile_size,10*tile_size,player.fighter.hp,player.fighter.max_hp,colors.red,colors.dark_red)
    render_bar("hp: ",tile_size*3,(map_height+3)*tile_size,10*tile_size,player.fighter.hp,player.fighter.max_hp,colors.light_red,colors.dark_red)
end

