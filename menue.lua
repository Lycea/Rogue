
local function wrap_text(str,num)
  local ret = {}
  for i = 1, string.len(str), num do
		table.insert(ret, string.sub(str,i,i+num-1))
  end
  return ret
end

function menue(header,options,x,y,width)
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
    
    
    gr.setColor(0,0,0)

end
