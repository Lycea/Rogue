local shield={
    
    name = "shield" ,   
    ["type"] = "equipp", --can be item or equipable
    
    chances ={
        {10,2},
        {15,4}
    },
    
    
    color ="green",
    blocking = false,
    render = "ITEM",
    tile= 0,
    
    
    
    --item specific stuff
    ["function"] = nil,
    is_ranged = false,
    message =nil,
    arguments = nil,
    
    
    --equipment info
    slot ="OFF_HAND" ,
    health = 3,
    power = 0,
    def = 2
}

return shield