

local template_mob ={
    name="Slime",
    
    hp = 1,
    exp = 3,
    power = 1,
    def = 1,
    
    ai = "BasicMonster",
    tile = 0,
    
    chances={
        {1,1},
        {1,10}
    },
    
    color ="light_green",
    blocking = true,
    render = RenderOrder.ACTOR
    
}


return template_mob