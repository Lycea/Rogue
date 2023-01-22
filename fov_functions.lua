local fov_functions ={}

local lines_= 8
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


local function distance(self ,other)
  local dx = other.x-self.x
  local dy = other.y-self.y
  return math.sqrt(math.pow(dx,2)+math.pow(dy,2))
end


local vec = class_base:extend()

function vec:new(x,y)
  self.x=x
  self.y=y
end


local oct_dirs ={
  x={ vec(1, 0), vec(0, 1),
      vec(0, -1), vec(-1, 0), 
      vec(-1, 0), vec(0, -1),
      vec(0, 1), vec(1, 0) },

  y={vec(0, 1), vec(1, 0),
     vec(1, 0), vec(0, 1), 
		 vec(0, -1), vec(-1, 0),
    vec(-1, 0), vec(0, -1) }
}


local function cast_light(center, radius, row,
                           start_slope, end_slope, x,y, disable )
  -- check for octant completion
  if start_slope <end_slope then return end

  --start at start and will go towards end
  local next_start_slope = start_slope

  --square rad
  local radius2 = radius * radius

  --iterate the rows
  for distance = row, radius do
    blocked = false
    
    --iterate the tiles
    for delta_x = -distance, 0 do
      local do_nothing = false

      local delta_y = -distance

      local l_slope = (delta_x - 0.5) /(delta_y +0.5)
      local r_slope = (delta_x + 0.5) /(delta_y -0.5)

      if start_slope <r_slope then  
        do_nothing = true 
      else

        if end_slope > l_slope then break end

        local current_pos = vec(delta_x * x.x + delta_y * x.y,
                                delta_x * y.x + delta_y * y.y )
        
        --check out of map
        if (current_pos.x < 0 and math.abs(current_pos.x) > center.x)  or 
          (current_pos.y < 0 and math.abs(current_pos.y) > center.y) then
          
          do_nothing = true
        else

          local map_position = vec(center.x + current_pos.x, center.y +current_pos.y)
          local current_distance = delta_x*delta_x + delta_y*delta_y
          
          --current tile is in view distance
          if current_distance <radius2 then
            fov_map[map_position.y][map_position.x] = true
          end

          -- previous blocked light
          if blocked then
            if act_map.tiles[map_position.y][map_position.x].block_sight then
              next_start_slope = r_slope
            else
              blocked = false
              start_slope = next_start_slope
            end
          elseif act_map.tiles[map_position.y][map_position.x].block_sight then 
            blocked = true
            next_start_slope = r_slope
            cast_light(center, radius, distance +1,
                       start_slope, l_slope, x, y, disable)
          end
        end
      end

    end

    if blocked then 
      break
    end
  end


end


local function gen_fov()
  local start_pos = gvar.player
  fov_map[start_pos.y][start_pos.x]=true

  for oct_idx = 1, 8 do
    cast_light(start_pos, gvar.constants.fov_radius, 1, 1,0, oct_dirs.x[oct_idx], oct_dirs.y[oct_idx], false)
  end
end


local function init_fov_map()
  for y=1,gvar.constants.map_height do
    fov_map[y]={}
    for x=1,gvar.constants.map_width do
      fov_map[y][x]=false
    end
  end
end

function fov_functions.compute_fov(map)
  act_map = map
  
  init_fov_map()
  gen_fov()
  return fov_map
end


return fov_functions
