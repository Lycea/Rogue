
gr = love.graphics
floor = math.floor
rad = math.rad
deg = math.deg




print_colored = function (txt,x,y,c)
    gr.setColor(c or constants.colors.default)
    gr.print(txt,x,y)
    gr.setColor(constants.colors.default)
end


rect =     function (x,y,w,h) gr.rectangle("line",x,y,w,h) end
rectFill = function (x,y,w,h) gr.rectangle("fill",x,y,w,h) end