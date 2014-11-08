require_relative './graphics'

class Board

  def initialize (game)
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @game = game
    @delay = 500
  end

  # both the length and width of a block, since it's a square
  def block_size
    15
  end

  def num_columns
    88
  end

  def num_rows
    35
  end

  # the current delay
  def delay
    @delay
  end

  def game_over?
    
  end

  def run
    draw
  end

  def draw
    
  end
end


class Game

  # creates window and starts the game
  def initialize
    @root = GameRoot.new
    @timer = GameTimer.new
    set_board
    @running = true
    key_bindings
    buttons
    run_game
  end

  # creates a canvas and the board that interacts with it
  def set_board
    @canvas = GameCanvas.new
    @board = Board.new(self)
    @canvas.place(@board.block_size * @board.num_rows,
                  @board.block_size * @board.num_columns, 10, 10)
    @board.draw
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
end
