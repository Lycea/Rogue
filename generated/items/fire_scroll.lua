local fire_scroll={
    
    name = "fireball scroll" ,   
    ["type"] = "item", --can be item or equipable
    
    chances ={
        {10,2},
        {15,4}
    },
    
    
    color ="red",
    blocking = false,
    render = RenderOrder.ITEM,
    tile= 0,
    
    
    
    --item specific stuff
    ["function"] = "cast_fireball",
    is_ranged = true,
    message ={
        text= "Hit enter to set target",
        color= "green"
    },
    arguments = {damage=10,radius=5},
    
    
    --equipment info
    slot = nil,
    health = nil,
    power = nil,
    def = nil
}

return fire_scroll