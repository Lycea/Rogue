Rect =class_base:extend()


function Rect:new(x,y,w,h)
    self.x1 = x
    self.y1 = y
    self.x2 =self.x1+w
    self.y2 =self.y1+h
    self.w = w
    self.h = h
end


function Rect:center()
    center_x = math.floor((self.x1+self.x2)/2)
    center_y = math.floor((self.y1+self.y2)/2)
    return {center_x,center_y}
end

function Rect:intersect(other)
  return self.x1 <= other.x2 and self.x2 >= other.x1 and self.y1 <= other.y2 and self.y2 >= other.y1
end

