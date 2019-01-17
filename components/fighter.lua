Fighter = class_base:extend()

function Fighter:new(hp,defense,power)
    self.max_hp = hp
    self.hp = hp
    self.defense = defense
    self.power = power
end

function Fighter:take_damage(amount)
  self.hp = self.hp -amount
end

function Fighter:attack(target)
    local damage = self.power - target.fighter.defense
    
    if damage> 0 then
      target.fighter.take_damage(damage)
      print(self.owner.name.." attacks "..target.name.." for "..damage.." hitpoints.")
    else
    end
end

