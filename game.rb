require_relative './graphics'


# class responsible for the character representations and their movements
class Character

  def initialize (symbol, color, position, building_center, board)
    @symbol = symbol
    @color = color
    @position = position
    @board = board
    @moved = true
    @building = building_center
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

  def building
    @building
  end

  def move (delta_x, delta_y)
    moved = true
    if !(@board.empty_at(@position[0] + delta_x, @position[1] + delta_y))
      moved = false
    end
    if moved
      @position[0] += delta_x
      @position[1] += delta_y
    end
    moved
  end

  def self.next_character (board)
    Character.new("#", board)
  end

  All_Colors = ['green', 'gold2', 'LightSkyBlue']
end

class BuildingCenter < Character
  
  def initialize(board, position)
    super("L", 'cyan', position, true, board)
  end
end

class BuildingMiddle < Character

  def initialize (board, position)
    super("*", 'grey', position, false, board)
  end
end

class BuildingVerticalBorder < Character

  def initialize (board, position)
    super("|", 'grey', position, false, board)
  end
end

class BuildingHorizontalBorder < Character

  def initialize (board, position)
    super("-", 'grey', position, false, board)
  end
end

class BuildingCorner < Character

  def initialize (board, position)
    super("+", 'grey', position, false, board)
  end
end

class Board

  def initialize (game)
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_character = BuildingCenter.new(self, [10,10])
    @game = game
    @delay = 500
    @building_corner = BuildingCorner.new(self, [10,11])
    @building_middle = BuildingMiddle.new(self, [10,12])
    @building_vertical = BuildingVerticalBorder.new(self, [10,13])
    @building_horizontal = BuildingHorizontalBorder.new(self, [10,14])
    @i = 0
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

  # both the length and width of a block, since it's a square
  def block_size
    18
  end

  def num_columns
    73
  end

  def num_rows
    25
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
    @grid[point[1]][point[0]] == nil
  end

  def next_character
    @current_character = Character.next_character(self)
    @current_pos = nil
  end

  def draw
    @game.draw_character(@current_character, @current_pos)
    if @current_character.building
      @game.draw_character(@building_corner, @other_pos)
      @game.draw_character(@building_middle, @other_pos)
      @game.draw_character(@building_vertical, @other_pos)
      @game.draw_character(@building_horizontal, @other_pas)
    end
  end

  def new_unit (position, unit)
    @grid[position.x][position.y] = unit
  end

  def new_building (position, building)
    radius = building.size
    @grid[position.x - radius][position.y - radius] = @building_corner
    @grid[position.x + radius][position.y + radius] = @building_corner
    @grid[position.x + radius][position.y - radius] = @building_corner
    @grid[position.x - radius][position.y + radius] = @building_corner
    for i in 0..radius-1 do
      @grid[position.x - i][position.y] = @building_middle
      @grid[position.x + i][position.y] = @building_middle
      @grid[position.x][position.y - i] = @building_middle
      @grid[position.x][position.y + i] = @building_middle
      @grid[position.x - radius][position.y + i] = @building_vertical
      @grid[position.x - radius][position.y - i] = @building_vertical
      @grid[position.x + radius][position.y + i] = @building_vertical
      @grid[position.x + radius][position.y - i] = @building_vertical
      @grid[position.x + i][position.y - radius] = @building_horizontal
      @grid[position.x - i][position.y - radius] = @building_horizontal
      @grid[position.x + i][position.y + radius] = @building_horizontal
      @grid[position.x - i][position.y + radius] = @building_horizontal
    end
    @grid[position.x][position.y] = building
  end

  def new_spell (position, spell)
    @grid[position.x][position.y] = spell
  end

  def move_unit (position, unit)
    
  end
end

class Map

  def initialize (game)
    @game = game
  end

  def map_size
    230
  end
end

class Info
  def initialize (game)
    @game = game
  end

  def height
    230
  end

  def width
    500
  end
end

class Photo

  def initialize (game)
    @game = game
  end

  def photo_size
    230
  end
end

class CommandPanel
  
  def initialize(game)
    @game = game
  end

  def height
    230
  end

  def width
    354
  end
end

class Game

  # creates window and starts the game
  def initialize
    @resources = 0
    @root = GameRoot.new
    @timer = GameTimer.new
    set_board
    set_map
    set_info
    set_photo
    set_command_panel
    @running = true
    key_bindings
    buttons
    run_game
  end

  def resources
    @resources
  end

  def board
    @board
  end

  # creates a canvas and the board that interacts with it
  def set_board
    @canvas = GameCanvas.new
    @board = Board.new(self)
    @canvas.place(@board.block_size * @board.num_rows,
                  @board.block_size * @board.num_columns, 10, 10)
    @board.draw
  end

  # creates a canvas and the map that interacts with it
  def set_map
    @canvas = GameCanvas.new
    @map = Map.new(self)
    @canvas.place(@map.map_size, @map.map_size, 10, @board.block_size * @board.num_rows + 10)
  end

  def set_info
    @canvas = GameCanvas.new
    @info = Info.new(self)
    @canvas.place(@info.height, @info.width, 10 + @map.map_size, @board.block_size * @board.num_rows + 10)
  end

  def set_photo
    @canvas = GameCanvas.new
    @photo = Photo.new(self)
    @image = TkPhotoImage.new
    @image.file = "Doctor2Final.gif"
    label = TkLabel.new(@root)
    label.image = @image
    label.place('height' => @photo.photo_size, 'width' => @photo.photo_size, 'x' => 10 + @map.map_size + @info.width, 'y' => @board.block_size * @board.num_rows + 10)
  end

  def set_command_panel
    @canvas = GameCanvas.new
    @panel = CommandPanel.new(self)
    @canvas.place(@panel.height, @panel.width, 10 + @map.map_size + @info.width + @photo.photo_size, @board.block_size * @board.num_rows + 10)
  end

  def key_bindings
    @root.bind('q', lambda {exitProgram})
  end

  def buttons
    
  end

  # repeatedly calls itself so that the process is fully automated
  def run_game
    if !@board.game_over? and @running
      @timer.stop
      @timer.start(@board.delay, (lambda {|x| @board.run; run_game}))
    end
  end

  # whether the game is running
  def is_running?
    @running
  end

  def draw_character (character, old=nil)
    if old != nil and character.moved
      old.remove
    end
    size = @board.block_size
    start = character.position
    newCharacter = GameButton.new(character.symbol, character.color)
    newCharacter.place(size, size,
                 start[0]*size + 10, start[1]*size + 10)
  end
end

srand
