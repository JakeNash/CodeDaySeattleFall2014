class Worker < Unit
  def initialize(position)
    HEALTH = 100
    super(position,HEALTH,0)
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

