

local template_mob ={
    name="Goblin",
    
    hp = 19,
    exp = 10,
    power = 4,
    def = 0,
    
    ai = "BasicMonster",
    tile = 0,
    
    chances={
        {80,1},
        {50,2},
        {30,3},
        {15,4},
        {3,5},
        {0,7}
    },
    
    color ="darker_green",
    blocking = true,
    render = RenderOrder.ACTOR
    
}


return template_mob