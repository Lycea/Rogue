
local function wrap_text(str,num)
  local ret = {}
  for i = 1, string.len(str), num do
		table.insert(ret, string.sub(str,i,i+num-1))
  end
  return ret
end

function menue(header,options,x,y,width,marker_id)
    gr.setColor(0,0,0,255)
    if #options>26 then return end
    gr.rectangle("fill",x,y,width,scr_height)
    
    local wrapped =wrap_text(header,width)
    local yoff =20
    local line_size = 15
    
    gr.setColor(255,255,255)
    
    
    for i,txt in pairs(wrapped) do
        gr.print(txt,10,yoff+i*line_size)
        yoff = yoff+line_size
    end
    yoff = yoff + 10
    
    
    for i,option in pairs(options) do
        gr.print(option,10,yoff+i*line_size)
    end

    if marker_id ~= nil then 
        gr.rectangle("fill",0,yoff+marker_id*line_size,5,5)
    end
    
    
    gr.setColor(0,0,0)

end

function invi_menue(header,inventory,width)
 local options ={}
 if inventory.num_items == 0 then
     options={"No item in the inventory"}
 else
     for _,item in pairs(inventory.items)do
     table.insert(options,item.name)
     end
 end
 menue(header,options,0,0,width,inventory.active_item)
 
end
