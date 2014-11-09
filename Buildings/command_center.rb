require_relative '../Units/worker.rb'

class CommandCenter < Building
  def initialize(position)
    SIZE = 5
    HEALTH = 100
    super(position,SIZE,HEALTH)
    @workerCount = 0
  end

  def queueProduction
    @productionQueue.push(Worker.new)
  end

  def addWorker
    @workerCount += 1
  end

  def unloadWorker
    @workerCount -= 1
    worker = Worker.new
    produceUnit(worker)
  end

  def calculateIncome
    #TODO: calculate income based on workers with exponential decay / log
  end

  def step
    super
    Game.resources += calculateIncome
  end
end
      
