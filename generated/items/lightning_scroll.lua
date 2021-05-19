local lightning_scroll={
    
    name = "lightning scroll" ,   
    ["type"] = "item", --can be item or equipable
    
    chances ={
        {10,1},
        {15,3}
    },
    
    
    color ="yellow",
    blocking = false,
    render = "ITEM",
    tile= 0,
    
    
    
    --item specific stuff
    ["function"] = "cast_lightning",
    is_ranged = false,
    message =nil,
    arguments = {damage=20,max_range=5},
    
    
    --equipment info
    slot = nil,
    health = nil,
    power = nil,
    def = nil
}

return lightning_scroll