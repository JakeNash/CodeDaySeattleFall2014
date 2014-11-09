require_relative '../Utilities/Pos'
require_relative '../game'

class Building
  def initialize(position,size,health,buildTime)
    include ClassLevelInheritableAttributes
    inheritable_attributes :pos, :buildingHealth, :buildingSize, :isProducing, :productionProgress, :isReady, :productionQueue, :currentProduction, :rallyPos, :productionPos, :buildTime
    @pos, @buildingHealth, @buildingSize = position, health, size
    @isProducing = false
    @productionProgress = 0;
    @isReady = true;
    @productionQueue = Array.new
    @productionPos = Pos.new(@pos.x, @pox.y - size)
    @rallyPos = @productionPos
    @buildTime = buildTime
  end

  def step
    if(@isProducing)
      if(@isReady)
        @currentProduction = @productionQueue.pop #pops next unit to produce
        @productionProgress = @currentProduction.productionTime
      else
        if(productionProgress == 0)
          produceUnit(@currentProduction)
          @isReady = true
        else
          @productionProgress -= 1
        end
      end
    end
  end

  def produceUnit(u)
    Board.new_unit(@productionPos,u)
    u.moveTo(@rallyPos)
  end
end
