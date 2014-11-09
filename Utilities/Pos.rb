class Pos
  def initialize(x,y)
    @xPos, @yPos = x, y
  end

  def distance(pos1,pos2)
    return (pos2.y-pos1y).abs + (pos2.x-pos1.x).abs
  end
end
