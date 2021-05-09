local confusion_scroll={
      
    name = "confusion scroll" ,
    ["type"] = "item", --can be item or equipable
    
    chances ={
        {5,1}
    },
    
    
    color ="blue",
    blocking = false,
    render = "ITEM",
    tile= 0,
    
    
    
    --item specific stuff
    ["function"] = "cast_confuse",
    is_ranged = true,
    message ={
        text= "Hit enter to set target",
        color= "green"
    },
    arguments = {},
    
    
    --equipment info
    slot = nil,
    health = nil,
    power = nil,
    def = nil
    
}

return confusion_scroll
