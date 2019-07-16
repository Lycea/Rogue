Equipment = class_base:extend()



function Equipment:new(hand_equip,off_hand_equip)
    self.main_hand = hand_equip
    self.off_hand = off_hand_equip
end

function Equipment:get_hp_bonus()
    local bonus = 0
    
    if self.main_hand and self.main_hand.equippable then
        bonus = bonus + self.main_hand.equippable.hp
    end
    
    if self.off_hand and self.off_hand.equippable then
        bonus = bonus + self.off_hand.equippable.hp
    end
    
    return bonus
end

function Equipment:get_power_bonus()
    local bonus = 0
    
    if self.main_hand and self.main_hand.equippable then
        bonus = bonus + self.main_hand.equippable.power
    end
    
    if self.off_hand and self.off_hand.equippable then
        bonus = bonus + self.off_hand.equippable.power
    end
    
    return bonus
end

function Equipment:get_def_bonus()
    local bonus = 0
    
    if self.main_hand and self.main_hand.equippable then
        bonus = bonus + self.main_hand.equippable.def
    end
    
    if self.off_hand and self.off_hand.equippable then
        bonus = bonus + self.off_hand.equippable.def
    end
    
    return bonus
end


function Equipment:toggle_equip(equippable)
    local results ={}
    
    
    if equippable.equippable.slot == EquipmentSlots.HAND_LEFT then
        if equippable == self.main_hand then
            self.main_hand = nil
            table.insert(results,{unequipped=equippable})
        else
            self.main_hand = equippable
            table.insert(results,{equipped=equippable})
        end
    elseif equippable.equippable.slot == EquipmentSlots.OFF_HAND then
        if equippable == self.off_hand then
            self.off_hand = nil
            table.insert(results,{unequipped=equippable})
        else
            self.off_hand = equippable
            table.insert(results,{equipped=equippable})
        end
    end
    
    
    return results
end






