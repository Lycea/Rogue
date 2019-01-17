

paths ={}
local queue={}
local pri_queue={}

if class_base ~= nil then
  paths = class_base:extend()
  queue = class_base:extend()
  pri_queue =class_base:extend()
end


function queue:new()
  self._data={}
  self.idx_first = 1
  self.idx_last = 0
  
  return self
end

function queue:push(item)
  self.idx_last =self.idx_last+1
  self._data[self.idx_last]=item
end

function queue:get()
  local data =self._data[self.idx_first]
  self._data[self.idx_first] =nil
  self.idx_first = self.idx_first +1
  return data
end

function queue:size()
  return self.idx_last-self.idx_first +1
end




local function queue_test()
  stest_list = queue:new()
  stest_list:push("first")
  print(stest_list:size())
  stest_list:push("second")
  print(stest_list:get())
  print(stest_list:get())
  print(stest_list:get())
end






function pri_queue:new()
    self._data={}--list with lists of the prioritues at these prios
    self._items=0
    return self
end

function pri_queue:insert(data,prio)
  if self._data[prio] == nil then
    self._data[prio] = queue()
  end
  
  self._data[prio]:push(data)
  self._items=self._items+1
end

function pri_queue:get()
  local min_prio = 30000000
  for k,v in pairs(self._data) do
    if k<min_prio then min_prio =k end
  end
  local item = self._data[min_prio]:get()
  
  --remove idx if nothing there anymore
  if self._data[min_prio]:size() ==0 then
    self._data[min_prio]=nil
  end
  
  self._items=self._items-1
  return item,min_prio
end

function pri_queue:size()
    return self._items
end


local function prio_test()
  local my_prio=pri_queue()
  start =love.timer.getTime()
  my_prio:insert("do tests",3.3)
  my_prio:insert("do tests",3)
  my_prio:insert("eat lunch",2.5)
  my_prio:insert("eat breakfast",1)
  my_prio:insert("tooooo irrellevant",500)

  
  
  while my_prio:size() >0 do 
    --print(my_prio:get())
    print(my_prio:get())
  end
end





--paths= {}
local function break_dummy(x,y) return false end
  
  
function paths:new()
  self.break_condition = break_dummy
end


--flood fill
function paths:gen_map_fill(map,start,goal)
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






function paths:setBlocked(blocker)
    self.break_condition = blocker
end



function paths:gen_map_breadth(start,goal)
  local frontier ={}
  local came_from ={}
  
  local index = 1--get index
  local max_idx =0--add index
  
  local steps = 0
  
  local end_found = false
  
  --loc_map=map
  
  setmetatable(came_from,{__index = function(t,key) return false end})
  came_from[start.y]={}
  came_from[start.y][start.x]=nil
  
  frontier[#frontier+1]={start.x,start.y}
  max_idx=max_idx+1
  
  while frontier[index] and end_found==false do
    --get current place
    local curr = frontier[index]
    --love.graphics.rectangle("fill",curr[1]*10,curr[2]*10,10,10)
    --love.graphics.present()
    
    --get_neighbours 
    local neigh={ {curr[1]+1,curr[2]},
                  {curr[1]-1,curr[2]},
                  {curr[1],curr[2]+1},
                  {curr[1],curr[2]-1},
                }
    --iterate the neighbours and add them if not visited
    for k,v in pairs(neigh) do
        
        
      if came_from[v[2]] == false then came_from[v[2]]={}end --fix hohles in the array
      if came_from[v[2]][v[1]] == nil and self.break_condition(v[1],v[2]) == false then
        
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
    return nil  
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

    
  local function my_block(x,y)
    --print(x,y)
    --print(loc_map[y][x])
    return loc_map[y][x].blocked
  end

  paths.setBlocked(my_block)
  --test normal reachable goal
  print("\n\nTest1")
  paths.gen_map_breadth(map_,{x=3,y=3},{x=30,y=30})
  --test some goal out of bounds
  print("\n\nTest2")
  paths.gen_map_breadth(map_,{x=3,y=3},{x=60,y=60})
end




  
  
--https://rosettacode.org/wiki/Priority_queue#Lua