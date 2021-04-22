local shield={
    
    name = "shield" ,   
    ["type"] = "equipp", --can be item or equipable
    
    chances ={
        {10,2},
        {15,4}
    },
    
    
    color ="green",
    blocking = false,
    render = RenderOrder.ITEM,
    tile= 0,
    
    
    
    --item specific stuff
    ["function"] = nil,
    is_ranged = false,
    message =nil,
    arguments = nil,
    
    
    --equipment info
    slot =EquipmentSlots.OFF_HAND ,
    health = 3,
    power = 0,
    def = 2
}

return shield