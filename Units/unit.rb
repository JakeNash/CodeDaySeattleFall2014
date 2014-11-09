require_relative '../Utilities/Pos'
require_relative '../game'

class Unit
  def initialize(position,health)
    include ClassLevelInheritableAttributes
    inheritable_attributes :pos, :unitHealth, :isReady, :isAttacking, :isMoving, :isHolding, :isPatrolling, :moveQueue, :moveObjective, :attackTarget, :range
    @pos, @unitHealth = position, health
    @range = 0;
    defaultParameters()
  end

  def defaultParameters
    @isReady = true
    @isAttacking = false
    @isMoving = false
    @isHolding = false
    @isPatrolling = false
    @moveQueue = Array.new
    @moveObjective = nil;
    @attackTarget = nil;
  end

  def step
    if(@isMoving)
      if(@isReady)
        pos = @moveQueue.pop
        if(pos != nil)
          if(@isPatrolling)
            @moveQueue.push(pos)
          end
          moveTo(pos)
          @isReady = false
          moveNext
        end
      else
        moveNext
      end
    elsif(@isAttacking)
      attackNext
    end
  end

  def moveNext
    #TODO: AI to decide next move position
  end

  def attackNext
    if(@attackTarget != nil)
      if(@attackTarget.unitHealth < 1)
        @attackTarget = findNextTarget
      end
      damage = damageCalculate(self, @attackTarget)
      @attackTarget.unitHealth
    end
    #TODO: AI to decide what to attack next
  end

  def damageCalculate(unit1,unit2)
    #TODO: calculate damage
  end

  def moveTo(Pos)
    defaultParameters
    @isMoving = true;
    @moveObjective = Pos
  end

  def setMoveQueue(posArr)   
    @moveQueue = posArr
  end
  
  def findNextTarget
    
    #TODO: AI to decide next target
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
