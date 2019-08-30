class_base= require("externals.classic")


AnimationSequence = class_base:extend()
Animator = class_base:extend()

function Animator:new(
    sprite_path
)
    self.sprite_path = sprite_path
    self.animations = {}
    


end

function Animator:addAnimation(
    animation_name,
    animation_duration,
    start_increment_x,
    end_increment_x,
    start_increment_y,
    end_increment_y,
    increment_width_in_px, 
    increment_height_in_px)
)
    local sequence_definitions = AnimationSequence(
      start_increment_x,
      end_increment_x,
      start_increment_y,
      end_increment_y,
      increment_width_in_px,
      increment_height_in_px
    )
    
    -- we want multiple animations in 1 animator so 1 entity can have a sinlge animator
    -- a sprite can contain multiple animations, so we define the sequence we want to have
    animation = newAnimation(love.graphics.newImage(self.sprite_path), sequence_definitions)
    table.insert( self.animations, animation_name, animation )
    
    --print table to debug
    print(table)
    
end









state = 0
counter = 1

function AnimationSequence:new(
    start_increment_x,
    end_increment_x,
    start_increment_y,
    end_increment_y,
    increment_width_in_px, 
    increment_height_in_px)
  
  self.start_increment_x = start_increment_x
  self.end_increment_x = end_increment_x
  self.start_increment_y = start_increment_y
  self.end_increment_y = end_increment_y  
  self.increment_width_px= increment_width_in_px
  self.increment_heigth_px = increment_height_in_px
  
  self.start_increment_x_px = (start_increment_x - 1) * increment_width_in_px
  self.end_increment_x_px = (end_increment_x - 1) * increment_width_in_px
  
  self.start_increment_y_px = (start_increment_y - 1) * increment_height_in_px
  self.end_increment_y_px = (end_increment_y - 1) * increment_height_in_px
end
--[[
function AnimationSequence:load()
    debugger = require("mobdebug")
    debugger.start()
    -- animation = newAnimation(love.graphics.newImage("yasuko_sheet.png"), 19, 35, 1)
    local ninja_sequence_walk = AnimationSequence(2,7,1,1,32,64)
    local ninja_sequence_strik_vrt = AnimationSequence(1,4,3,3,32,64)
    -- local ninja_sequence_walk = AnimationSequence(0,5,19,35)
    --ninja_animation = newAnimation(love.graphics.newImage("yasuko_sheet.png"), ninja_sequence_walk)
    animation = newAnimation(love.graphics.newImage("maleBase/full/ninja_full.png"), ninja_sequence_walk)
    
    animation_strike_vrt = newAnimation(love.graphics.newImage("maleBase/full/ninja_full.png"),ninja_sequence_strik_vrt)
    
end
]]--
 
function Animator:update(animation_name,dt)
  local animi = self.animations[animation_name]
  
    -- cant I just do that instead of looping?
    -- we want do restart the sequence when currentTime exceeds duration of sequence
    animi.currenTime = animi.currentTime + dt
    if animi.currenTime >= animi.duration 
        -- animation went through, reset to 0-ish value
        animi.currenTime = animi.currenTime - animi.duration
    end
    
    --[[
  
  
    if state == 0 then
        animation.currentTime = animation.currentTime + dt
        if animation.currentTime >= animation.duration then
              animation.currentTime = animation.currentTime - animation.duration
              state = 1
        end
    else     
        animation_strike_vrt.currentTime = animation_strike_vrt.currentTime + dt
        if animation_strike_vrt.currentTime >= animation_strike_vrt.duration then
            animation_strike_vrt.currentTime = animation_strike_vrt.currentTime - animation_strike_vrt.duration
            state = 0
        end
    end
    
    ]]--

end
 
function Animator:draw(animation_name)
  
    local animi = self.animations[animation_name]

    -- prites numbers are kinda ints, time is kinda float, so we have to cast
    local spriteNum = math.floor(animi.currentTime / animi.duration * #animi.quads) + 1
    love.graphics.draw(animi.spriteSheet, animi.quads[spriteNum], 0, 0, 0, 4)
    
    --[[
  
  
    
    
    if state == 0 then
        local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
        love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], 0, 0, 0, 4)
        --counter = counter + 1
        --[[
        if #animation.quads == counter then
          print("walk ends" .. counter)
          counter = 1
          state = 1
        end
        ]]--
    else
        local spriteNum = math.floor(animation_strike_vrt.currentTime / animation_strike_vrt.duration * #animation_strike_vrt.quads) + 1
        
        love.graphics.draw(animation_strike_vrt.spriteSheet, animation_strike_vrt.quads[spriteNum], 0, 0, 0, 4)
        --counter = counter + 1
        --[[
        if #animation_strike_vrt.quads == counter then
          print("strike ends" .. counter)
          counter = 1
          state = 0
        end
        ]]--

    end
    --]]
end
 
-- function newAnimation(image, width, height, duration)
function Animator:newAnimation_(AnimationSequence)
  
    local animation = {}
    animation.spriteSheet = self.sprite_path;
    animation.quads = {};
    
    
    
    
    
    
    for y = AnimationSequence.start_increment_y_px, AnimationSequence.end_increment_y_px,AnimationSequence.increment_heigth_px do      
      
        for x = AnimationSequence.start_increment_x_px, AnimationSequence.end_increment_x_px, AnimationSequence.increment_width_px do
          
          myQuad = love.graphics.newQuad(
                x,
                y, 
                AnimationSequence.increment_width_px, 
                AnimationSequence.increment_heigth_px,
                self.sprite_path:getDimensions()              
                )
          
          table.insert(animation.quads,myQuad)
          
        end
    end
    print(#animation.quads)
--[[
  
 

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end
]]--

 
    animation.duration = duration or 1
    animation.currentTime = 0
 
    return animation
end
  