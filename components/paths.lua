
--paths = class_base:extend()

paths= {}

--flood fill
function paths.gen_map_fill(map,start,goal)
  local frontier ={}
  local visited ={}
  
  local index = 1--get index
  local max_idx =0--add index
  
  local steps = 0
  
  setmetatable(visited,{__index = function(t,key) return false end})
  visited[start.y]={}
  visited[start.y][start.x]=true
  
  frontier[#frontier+1]={start.x,start.y}
  max_idx=max_idx+1
  
  while frontier[index] do
    --get current place
    local curr = frontier[index]
    --get_neighbours 
    local neigh={ {curr[1]+1,curr[2]},
                  {curr[1]-1,curr[2]},
                  {curr[1],curr[2]+1},
                  {curr[1],curr[2]-1},
                }
    --iterate the neighbours and add them if not visited
    for k,v in pairs(neigh) do
      
      if visited[v[2]] == false then visited[v[2]]={}end --fix hohles in the array
      if visited[v[2]][v[1]] == nil and map[v[2]][v[1]].blocked == false then
         frontier[max_idx+1]=v
         visited[v[2]][v[1]] = true
         
         max_idx=max_idx+1
      end
    end
    if frontier[index][2] == goal.y and frontier[index][1] == goal.y then
      print("Found end "..steps)
      break
    end
    
    --increment the queue index
    frontier[index]=nil
    index = index+1
    steps = steps+1
  end
end




local function break_dummy()end
local break_condition =break_dummy


function paths.gen_map_breadth(map,start,goal)
  local frontier ={}
  local came_from ={}
  
  local index = 1--get index
  local max_idx =0--add index
  
  local steps = 0
  
  local end_found = false
  
  setmetatable(came_from,{__index = function(t,key) return false end})
  came_from[start.y]={}
  came_from[start.y][start.x]=nil
  
  frontier[#frontier+1]={start.x,start.y}
  max_idx=max_idx+1
  
  while frontier[index] and end_found==false do
    --get current place
    local curr = frontier[index]
    --get_neighbours 
    local neigh={ {curr[1]+1,curr[2]},
                  {curr[1]-1,curr[2]},
                  {curr[1],curr[2]+1},
                  {curr[1],curr[2]-1},
                }
    --iterate the neighbours and add them if not visited
    for k,v in pairs(neigh) do
      
      if came_from[v[2]] == false then came_from[v[2]]={}end --fix hohles in the array
      if came_from[v[2]][v[1]] == nil and map[v[2]][v[1]].blocked == false then
        
         came_from[v[2]][v[1]] = {frontier[index][1],frontier[index][2]}--true
          if v[2] == goal.y and v[1] == goal.x then
            print("Found end "..steps)
            end_found = true
            break
          end
        
         frontier[max_idx+1]=v
         
         
         max_idx=max_idx+1
      end
    end

    
    --increment the queue index
    frontier[index]=nil
    index = index+1
    steps = steps+1
  end
  print(steps)
  
  
  local path = {}
  
  if end_found == false then
    print("no way found")
    return path  
  end
  
  
  --retrac the way and return it 
  steps = 0
 
  table.insert(path,1,{goal.x,goal.y})
  local step = {goal.x,goal.y}
  

  
  
  while true do
    step = came_from[step[2]][step[1]]
    if step == nil or( step[1] == start.x and step[2] == start.y)then
      break
    end
    steps = steps+1
    table.insert(path,1,step)
  end
  print("Steps to goal: "..steps)
  print("First step: "..path[1][1].." "..path[1][2])  
  return path
end



local function test()
  
  
local map_={}
local map_w=50
local map_h=50

for i=1,map_h do
  map_[i]={}
  for j=1,map_w do
      if i== 1 or j == 1 or i==map_h or j==map_w then
        map_[i][j]={blocked = true}
      else
        map_[i][j]={blocked = false}
      end
  end
end

  

--test normal reachable goal
print("\n\nTest1")
paths.gen_map_breadth(map_,{x=3,y=3},{x=30,y=30})
--test some goal out of bounds
print("\n\nTest2")
paths.gen_map_breadth(map_,{x=3,y=3},{x=60,y=60})

end



test()
  
  
--https://rosettacode.org/wiki/Priority_queue#Lua