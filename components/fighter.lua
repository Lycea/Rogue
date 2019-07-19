Fighter = class_base:extend()

function Fighter:new(hp,defense,power,xp_)
    self.max_hp = hp
    self.hp = hp
    self.defense = defense
    self.power = power
    self.xp = xp_ or 0
end

function Fighter:save()
    local txt = ""
    offset_push()
    for idx,value in pairs(self) do
        if type(value) ~= type(function () end) and type(value) ~= type({}) then
           txt = txt..add_offset()..'"'..idx..'"'..":"..value..",\n" 
        end
    end
    offset_pop()
    
    return txt
end

function Fighter:get_hp()
    if self.owner and self.owner.equipment then
        return self.max_hp + self.owner.equipment:get_hp_bonus()
    else
        return self.max_hp
    end
    
end

function Fighter:get_power()
    if self.owner and self.owner.equippment then
        return self.power + self.owner.equippment:get_power_bonus()
    else
        return self.power
    end
end

function Fighter:get_def()
    if self.owner and self.owner.equippment then
        return self.defense + self.owner.equippment:get_def_bonus()
    else
        return self.defense
    end
end



function Fighter:take_damage(amount)
  local results={}
  self.hp = self.hp -amount
  
  
  
  if self.hp <=0 then
    table.insert(results,{dead=self.owner,xp=self.xp})
  end
  
  return results
end


function Fighter:attack(target)
    local results ={}
    local damage = self:get_power() - target.fighter:get_def()
    
    if damage> 0 then
      msg =Message(self.owner.name.." attacks "..target.name.." for "..damage.." hitpoints.")
      table.insert(results,{message =msg})
      
      local dmg_result =target.fighter:take_damage(damage)
      if #dmg_result>0 then
        for idx,result in ipairs(dmg_result) do
          table.insert(results,result)
        end
      end
      
      
    else
      msg =Message(self.owner.name.." tries to attack "..target.name.." but misses!")
      table.insert(results,{message =msg})
    end
    return results
end


--increases the state giving in the parameter for 1 or a defined number
function Fighter:increase_state(state_name,number)
    number = number or 1
    self[state_name] = self[state_name] + number
end


function Fighter:heal(amount)
    self.hp = self.hp+amount
    if self.hp> self:get_hp() then
        self.hp  = self:get_hp()
    end
end

