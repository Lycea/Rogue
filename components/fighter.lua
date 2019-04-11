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
    local damage = self.power - target.fighter.defense
    
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


function Fighter:heal(amount)
    self.hp = self.hp+amount
    if self.hp> self.max_hp then
        self.hp  = self.max_hp
    end
end

