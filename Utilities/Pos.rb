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
    return Math.sqrt((other.x - @x)*(other.x - @x) + (other.y - @y)*(other.y - @y))
  end
end
