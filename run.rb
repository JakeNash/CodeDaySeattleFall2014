require_relative './game'

def runGame
  Game.new 
  mainLoop
end

if ARGV.count == 0
  runGame
else
  puts "usage: run.rb"
end
