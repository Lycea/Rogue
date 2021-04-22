

item_function={}

function item_function.heal(args,kwargs)
    local entity = args
    --local colors = args[1]
    local amount = kwargs["amount"]
    
    local results ={}
    if entity.fighter.hp == entity.fighter.max_hp then
        table.insert(results,{consumed =false,message =Message("HP max no need to heal")})
    else
        entity.fighter:heal(amount)
        table.insert(results,{consumed = true,message=Message(entity.name.." healed by "..amount,constants.colors.green)})
    end
    
    return results
end



function item_function.cast_lightning(args,kwargs)
  local results   = {}
  
  --get the parameters
  local caster    = args
  local dmg       = kwargs["damage"]
  local entities  = kwargs["entities"]
  local max_range = kwargs["max_range"]
  
  local target = nil
  local closest_distance = max_range +1
  
  for idx,entity in ipairs(entities) do
    if entity.fighter ~= nil and entity ~= caster and fov_map[entity.y][entity.x] == true then
      local distance = caster:distance_to(entity)
      if distance < closest_distance then
        target = entity
        closest_distance = distance
      end
    end
  end
  
  if target ~= nil then
    table.insert(results,{consumed = true,message = Message("The "..target.name.." was hit with lightning")})
    table.insert(results,target.fighter:take_damage(dmg)[1])
  end
  
  target_radius = 1
  return results
  
  
end



function item_function.cast_fireball(args,kwargs)
    local results ={}
    
    --get variables
    local entities = kwargs["entities"]
    local dmg = kwargs["damage"]
    local radius = kwargs["radius"]
    local target_x = kwargs["target_x"]
    local target_y = kwargs["target_y"]
    
   
    
    if fov_map[target_y][target_x] == false then
        results ={message=Message("You cannot target a tile out of range!",constants.colors.red)}
        return results
    end
    
    table.insert(results,{consumed = true,message =Message("The fireball explodes and burns everything in "..radius.." tiles!!",constants.colors.orange)})
    
    for idx,entity in ipairs(entities) do
        if entity:distance(target_x,target_y) <= radius and entity.fighter then
            table.insert(results,{message = Message("The "..entity.name.." gets burned")})
            table.insert(results,entity.fighter:take_damage(dmg))
        end
    end
    target_radius = 1
    return results
end


function item_function.cast_confuse(args,kwargs)
    local results = {}
    
    local entities = kwargs["entities"]
    local target_x = kwargs["target_x"]
    local target_y = kwargs["target_y"]
    
    if fov_map[target_y][target_x] == false then
        results ={message=Message("You cannot target a tile out of range!",constants.colors.red)}
        return results
    end
    
    
    for idx,entity in  ipairs(entities) do
        if entity.x == target_x and entity.y == target_y then
           confused_ai = ConfusedMonster(entity.ai,math.random(0,20))
           
           confused_ai.owner =entity
           entity.ai = confused_ai
           
           table.insert(results,{consumed = true, message=Message("The "..entity.name.." looks confused!",constants.colors.green)})
           return results
        end
    end
    
    
    return {}
    
end

