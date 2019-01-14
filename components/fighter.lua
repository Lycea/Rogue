Fighter = class_base:extend()

function Fighter:new(hp,defense,power)
    self.max_hp = hp
    self.hp = hp
    self.defense = defense
    self.power = power
end
