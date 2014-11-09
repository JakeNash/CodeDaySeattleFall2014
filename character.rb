require_relative './game'
require_relative './board'


# class responsible for the character representations and their movements
class Character

  def initialize (symbol, color, position, board)
    @symbol = symbol
    @color = color
    @position = position
    @board = board
    @moved = true
  end

  def to_array
    [@symbol, @color, @position]
  end

  def board
    @board
  end

  def moved
    @moved
  end

  def position
    @position
  end

  def symbol
    @symbol
  end

  def color
    @color
  end

  def move (delta_x, delta_y)
    @moved = true
    if !(@board.empty_at([@position[0] + delta_x, @position[1] + delta_y]))
      @moved = false
    end
    if @moved
      @position[0] += delta_x
      @position[1] += delta_y
    end
    @moved
  end

  All_Colors = ['green', 'gold2', 'LightSkyBlue']
end
