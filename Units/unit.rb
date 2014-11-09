require_relative '../Utilities/Pos'
require_relative '../game'

class Unit
  def initialize(position,health,range,color,symbol,productionTime)
    include ClassLevelInheritableAttributes
    inheritable_attributes :pos, :unitHealth, :isReady, :isAttacking, :isMoving, :isHolding, :isPatrolling, :moveQueue, :moveObjective, :attackTarget, :range, :color, :symbol, :productionTime
    @pos, @unitHealth = position, health
    @range = range
    @color = color
    @symbol = symbol
    @productionTime = productionTime
    defaultParameters
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
        else
          @isMoving = false
        end
      else
        moveNext
      end
    elsif(@isAttacking)
      attackNext
    end
  end

  def moveNext
    moves = getValidMoves
    bestMove = moves[0]
    leastDistance = moves[0].distance_to(@moveObjective)
    for i in 1..(moves.length - 1)
      distance = moves[i].distance_to(@moveObjective)
      if (distance < leastDistance)
        leastDistance = distance
        bestMove = moves[i]
      end
    end
    @pos = bestMove
    Board.move_unit(@pos,self)
  end

  def getValidMoves
    arr = Array.new
    for i in (@pos.x - 1)..(@pos.x + 1)
      for j in (@pos.y - 1)..(@pos.y + 1)
        if(Board.empty_at([i,j]))
          arr.push(Pos.new(i,j))
        end
      end
    end
    return arr
  end

  def attackNext
    #targeting
    if(@attackTarget != nil)
      if(@attackTarget.unitHealth < 1)
        @attackTarget = findNextTarget
      end
    else
      @attackTarget = findNextTarget
    end

    #attack or move closer
    if(isInRangeOfUnit(@attackTarget))
      damage = damageCalculate(@attackTarget)
      @attackTarget.unitHealth -= damage
    else
      attackMove(@attackTarget.pos)
      @moveObjective = @attackTarget.pos
      moveNext
    end
  end

  def damageCalculate(target)
    #TODO: calculate damage
  end

  def moveTo(pos)
    defaultParameters
    @isMoving = true;
    @moveObjective = pos
  end

  def setMoveQueue(posArr)   
    @moveQueue = posArr
  end
  
  def findNextTarget
    @attackTarget = Board.nearest_enemy_unit
  end

  def isInRangeOfUnit(unit)
    return (unit.pos.x - this.pox.x).abs <= @range && (unit.pos.y - this.pos.y).abs <= @range
  end

  def isInRangeOfPosition(position)
    return (position.x - this.pos.x).abs <= @range && (position.y - this.pos.y).abs <= @range
  end

  def attackMove(pos)
    defaultParameters
    @isAttacking = true
    @attackPosition = pos
  end

  def hold
    defaultParameters
    @isHolding = true
  end
end
