#attackTarget is used as healing target

class Healer < Unit
  def initialize(position,isZombie)
    health = 100
    production_time = 10
    range = 5
    aggro_range = 10
    cost = 10
    symbol = ""
    color = ""
    if(isZombie)
      symbol = "H"
      color = "green"
    else
      symbol = "H"
      color = "LightSkyBlue"
    end
    super(position,health,range,color,symbol,production_time,aggro_range,isZombie,cost)
    @isHealing = true
  end

  def step
    @isAttacking = false
    if(@isMoving)
      super
    elsif(@isHealing)
      healNext
    end
  end

  def healNext
    #targeting
    if(@attackTarget != nil && @attackTarget.health == attackTarget.maxHealth)
      @attackTarget = findNextFriendlyTarget
    else
      @attackTarget = findNextFriendlyTarget
    end

    if(@attackTarget != nil) #heal or move closer
      if(isInRangeOfUnit(@attackTarget))
        heal = healCalculate(@attackTarget)
        @attackTarget.health += heal
      else
        healMove(@attackTarget.pos)
        @moveObjective = @attackTarget.pos
        moveNext
      end
    else #target not found on way to path
      @moveObjective = @attackObjective
      moveNext
    end
  end

  #make sure to not heal more than max health
  def healCalculate
    #TODO: calculate heal
  end

  def healMove(position)
    defaultParameters
    @isHealing = true
    @attackPosition = position
  end
    
  def findNextFriendlyTarget
    @attackTarget = Board.nearest_friendly_unit(self,@moveObjective)
  end
end
