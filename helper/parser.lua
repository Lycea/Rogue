text = [[test:[
{test: something,
 test_me: 1,
 test_bool: true
 },
{test_name:test_ob2},
{test_name:test_obj3,text:"text"}
]
]]





parser={}

local tokens ={}

local specials ={
    ["["]="ARRAY_START",
    ["]"]="ARRAY_END",
    ["{"]="OBJEKT_START",
    ["}"]="OBJECT_END",
    [","]="OBJECT_SEP",
    [":"]="DELIMITER",
    ['"']="STRING_DELIMITER"
    }

local function new_token(type_,value)
    
    if #value == 0 and type_ == "WORD" then
        return    
    end
    
    table.insert(tokens,{type_=type_,value = value})
end

local function trim(s)
   return s:match'^%s*(.*%S)' or ''
end



local function parse_specials(txt)
    local tmp_txt = ""
    
    local last_was_text = false
    
    local idx = 1
    while idx<=#txt do
        --print(string.sub(txt,idx,#txt))
        print(string.sub(txt,idx,idx))
        char =string.sub(txt,idx,idx)
        if specials[char] ~= nil then
            if last_was_text == true then
                new_token("WORD",trim(tmp_txt))
                tmp_txt=""
                last_was_text = false
            end
            
            new_token(specials[char],"")
        else
            tmp_txt = tmp_txt ..char
            last_was_text = true
        end
        
        idx= idx+1
        
    end
end



function parser.parse_tokens(txt)
    parse_specials(txt)
    
    for idx ,token in ipairs(tokens) do
       print(token.type_,token.value,#token.value) 
        
    end
    print(#tokens)
end



local function match_one_of()
    
end

local function match_as_many()
    
end


function parse_list()
    
end

function parse_object()
    
end

    
function parse_string()
    
end

function parse_element()
    
end


    

function parser.start_parsing()
    
end


function parser.parse(txt)
    tokens ={}
    parser.parse_tokens(txt)
    parser.start_parsing()
end

parser.parse(text)