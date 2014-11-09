require_relative '../Utilities/Pos'
require_relative '../game'

class Unit
  def initialize(position,health,range,color,symbol,productionTime,aggroRange,isZombie)
    include ClassLevelInheritableAttributes
    inheritable_attributes :pos, :health, :maxHealth, :isReady, :isAttacking, :isMoving, :isHolding, :isPatrolling, :moveQueue, :moveObjective, :attackTarget, :range, :color, :symbol, :productionTime, :aggroRange, :isZombie
    @pos, @health, @maxHealth = position, health, health
    @range = range
    @color = color
    @symbol = symbol
    @productionTime = productionTime
    @aggroRange = aggroRange
    @isZombie = isZombie
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
    else
      enemy = Board.nearest_enemy_aggro(self)
      if(emeny != nil)
        @attackTarget = enemy
        attackNext
      end
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
      if(@attackTarget.health < 1)
        @attackTarget = findNextTarget
      end
    else
      @attackTarget = findNextTarget
    end

    if(@attackTarget != nil) #attack or move closer if target found
      if(isInRangeOfUnit(@attackTarget))
        damage = damageCalculate(@attackTarget)
        @attackTarget.health -= damage
      else
        attackMove(@attackTarget.pos)
        @moveObjective = @attackTarget.pos
        moveNext
      end
    else #target not found on way to path
      @moveObjective = @attackObjective
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
    @attackTarget = Board.nearest_enemy_unit(self,@moveObjective)
  end

  def isInAggroRange(unit)
    return (unit.pos.x - this.pox.x).abs <= @aggroRange && (unit.pos.y - this.pos.y).abs <= @aggroRange
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
