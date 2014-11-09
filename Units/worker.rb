class Worker < Unit
  def initialize(position)
    HEALTH = 100
    PRODUCTION_TIME = 10
    AGGRO_RANGE = 10
    SYMBOL = "W"
    super(position,HEALTH,1,"LightSkyBlue",SYMBOL,PRODUCTION_TIME,AGGRO_RANGE)
    @isBuilding = false
    @buildQueue - Array.new
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
      Board.new_building(@currentBuildingPos,@currentBuilding)
      building = buildQueue.pop
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

