#attackTarget is used as healing target

class Healer < Unit
  def initialize(position,isZombie)
    HEALTH = 100
    PRODUCTION_TIME = 10
    RANGE = 5
    AGGRO_RANGE = 10
    SYMBOL = ""
    COLOR = ""
    if(isZombie)
      SYMBOL = "H"
      COLOR = "green"
    else
      SYMBOL = "H"
      COLOR = "LightSkyBlue"
    end
    super(position,HEALTH,RANGE,COLOR,SYMBOL,PRODUCTION_TIME,AGGRO_RANGE,isZombie)
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
