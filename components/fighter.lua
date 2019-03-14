Fighter = class_base:extend()

function Fighter:new(hp,defense,power)
    self.max_hp = hp
    self.hp = hp
    self.defense = defense
    self.power = power
end

function Fighter:save()
    local txt = ""
    offset_push()
    for idx,value in pairs(self) do
        if type(value) ~= type(function () end) and type(value) ~= type({}) then
           txt = txt..add_offset()..idx..":"..value..",\n" 
        end
    end
    offset_pop()
    txt = string.gsub(txt,".+(,).-"," ")
    return txt
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
      msg =Message(self.owner.name.." attacks "..target.name.." for "..damage.." hitpoints.")
      table.insert(results,{message =msg})
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

