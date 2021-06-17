local corona_hunt =class_base:extend()


local mobs = {}

local pls = {
 {x=60,y=64,c=3,h=false,ds={}},
 {x=60,y=64,c=3,h=false,ds={}}
}

local pts={}

local last_dist=0


---------------------------------------
--
--    WRAPPER FUNCTIONS
--
---------------------------------------

local function circfill(x,y,rad,col)
    gr.setColor(col)
    gr.circle("fill",x,y,rad)
    gr.setColor(0,0,0)
end


local function add(t,item)
    table.insert(t,item)    
end

local function cls()
    
end



--------------------------------------
--
-- BASE FUNCTIONS
--
--------------------------------------


local function draw_mob(mob)
 local line_col = {0,0,0}--white
 local head_col = {1,0,0}--beige
	if mob.a ~= nil then
	
	end
	
	if mob.hit==true then
		line_col = 8
		mob.hit =  false
	end
	
	
	--outer
	circfill(mob.x,mob.y,4,line_col)
	circfill(mob.x,mob.y-3,4,line_col)
	
	--inner
	circfill(mob.x,mob.y,  3,mob.c)
	circfill(mob.x,mob.y-3,3,mob.c)
	
	--head
	circfill(mob.x,mob.y-9,4,line_col)
	circfill(mob.x,mob.y-9,3,head_col)
end







function corona_hunt:new()
    print("hi there")    
end




function corona_hunt:startup()
    print("starting")
    
    cls()
    add(mobs,{x=54,y=64,c=2,hp=5})
end




function corona_hunt:draw()
    print("drawing")
end


function corona_hunt:set_events(events)
    self.events=events
    print("got events")
end


function corona_hunt:update()
    print("updating")
end

function corona_hunt:shutdown()
    
end





return corona_hunt()