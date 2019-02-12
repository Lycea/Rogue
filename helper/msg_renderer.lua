Message = class_base:extend()

function Message:new(text,color)
    self.text = text
    self.color =color or {255,255,255}
end



local function wrap_text(str,num)
  local ret = {}
  for i = 1, string.len(str), num do
		table.insert(ret, string.sub(str,i,i+num-1))
  end
  return ret
end



MessageLog = class_base:extend()

function MessageLog:new(x,width,height)
  self.messages={}
  self.x = x
  self.width = width
  self.height = height
end


function MessageLog:add_message(message)
  local msg_lines = wrap_text(message.text,self.width/tile_size)
  
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
        
        print_colored(message.text,self.x*tile_size,scr_height-(self.height+3)*tile_size +i*(tile_size+2),message.color)
    end
    gr.setColor(colors.default)
end

