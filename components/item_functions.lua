

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
        table.insert(results,{consumed = true,message=Message(entity.name.." healed by "..amount,colors.green)})
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
    table.insert(results,target.fighter:take_damage(dmg))
  end
  
  return results
  
  
end
