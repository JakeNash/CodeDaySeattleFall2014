require_relative './game'
require_relative './character'

class Board

  def initialize (game)
    @num_rows = 25
    @num_columns = 73
    @grid = Array.new(@num_columns) {Array.new(@num_rows)}
    @current_character = Array.new
    @other_character = Array.new
    @current_character.push(Character.new("@", 'light blue', [20,20], self))
    @other_character.push(Character.new("@", 'light blue', [20,20], self))
    @game = game
    @delay = 500
  end

  def num_rows
    @num_rows
  end

  def num_columns
    @num_columns
  end

  def block_size
    18
  end

  def height
    @height
  end

  def width
    @width
  end

  def move_left
    if !game_over? and @game.is_running?
      @current_character.each {|char| char.move(-1, 0)}
      @other_character.each {|char| char.move(-1, 0)}
    end
    draw
  end

  def move_right
    if !game_over? and @game.is_running?
      @current_character.each {|char| char.move(1, 0)}
      @other_character.each {|char| char.move(1, 0)}
    end
    draw
  end

  def move_up
    if !game_over? and @game.is_running?
      @current_character.each {|char| char.move(0, -1)}
      @other_character.each {|char| char.move(0, -1)}
    end
    draw
  end

  def move_down
    if !game_over? and @game.is_running?
      @current_character.each {|char| char.move(0, 1)}
      @other_character.each {|char| char.move(0, 1)}
    end
    draw
  end

  def nearest_enemy_unit (unit, objective_pos)
    if (unit.position.x - objective_pos.x).abs > (unit.position.y - objective_pos.y).abs and unit.position.x - objective_pos.x >= 0
      low_x = objective_pos.x
      high_x = unit.position.x
      if unit.position.y < objective_pos.y
        low_y = unit.position.y - unit.aggroRange
        high_y = unit.position.y + (objective_pos.y - unit.position.y)
      else
        low_y = unit.position.y - (unit.position.y - objective_pos.y)
        high_y = unit.position.y + unit.aggroRange
      end
    elsif (unit.position.x - objective_pos.x).abs > (unit.position.y - objective_pos.y).abs and unit.position.x - objective_pos.x < 0
      high_x = objective_pos.x
      low_x = unit.position.x
      if unit.position.y < objective_pos.y
        low_y = unit.position.y - unit.aggroRange
        high_y = unit.position.y + (objective_pos.y - unit.position.y)
      else
        low_y = unit.position.y - (unit.position.y - objective_pos.y)
        high_y = unit.position.y + unit.aggroRange
      end
    elsif (unit.position.x - objective_pos.x).abs < (unit.position.y - objective_pos.y).abs and unit.position.y - objective_pos.y >= 0
      if unit.position.x < objective_pos.x
        low_x = unit.position.x - unit.aggroRange
        high_x = unit.position.x + (objective_pos.x - unit.position.x)
      else
        low_x = unit.position.x - (unit.position.x - objective_pos.x)
        high_x = unit.position.x + unit.aggroRange
      end
      low_y = objective_pos.y
      high_y = unit.position.y
    else
      if unit.position.x < objective_pos.x
        low_x = unit.position.x - unit.aggroRange
        high_x = unit.position.x + (objective_pos.x - unit.position.x)
      else
        low_x = unit.position.x - (unit.position.x - objective_pos.x)
        high_x = unit.position.x + unit.aggroRange
      end
      high_y = objective_pos.y
      low_y = unit.position.y
    end
    minDistance = distanceTo(objective_pos)
    output = nil
    for i in low_x..high_x do
      for j in low_y..high_y do
        unless grid[i][j] == nil or (i == position.x and j == position.y) or (grid[i][j].isZombie and unit.isZombie) or (!grid[i][j].isZombie and !unit.isZombie)
          other_unit = grid[i][j]
          dist = distanceTo(other_unit.position)
          if dist < minDistance
            minDistance = dist
            output = other_unit
          end
        end
      end
    end
    output
  end

  def nearest_friendly_unit (unit, objective_pos)
    if (unit.position.x - objective_pos.x).abs > (unit.position.y - objective_pos.y).abs and unit.position.x - objective_pos.x >= 0
      low_x = objective_pos.x
      high_x = unit.position.x
      if unit.position.y < objective_pos.y
        low_y = unit.position.y - unit.aggroRange
        high_y = unit.position.y + (objective_pos.y - unit.position.y)
      else
        low_y = unit.position.y - (unit.position.y - objective_pos.y)
        high_y = unit.position.y + unit.aggroRange
      end
    elsif (unit.position.x - objective_pos.x).abs > (unit.position.y - objective_pos.y).abs and unit.position.x - objective_pos.x < 0
      high_x = objective_pos.x
      low_x = unit.position.x
      if unit.position.y < objective_pos.y
        low_y = unit.position.y - unit.aggroRange
        high_y = unit.position.y + (objective_pos.y - unit.position.y)
      else
        low_y = unit.position.y - (unit.position.y - objective_pos.y)
        high_y = unit.position.y + unit.aggroRange
      end
    elsif (unit.position.x - objective_pos.x).abs < (unit.position.y - objective_pos.y).abs and unit.position.y - objective_pos.y >= 0
      if unit.position.x < objective_pos.x
        low_x = unit.position.x - unit.aggroRange
        high_x = unit.position.x + (objective_pos.x - unit.position.x)
      else
        low_x = unit.position.x - (unit.position.x - objective_pos.x)
        high_x = unit.position.x + unit.aggroRange
      end
      low_y = objective_pos.y
      high_y = unit.position.y
    else
      if unit.position.x < objective_pos.x
        low_x = unit.position.x - unit.aggroRange
        high_x = unit.position.x + (objective_pos.x - unit.position.x)
      else
        low_x = unit.position.x - (unit.position.x - objective_pos.x)
        high_x = unit.position.x + unit.aggroRange
      end
      high_y = objective_pos.y
      low_y = unit.position.y
    end
    minDistance = distanceTo(objective_pos)
    output = nil
    for i in low_x..high_x do
      for j in low_y..high_y do
        unless grid[i][j] == nil or (i == position.x and j == position.y) or (grid[i][j].isZombie and !unit.isZombie) or (!grid[i][j].isZombie and unit.isZombie)
          other_unit = grid[i][j]
          dist = distanceTo(other_unit.position)
          if dist < minDistance
            minDistance = dist
            output = other_unit
          end
        end
      end
    end
    output
  end

  def nearest_enemy_aggro (unit)
    low_x = unit.position.x - unit.aggroRange
    high_x = unit.position.x + unit.aggroRange
    low_y = unit.position.y - unit.aggroRange
    high_y = unit.position.y + unit.aggroRange
    minDistance = 500
    output = nil
    for i in low_x..high_x do
      for j in low_y..high_y do
        unless grid[i][j] == nil or (i == position.x and j == position.y) or (grid[i][j].isZombie and unit.isZombie) or (!grid[i][j].isZombie and !unit.isZombie)
          other_unit = grid[i][j]
          dist = distanceTo(other_unit.position)
          if dist < minDistance
            minDistance = dist
            output = other_unit
          end
        end
      end
    end
    output
  end

  def nearest_friendly_aggro (unit)
    low_x = unit.position.x - unit.aggroRange
    high_x = unit.position.x + unit.aggroRange
    low_y = unit.position.y - unit.aggroRange
    high_y = unit.position.y + unit.aggroRange
    minDistance = 500
    output = nil
    for i in low_x..high_x do
      for j in low_y..high_y do
        unless grid[i][j] == nil or grid[i][j].is_a?(Building) or (i == position.x and j == position.y) or (grid[i][j].isZombie and !unit.isZombie) or (!grid[i][j].isZombie and unit.isZombie)
          other_unit = grid[i][j]
          dist = distanceTo(other_unit.position)
          if dist < minDistance
            minDistance = dist
            output = other_unit
          end
        end
      end
    end
    output
  end

  # the current delay
  def delay
    @delay
  end

  def game_over?
    false
  end

  def run
    draw
  end

  def empty_at (point)
    if !(point[0] >= 0 and point[0] < num_columns)
      return false
    elsif !(point[1] >= 0 and point[1] < num_rows)
      return false
    end
    @grid[point[0]][point[1]] == nil
  end

  def draw
    @poses = @game.draw_character(@current_character, @other_character, @current_pos, @other_pos)
    @current_pos = @poses[0]
    @other_pos = @poses[1]
  end

  def new_unit (position, unit)
    if @grid[position.x][position.y] == nil
      @grid[position.x][position.y] = [Character.new(unit.symbol, unit.color, [unit.position.x, unit.position.y],self), Character.new(unit.symbol, unit.color, [unit.position.x, unit.position.y],self)]
      @current_character.push(Character.new(unit.symbol, unit.color, [unit.position.x, unit.position.y],self))
      @other_character.push(Character.new(unit.symbol, unit.color, [unit.position.x, unit.position.y],self))
    end
  end

  def new_building (position, building)
    if @grid[position.x][position.y] == nil
      @grid[position.x][position.y] = [Character.new(building.symbol, building.color, [building.position.x, building.position.y],self), Character.new(building.symbol, building.color, [building.position.x, building.position.y],self)]
      @current_character.push(Character.new(unit.symbol, unit.color, [unit.position.x, unit.position.y],self))
      @other_character.push(Character.new(unit.symbol, unit.color, [unit.position.x, unit.position.y],self))
    end
  end

  def new_spell (position, spell)
    if @grid[position.x][position.y] == nil
      @grid[position.x][position.y] = spell
    end
  end

  def move_unit (unit)
    
  end
end
