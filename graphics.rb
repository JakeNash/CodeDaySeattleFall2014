require 'tk'

class GameRoot
  def initialize
    @root = TkRoot.new('height' => 700, 'width' => 1350,
             'background' => 'black') {title "Game"}    
  end

  def bind(char, callback)
    @root.bind(char, callback)
  end

  # Necessary so we can unwrap before passing to Tk in some instances.
  attr_reader :root
end

class GameTimer
  def initialize
    @timer = TkTimer.new
  end

  def stop
    @timer.stop
  end

  def start(delay, callback)
    @timer.start(delay, callback)
  end
end

class GameCanvas
  def initialize
    @canvas = TkCanvas.new('background' => 'black')
  end

  def place(height, width, x, y)
    @canvas.place('height' => height, 'width' => width, 'x' => x, 'y' => y)
  end

  def unplace
    @canvas.unplace
  end

  def delete
    @canvas.delete
  end

  # Necessary so we can unwrap before passing to Tk in some instances.
  attr_reader :canvas
end

class GameLabel
  def initialize(wrapped_root, &options)
    unwrapped_root = wrapped_root.root
    @label = TkLabel.new(unwrapped_root, &options)
  end

  def place(height, width, x, y)
    @label.place('height' => height, 'width' => width, 'x' => x, 'y' => y)
  end

  def text(str)
    @label.text(str)
  end
end

class GameButton
  def initialize(label, color)
    @button = TkButton.new do 
      text label
      background color
      command (proc {yield})
    end
  end

  def place(height, width, x, y)
    @button.place('height' => height, 'width' => width, 'x' => x, 'y' => y)
  end
end

class GameRect
  def initialize(wrapped_canvas, a, b, c, d, color)
    unwrapped_canvas = wrapped_canvas.canvas
    @rect = TkcRectangle.new(unwrapped_canvas, a, b, c, d, 
                             'outline' => 'black', 'fill' => color)
  end

  def remove
    @rect.remove
  end

  def move(dx, dy)
    @rect.move(dx, dy)
  end

end

def mainLoop
  Tk.mainloop
end

def exitProgram
  Tk.exit
end
