local small_health_potion={
    name = "Small health potion",
    ["type"] = "item", --can be item or equipable
    
    chances ={
        {20,1}
    },
    
    
    color ="orange",
    blocking = false,
    render = RenderOrder.ITEM,
    tile= 0,
    
    
    
    --item specific stuff
    ["function"] = "heal",
    is_ranged = false,
    --[[message ={
        text= "",
        color= constants.color.green
    },]]
    arguments = {amount=10},
    
    --equipment info
    slot = nil,
    health = nil,
    power = nil,
    def = nil
    
}

return small_health_potion