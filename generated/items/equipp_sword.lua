local sword={
    
    name = "Sword" ,   
    ["type"] = "equipp", --can be item or equipable
    
    chances ={
        {10,2},
        {15,4}
    },
    
    
    color ="light_blue",
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
    health = 0,
    power = 5,
    def = 0
}

return sword