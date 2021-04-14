local tmp_function={}

function string.split(txt,seperator)
    local tok_list ={}
    
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
            
            
            print("my command:",text_content)
            
            
            --tokening thing ....
            
            local tokens_ =string.split(text_content,"%.")
            
            print(_G)
            
            base_ = _G
            for _,tok in pairs(tokens_) do
               base_=base_[tok] 
            end
            
            print(base_)
            debuger.off()
               print("magic ends here :(")
            
            save_text = false
            text_content=""
            
            game_state = GameStates.PLAYERS_TURN
        end
        
        if action["remove_last"]then
           text_content= string.sub(text_content,1,-2)
           print(text_content)
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