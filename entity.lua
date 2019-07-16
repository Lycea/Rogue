Entity =class_base:extend()



function get_blocking_entitis_at_location(destin_x,destin_y)
  for k,entity in pairs(entities) do
    if entity.x == destin_x and entity.y == destin_y and entity.name ~= "Player"  and entity.blocks == true then
      return entity
    end
  end
  return nil
end

--import pather , import after helper,it may need it
--print(...)
local BASE= ...
local idx =string.find(BASE,"entity")
BASE =BASE:sub(0,idx -1)

require(BASE.."components.paths")


local base_pathmaker = paths()
paths:setBlocked(
    function(x,y)
      if map:is_blocked(x,y) == false and get_blocking_entitis_at_location(x,y)==nil then
        return false
      else
        return true
      end
    end
    )


function Entity:save()
    local txt =""
    
    offset_push()
    local pos =add_offset()..'"x":'..self.x..",\n"..add_offset()..'"y":'..self.y..",\n"
    local color = add_offset()..'"color":"'..self.color..'",\n'
    
    local name = add_offset()..'"name":"'..self.name..'",\n'
    local blocks = self.blocks==true and '"blocks": true,\n' or '"blocks": false,\n'
          blocks = add_offset()..blocks
    
    
    local tmp_string_list ={}
    
    local fighter = ""
    if self.fighter ~= nil then
        fighter =add_offset()..'"fighter":{\n'..self.fighter:save()..add_offset().."}\n"
        table.insert(tmp_string_list,fighter)
    end
    
    local ai = ""
    if self.ai ~= nil then
        ai=add_offset()..'"ai":{\n'..self.ai:save().."\n"..add_offset().."}\n"
        table.insert(tmp_string_list,ai)
    end
    
    local item = ""
    local item_txt =""
    
    if self.item ~=nil then
        --item =add_offset().."item:{\n"..self.item:save()..add_offset().."},\n"--self.item:save()..add_offset().."}\n"
        item_txt =self.item:save()--self.item:save()..add_offset().."}\n"
        item =add_offset()..'"item":{\n'..item_txt..add_offset().."}\n"
        table.insert(tmp_string_list,item)
    end
    
    
    local inventory = ""
    if self.inventory~= nil then
        inventory=add_offset()..'"inventory":{\n'..self.inventory:save()..add_offset().."}\n"
        table.insert(tmp_string_list,inventory)
    end 
    
    local stairs_ = ""
    if self.stairs_ ~= nil then
        stairs_ = add_offset()..'"stairs":{\n'..self.stairs_:save()..add_offset().."}\n"
        table.insert(tmp_string_list,stairs_)
    end
    

    local level =""
    if self.level ~= nil then
        level=add_offset()..'"level":{\n'..self.level:save()..add_offset().."}\n"
        table.insert(tmp_string_list,level)
    end
  
    
    local equippment_ =""
    if self.equippment ~= nil then
        print("saving equippment...")
        equippment_=add_offset()..'"equippment":{\n'..self.equippment:save()..add_offset().."}\n"
        table.insert(tmp_string_list,equippment_)
    end
    
    local equippable_ =""
    if self.equippable ~= nil then
        equippable_=add_offset()..'"equippable":{\n'..self.equippable:save()..add_offset().."}\n"
        table.insert(tmp_string_list,equippable_)
    end
    
    local render_order = add_offset()..'"render_order":'..self.render_order.."\n"
    
    txt = pos..color..name..blocks..table.concat(tmp_string_list,",\n")
    
    if #tmp_string_list>0 then
       txt = txt.."," 
    end
    txt = txt..render_order
    
    offset_pop()
    return txt
end



function Entity:new(x,y,tile,color,name,blocks,fighter,ai,render_order,item,inventory,stairs_,level_,equippment,equippable)
    self.x = x
    self.y = y
    
    self.tile = tile
    self.color = color
    
    self.name = name
    self.blocks  = blocks or false
    self.fighter = fighter 
    self.ai = ai
    
    self.render_order = render_order
    
    self.item = item or nil
    self.inventory = inventory or nil
    
    self.stairs_ = stairs_ or nil
    self.level = level_ or nil
    
    self.equippment = equippment or nil
    self.equippable = equippable or nil
    
    --set the parent to access it in the module
    if self.fighter then
      self.fighter.owner = self
    end
    
    if self.ai then
      self.ai.owner = self
    end
    
    if self.item then
        self.item.owner = self
    end
    
    if self.inventory then
       self.inventory.owner = self 
    end
    
    if self.stairs_ then
        self.stairs_.owner = self
    end
    
    if self.level then
      self.level.owner = self
    end
    
 
    
    if self.equippment then
        self.equippment.owner = self
    end
    
    
    
    if self.equippable then
        self.equippable.owner = self
        
        if not self.item then
            item = Item()
            self.item = item
            self.item.owner = self
        end
    end
   
end




function Entity:move(dx,dy)
    self.x = self.x+dx
    self.y = self.y+dy
end

function Entity:move_to(dx,dy)
    self.x = dx
    self.y = dy
end


function Entity:move_towards4(target_x,target_y)
  local dx = target_x - self.x
  local dy = target_y - self.y
  
  local distance = math.sqrt(dx^2+dy^2)
  
  dx =math.floor(dx/distance+0.5)
  dy =math.floor(dy/distance+0.5)
  
  --console.print(dx.." "..dy)
  if  map:is_blocked(self.x+dx,self.y+dy)==false and
      get_blocking_entitis_at_location(self.x+dx,self.y+dy)==nil then
      self:move(dx,dy)
  end
end


function Entity:move_breadth(target)
  local tmp_path =paths:gen_map_breadth(self,target)
  if tmp_path then
    self:move_to(tmp_path[1][1],tmp_path[1][2])
  else
    self:move_towards4(target.x,target.y)
  end
end






function Entity:move_towards8(target_x,target_y)
  local dx = target_x - self.x
  local dy = target_y - self.y
  
  local distance = math.sqrt(dx^2+dy^2)
  
  dx =math.floor(dx/distance)
  dy =math.floor(dy/distance)
  
  if  map:is_blocked(self.x+dx,self.y+dy)==false and
      get_blocking_entitis_at_location(self.x+dx,self.y+dy)==nil then
        
      self:move(dx,dy)
  end
end


function Entity:angle_to(other)
    return math.deg( math.atan(other.y-self.y,other.y-self.x))
end


function Entity:distance_to(other)
   local dx = other.x-self.x
   local dy = other.y-self.y
   return math.sqrt(math.pow(dx,2)+math.pow(dy,2))
end

function Entity:distance(x,y)
    return self:distance_to({x=x,y=y})
end


function Entity:draw()
  if fov_map[self.y][self.x]==true then
    
    love.graphics.setColor( constants.colors[self.color] or {255,0,0})
    love.graphics.rectangle("fill",self.x*constants.tile_size,
        self.y*constants.tile_size,constants.tile_size,constants.tile_size)
    love.graphics.setColor(constants.colors.default)
  end
end


