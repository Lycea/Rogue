
mobs = {}

pls = {
 {x=60,y=64,c=3,h=false,ds={}},
 {x=60,y=64,c=3,h=false,ds={}}
}

pts={}

last_dist=0

function draw_mob(mob)
 local line_col = 7--white
 local head_col = 15--beige
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

function _init()
  cls()
  add(mobs,{x=54,y=64,c=2,hp=5})
end




function upd_pts()
 local to_remove ={}
 
	for id,pt in pairs(pts)do
	
		if pt.t > 30 then
			--del(pts,id)
			--pts[id]=nil	
			add(to_remove,id)
		else
	
	-- if pt.x<0 or pt.x > 10000 or pt.y <0 or pt.y >1000 then
	--  add(to_remove,id)
	-- end
	
	
		 pts[id].x+=pt.xd
		 pts[id].y+=pt.yd
		 
		 pts[id].t+=abs(pt.xd)+abs(pt.yx)
		 
		 
		 for i,m in pairs(mobs) do
		 	if dist(m,pt)< 3 then
		 		hit_m(m)
		 		last_dist+=dist(m,pt)
		 		--del(pts,id)
		 	 --pts[id]=nil
		 	 add(to_remove,id)
		 		break
		 	end
		 end
	 end
	end
	
	
	--remove enities
	for id=#to_remove-1,1,-1 do
		pts[to_remove[id]]=nil
	end
	
end


function drw_mobs()
 for i,mob in pairs(mobs)do
 	--left draw
		--camera(pls[1].x-mob.x +32-8,pls[1].y-mob.y)
		
		if near_p(mob,pls[1]) then
			cam_l()
			draw_mob(mob)
			
			if dist(mob,pls[1])<15 then
						circ(mob.x,mob.y-5,15)
			end
			--draw_mob(pls[1])
		end
		camera()
		
		
		--right draw
		if near_p(mob,pls[2]) then
		 cam_r()
			draw_mob(mob)
			--draw_mob(pls[1])
		end
		camera()
		
 end
end

function upd_mobs()
	for i,mob in pairs(mobs) do
	 --do something with the mobs
	end
end


function spit(p,d)
 if d.x==0 and d.y==0 then
  return
 end
 
	for i=0,10 do
	 local spd= rnd(2)+2
	 local pt= {
	   x = p.x+d.x*spd,
	   y = p.y+d.y*spd -8,
	   xd= d.x~=0 and d.x*(1+((rnd(10)-5)/20)) or (rnd(10)-5)/20,
	   yd= d.y~=0 and d.y*(1+((rnd(10)-5)/20)) or (rnd(10)-5)/20,
	 		t=0
	 }
		add(pts,pt)
	end
end

function _update60()
	for i,pl in pairs(pls) do
	 dir_={x=0,y=0}
		--up
		if btn(2,i-1)then pl.y-=1 dir_.y-=1 end
		--down
		if btn(3,i-1)then pl.y+=1 dir_.y+=1 end
		--left
		if btn(0,i-1)then pl.x-=1 dir_.x-=1 end
		--right
		if btn(1,i-1)then pl.x+=1 dir_.x+=1 end
		--do_thing
		if btn(4,i-1)then
		 if dir_.x==-1 and dir_.y==-1 then
				
		 end
		 
		 spit(pl,dir_)
	 end
	end
	
	upd_pts()
	upd_mobs()
end

function hit_m(m)
	m.hp-=1
	m.hit = true
	if m.hp<=0 then m.c=1 end
end

function dist(a,b)
 res=sqrt((a.x-b.x)^2+(a.y-b.y)^2)
 return res
end 

function cam_l() camera(pls[1].x-32,pls[1].y-64) end
function cam_r() camera(pls[2].x-96,pls[2].y-64) end

function near_p(p,m)
 return sqrt((p.x-m.x)^2)<32
end


function drw_pts()
	for id,pt in pairs(pts)do
	
	 if near_p(pt,pls[1])then
	  cam_l()
	  rectfill(pt.x,pt.y,pt.x,pt.y,17)
	 end
	 
	 if near_p(pt,pls[2])then
	  cam_r()
	  rectfill(pt.x,pt.y,pt.x,pt.y,17)
	 end
	 camera()
	end
end


function _draw()
	cls()
	rect(64,0,65,128,7)
	--left
	draw_mob({x=32,y=64,c=3})
	--right
	draw_mob({x=96,y=64,c=3})
	
	drw_mobs()
	
	--draw players
	if near_p(pls[1],pls[2]) then
		cam_r()
		draw_mob(pls[1])
		cam_l()
		draw_mob(pls[2])
		camera()
	end
	
	print(pls[1].x.." "..pls[1].y.." "..last_dist)
	--draw pts
	drw_pts()
	
end
