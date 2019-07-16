Equipable = class_base:extend()

function Equipable:new(slot,health_increase,def_increase,power_increase)
    self.slot   = slot
    self.health = health_increase
    self.def    = def_increase
    self.power  = power_increase
end
