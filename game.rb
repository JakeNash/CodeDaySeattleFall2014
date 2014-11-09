require_relative './graphics'
require_relative './board'
require_relative './character'
require_relative './Utilities/Pos'
require_relative './Units/worker'
require_relative './Units/ranger'
require_relative './Units/healer'
require_relative './Units/grunt'
require_relative './Units/hero'
require 'json'

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
    @resources = 50
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

  def self.game
    self
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
    @map_canvas = GameCanvas.new
    @map = Map.new(self)
    @map_canvas.place(@map.map_size, @map.map_size, 10, @board.block_size * @board.num_rows + 10)
  end

  def set_info
    @info_canvas = GameCanvas.new
    @info = Info.new(self)
    @info_canvas.place(@info.height, @info.width, 10 + @map.map_size, @board.block_size * @board.num_rows + 10)
  end

  def set_photo
    @photo_canvas = GameCanvas.new
    @photo = Photo.new(self)
    @image = TkPhotoImage.new
    @image.file = "HERO.gif"
    label = TkLabel.new(@root)
    label.image = @image
    label.place('height' => @photo.photo_size, 'width' => @photo.photo_size, 'x' => 10 + @map.map_size + @info.width, 'y' => @board.block_size * @board.num_rows + 10)
  end

  def set_command_panel
    @panel_canvas = GameCanvas.new
    @panel = CommandPanel.new(self)
    @panel_canvas.place(@panel.height, @panel.width, 10 + @map.map_size + @info.width + @photo.photo_size, @board.block_size * @board.num_rows + 10)
  end

  def key_bindings
    @root.bind('q', lambda {exitProgram})

    @root.bind('a', lambda {@board.move_left})
    @root.bind('d', lambda {@board.move_right})
    @root.bind('w', lambda {@board.move_up})
    @root.bind('s', lambda {@board.move_down})
  end

  def buttons
    worker_h = GameButton.new('Human Worker', 'grey') {x = rand(0..@board.num_columns-1); y = rand(0..@board.num_rows-1); @board.new_unit(Pos.new(x,y), Worker.new(Pos.new(x,y)))}
    worker_h.place(20, 100, 10+@map.map_size+@info.width+@photo.photo_size, @board.block_size*@board.num_rows + 10)

    melee_h = GameButton.new('Human Grunt', 'grey') {x = rand(0..@board.num_columns-1); y = rand(0..@board.num_rows-1); @board.new_unit(Pos.new(x,y), Grunt.new(Pos.new(x,y), false))}
    melee_h.place(20, 100, 10+@map.map_size+@info.width+@photo.photo_size, @board.block_size*@board.num_rows + 10+20)

    ranged_h = GameButton.new('Human Ranged', 'grey') {x = rand(0..@board.num_columns-1); y = rand(0..@board.num_rows-1); @board.new_unit(Pos.new(x,y), Ranger.new(Pos.new(x,y), false))}
    ranged_h.place(20, 100, 10+@map.map_size+@info.width+@photo.photo_size, @board.block_size*@board.num_rows + 10+20+20)
    
    healer_h = GameButton.new('Human Healer', 'grey') {x = rand(0..@board.num_columns-1); y = rand(0..@board.num_rows-1); @board.new_unit(Pos.new(x,y), Healer.new(Pos.new(x,y), false))}
    healer_h.place(20, 100, 10+@map.map_size+@info.width+@photo.photo_size, @board.block_size*@board.num_rows + 10+20+20+20)

    hero_h = GameButton.new('Human Hero', 'grey') {x = rand(0..@board.num_columns-1); y = rand(0..@board.num_rows-1); @board.new_unit(Pos.new(x,y), Hero.new(Pos.new(x,y), 20, false))}
    hero_h.place(20, 100, 10+@map.map_size+@info.width+@photo.photo_size, @board.block_size*@board.num_rows + 10+20+20+20+20)

    melee_z = GameButton.new('Zombie Grunt', 'grey') {x = rand(0..@board.num_columns-1); y = rand(0..@board.num_rows-1); @board.new_unit(Pos.new(x,y), Grunt.new(Pos.new(x,y), true))}
    melee_z.place(20, 100, 10+@map.map_size+@info.width+@photo.photo_size+100, @board.block_size*@board.num_rows + 10)

    ranged_z = GameButton.new('Zombie Ranged', 'grey') {x = rand(0..@board.num_columns-1); y = rand(0..@board.num_rows-1); @board.new_unit(Pos.new(x,y), Ranger.new(Pos.new(x,y), true))}
    ranged_z.place(20, 100, 10+@map.map_size+@info.width+@photo.photo_size+100, @board.block_size*@board.num_rows + 10+20)
    
    healer_z = GameButton.new('Zombie Healer', 'grey') {x = rand(0..@board.num_columns-1); y = rand(0..@board.num_rows-1); @board.new_unit(Pos.new(x,y), Healer.new(Pos.new(x,y), true))}
    healer_z.place(20, 100, 10+@map.map_size+@info.width+@photo.photo_size+100, @board.block_size*@board.num_rows + 10+20+20)

    hero_z = GameButton.new('Zombie Hero', 'grey') {x = rand(0..@board.num_columns-1); y = rand(0..@board.num_rows-1); @board.new_unit(Pos.new(x,y), Hero.new(Pos.new(x,y), 20, true))}
    hero_z.place(20, 100, 10+@map.map_size+@info.width+@photo.photo_size+100, @board.block_size*@board.num_rows + 10+20+20+20)
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

  def draw_character (character, other_character, old=nil, other_old=nil)
    charmoved = false
    othercharmoved = false
    character.each {|char| if (char.moved) then (charmoved = true) end }
    other_character.each {|char| if (char.moved) then (othercharmoved = true) end }
    if old != nil and charmoved and othercharmoved and other_old != nil
      old.each{|char| char.remove}
      other_old.each{|char| char.remove}
    end
    size = @board.block_size
    puts other_character
    other_character.map{|n| start = n.position;
      char = TkcRectangle.new(@canvas.canvas, start[0]*size, start[1]*size,
                       start[0]*size + size, start[1]*size + size, 'fill' => n.color);
#    other_character.bind('ButtonPress-1') { @board.move_left }
      char.bind('Control-ButtonPress-1') { @board.move_right };
      char.bind('Shift-ButtonPress-1') { @board.move_left };
      char.bind('Double-1') { @board.move_left };
      char}
    puts other_character
    character.map{|n| start = n.position;
      char = TkcText.new(@canvas.canvas, start[0]*size + 9, start[1]*size + 9, 'text' => n.symbol);
#    newCharacter.bind('ButtonPress-1') { @board.move_left }
      char.bind('Control-ButtonPress-1') { @board.move_right };
      char.bind('Shift-ButtonPress-1') { @board.move_left };
      char.bind('Double-1') { @board.move_left };
      char}
    [character, other_character]
  end
end

srand
