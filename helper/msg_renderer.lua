local Message = class_base:extend()

function Message:new(text,color)
    self.text = text or ""
    self.color =color or {255,255,255}
end


function Message:save()
    return "text:"..self.text.."\ncolor:"..table.concat(self.color,",").."\n"
end


local function wrap_text(str,num)
  local ret = {}
  for i = 1, string.len(str or ""), num do
		table.insert(ret, string.sub(str,i,i+num-1))
  end
  return ret
end



local MessageLog = class_base:extend()


function MessageLog.print_colored (txt,x,y,c)
    gr.setColor(c or gvar.constants.colors.default)
    gr.print(txt,x,y)
    gr.setColor(gvar.constants.colors.default)
end


function MessageLog:new(x,width,height)
  self.messages={}
  self.x = x
  self.width = width
  self.height = height
end


function MessageLog:add_message(message)
  local msg_lines = wrap_text(message.text,self.width/gvar.constants.tile_size)
  
  for i,line in ipairs(msg_lines) do
    if #self.messages >=self.height then
      self.messages[#self.messages] = nil
    end
    table.insert(self.messages,1,Message(line,message.color))
  end
end


function MessageLog:draw()
    --print(self.height)
    for i,message in ipairs(self.messages) do
        
        MessageLog.print_colored(message.text,self.x*gvar.constants.tile_size,
            gvar.constants.scr_height-(self.height+3)*gvar.constants.tile_size +i*(gvar.constants.tile_size+2),
            message.color)
    end
    gr.setColor(gvar.constants.colors.default)
end

return {Message = Message,MessageLog=MessageLog}