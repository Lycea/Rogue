local tmp_function={}

function string.split(txt,seperator)
    local tok_list ={}
    local idx = nil
    while txt ~= "" do
        idx =string.find(txt,seperator)
        if idx == nil then
            table.insert(tok_list,string.sub(txt,0,idx))
            break
        end
        
        table.insert(tok_list,string.sub(txt,0,idx-1))
        txt=string.sub(txt,idx+1,-1)
        
    end
    return tok_list
end



local function run_set(word_list)
  
end

local function run_get(word_list)
  
end

local function run_call(word_list)
  
end

local function run_command(word_list)
  
end


local function parse_command(command)
 local words = string.split(command," ")
 if #words <2 then
    print("we cannot parse this, awaiting more then 1 word!")
    print(command)
    return false
 end
 
 return words
 
end

local run_lookup_table={
  ["set"]= run_set,
  ["get"]= run_get,
  ["call"]= run_get,
  ["command"]=run_command,
  
  }


function tmp_function.init(base_state)

    local magic_state = base_state:extend()

    

    function magic_state:new()
        print("inited magic state...")
    end
    
    function magic_state:handle_action(action)
            --magic actions
        if action["enter_command"] then
            print("send command...")
            debuger.on()
            
            
            print("my command:",gvar.text_content)
            local response =parse_command(gvar.text_content)
            
            if response == false then
              return
            else
              local tokens_ =string.split(gvar.text_content,"%.")
            
              print(_G)
              
              local base_ = _G
              for _,tok in pairs(tokens_) do
                 if type(base_) ~= type({}) then
                   print("max level reached, there is nothing lower here....")
                   print(tokens_[_-1])
                   break
                 end
                 base_=base_[tok] 
              end
              
              print(base_)
            end
            --tokening thing ....
            
            
            debuger.off()
            print("magic ends here :(")
            
            gvar.save_text = false
            gvar.text_content=""
            
            gvar.game_state = glib.GameStates.PLAYERS_TURN
        end
        
        if action["remove_last"]then
           gvar.text_content= string.sub(gvar.text_content,1,-2)
           print(gvar.text_content)
        end
        
        return {false,{}}
    end
    function magic_state:draw()
        return false
    end

    function magic_state:handle_results(results)
        return false
    end

    function magic_state:update()
        return false
    end



    return magic_state()
end

return tmp_function