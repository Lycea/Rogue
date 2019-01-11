

local lines_= 8*10
local angle = 360/lines_
local act_map

local fov_map ={}
local function lerp_(x,y,t) local num = x+t*(y-x)return num end


local function lerp_point(x1,y1,x2,y2,t)
  local x = lerp_(x1,x2,t)
  local y = lerp_(y1,y2,t)
  --print(x.." "..y)
  return x,y
end



local function trace_line(ex,ey)
  for i=0,fov_radius do
    local perc =i/fov_radius
    local x,y=lerp_point(player.x,player.y,ex,ey,perc)
    x=math.floor(x+0.5)
    y=math.floor(y+0.5)
    
    fov_map[y][x]=true
    
    if act_map.tiles[y][x].block_sight == true then
      break
    end
    --love.graphics.rectangle("fill",x*tile_size,y*tile_size,tile_size,tile_size)
  end
end

local function gen_lines()
  
  for x=0,lines_ do
    --calculate end point
    local line_ang = x*angle
    
    local end_x = fov_radius *math.sin(math.rad(line_ang))+player.x
    local end_y = fov_radius *math.cos(math.rad(line_ang))+player.y
    --love.graphics.line(player.x*tile_size,player.y*tile_size,end_x*tile_size,end_y*tile_size)
    trace_line(end_x,end_y)
  end
end


local function init_fov_map()
  for y=1,map_height do
    fov_map[y]={}
    for x=1,map_width do
      fov_map[y][x]=false
    end
  end
end

function compute_fov(map)
  act_map = map
  init_fov_map()
  gen_lines()
  return fov_map
end
