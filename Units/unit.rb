require_relative '../Utilities/Pos'

class Unit
  def initialize(position,health)
    @pos, @unitHealth = position, health
    defaultParameters()
  end

  def defaultParameters
    @isReady = true
    @isAttacking = false
    @isMoving = false
    @isHolding = false
    @isPatrolling = false
    @patrollArr = Array.new
    @moveQueue = Queue.new
    @moveObjective = nil;
    @attackTarget = nil;
  end

  def step
    if(@isReady)
      if(@isMoving)
        pos = @moveQueue.pop
        if(@isPatrolling)
          @moveQueue.push(pos)
        end
        moveTo(pos)
        @isReady = false
        moveNext
      elsif(@isAttacking)
        @isReady = false
        attackNext
    else
      if(@isMoving)
        moveNext
      elsif(@isAttacking)
        attackNext
      end
    end
  end

  def moveNext
    #AI to decide next move position
  end

  def attackNext
    #AI to decide what to attack next
  end

  def moveTo(Pos)
    defaultParameters
    @isMoving = true;
    @moveObjective = Pos
  end

  def setMoveQueue(posArr)   
    @moveQueue = posArr #can I do this?
  end

  def attackMove(Pos)
    defaultParameters
    @isAttacking = true
    @attackPosition = Pos
  end

  def attackUnit(u)
    defaultParameters()
    @isAttacking = true
    #TODO: attacking unit
  end

  def hold
    defaultParameters()
    @isHolding = true
  end
end
