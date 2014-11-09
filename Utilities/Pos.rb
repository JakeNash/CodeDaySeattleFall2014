class Pos
  def initialize(x,y)
    @x, @y = x, y
  end

  def x
    @x
  end

  def y
    @y
  end

  def distance_to(other)
    (other.x - @x).abs + (other.y - @y).abs
  end
end
