Equipment = class_base:extend()



function Equipment:new(hand_equip,off_hand_equip)
    self.main_hand = hand_equip
    self.off_hand = off_hand_equip
end

function Equipment:save()
    local txt = ""
    offset_push()
    
    local function find_invi_idx(item_hash)
        --iterate all item in parent inventory to find 
        --responsible item in slot ...  hacky?
        
        --TODO: check if smth could go wrong with dropping equip and finding it here
        for idx, item in pairs(self.owner.inventory.items) do
            if item == item_hash then
                print(idx)
                return idx
            end
        end
    end
    
    
    
    local equipp_string_list ={}
    
    if self.main_hand ~= nil then
        
        local idx =find_invi_idx(self.main_hand)
        txt='"main_hand":{\n'..'"invi_idx":'..idx..","..self.main_hand:save().."}"
        table.insert(equipp_string_list,txt)
    end
    if self.off_hand ~= nil then
        local idx =find_invi_idx(self.off_hand)
        txt= '"off_hand":{\n'..'"invi_idx":'..idx..","..self.off_hand:save().."}"
        table.insert(equipp_string_list,txt)
    end
        
    txt = table.concat(equipp_string_list,",\n")
    
    
    offset_pop()
    
    return txt
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
    
    print("checking equipped ..")
    if equippable.equippable.slot == EquipmentSlots.HAND_LEFT then
        
        print("is left hand")
        if equippable == self.main_hand then
            print("is equipped already so unequip")
            self.main_hand = nil
            
            table.insert(results,{unequipped=equippable})
        else
            print(self.main_hand,equippable)
            print("is not equipped so equipp???")
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






