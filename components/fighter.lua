Fighter = class_base:extend()

function Fighter:new(hp,defense,power)
    self.max_hp = hp
    self.hp = hp
    self.defense = defense
    self.power = power
end

function Fighter:take_damage(amount)
  local results={}
  self.hp = self.hp -amount
  
  
  
  if self.hp <=0 then
    table.insert(results,{dead=self.owner})
  end
  
  return results
end


function Fighter:attack(target)
    local results ={}
    local damage = self.power - target.fighter.defense
    
    if damage> 0 then
      
      results =target.fighter:take_damage(damage)
      msg =self.owner.name.." attacks "..target.name.." for "..damage.." hitpoints."
      table.insert(results,{message =msg})
    else
      msg =self.owner.name.." tries to attack "..target.name.." but misses!"
      table.insert(results,{message =msg})
    end
    return results
end

