require_relative './unit'

class Worker < Unit
  def initialize(position)
    health = 100
    production_time = 10
    aggro_range = 10
    symbol = "W"
    cost = 10
    super(position,health,1,"LightSkyBlue",symbol,production_time,aggro_range,false,cost)
    @isBuilding = false
    @buildQueue = Array.new
    @currentBuilding = nil
    @currentBuildingPos = nil
  end

  def step
    if(@isMoving || @isAttacking)
      super
    elsif(@isBuilding)
      buildNext
    end
  end
      
  def buildNext
    if(@currentBuilding.buildTime == 0)
      Game.game.board.new_building(@currentBuildingPos,@currentBuilding)
      building = buildQueue.pop
      Game.game.resources -= building.cost
      if(building != nil)
        @currentBuilding = building[0] #building object
        @currentBuildingPos = building[1] #building position
        moveTo(@currentBuildingPos)
      else
        @isBuilding = false
      end
    else
      @currentBuilding.buildTime -= 1
    end
  end

  def setBuildQueue(bQueue)
    @buildQueue = bQueue
  end
end

