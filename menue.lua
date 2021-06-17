
local function wrap_text(str,num)
  local ret = {}
  for i = 1, string.len(str), num do
		table.insert(ret, string.sub(str,i,i+num-1))
  end
  return ret
end

function menue(header,options,x,y,width,height,marker_id,border)
    if border == nil then
        border = true
    end
    
    local x_off = 5
    
    gr.setColor(0,0,0,255)
    if #options>26 then return end
    gr.rectangle("fill",x,y,width,height)
    
    
    local wrapped =wrap_text(header,width)
    local yoff =20
    local line_size = 15
    
    gr.setColor(255,255,255)
    
    if border == true then
        gr.rectangle("line",x,y,width,height)
    end
    
    for i,txt in pairs(wrapped) do
        gr.print(txt,x+10 +x_off,y+yoff+i*line_size)
        yoff = yoff+line_size
    end
    yoff = yoff + 10
    
    
    for i,option in pairs(options) do
        gr.print(option,x+10+x_off,y+yoff+i*line_size)
    end

    if marker_id ~= nil then 
        gr.rectangle("fill",x+x_off,y+yoff+marker_id*line_size + 4,5,5)
    end
    
    
    gr.setColor(0,0,0)

end


function main_menue()
  
  menue("NotTheRogue",{"Start new","Load old","Options","Exit"},0,0,400,400,main_menue_item,false)
end



