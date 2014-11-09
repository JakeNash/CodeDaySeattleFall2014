require_relative '../Units/worker.rb'

class CommandCenter < Building
  def initialize(position,isZombie)
    SIZE = 5
    HEALTH = 100
    BUILD_TIME = 10
    COST = 100
    SYMBOL = ""
    COLOR = ""
    if(isZombie)
      SYMBOL = "C"
      COLOR = "green"
    else
      SYMBOL = "C"
      COLOR = "LightSkyBlue"
    end
    super(position,SIZE,HEALTH,BUILD_TIME,SYMBOL,COLOR,isZombie,COST)
    @workerCount = 0
  end

  def queueProduction
    @productionQueue.push(Worker.new(@productionPos,false))
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
    return @workerCount*5
  end

  def step
    super
    Game.game.resources += calculateIncome
  end
end
      
