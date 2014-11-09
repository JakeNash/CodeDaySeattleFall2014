class Hero < Unit
  def initialize(position,productionTime,isZombie)
    HEALTH = 100
    PRODUCTION_TIME = productionTime
    RANGE = 10
    AGGRO_RANGE = 10
    COST = 0
    SYMBOL = ""
    COLOR = ""
    if(isZombie)
      SYMBOL = "$"
      COLOR = "gold2"
    else
      SYMBOL = "$"
      COLOR = "gold2"
    end
    super(position,HEALTH,RANGE,COLOR,SYMBOL,PRODUCTION_TIME,AGGRO_RANGE,isZombieCOST)
    @spellBook = Hash.new
    @isCasting = false
    @castingPosition = nil
    @currentSpell = nil
  end

  def step
    if(@isCasting && isInRangeOfPosition(@castingPosition))
      placeSpell(@castingPosition,@currentSpell)
    elsif(@isCasting && !isInRangeOfPosition(@castingPosition))
      moveNext
    elsif(@isMoving || @isAttacking)
      super
    end
  end

  def addSpell(s)
    @spellBook[s.name] = s
  end

  def castSpell(position,spell)
    @castingPosition = position
    @currentSpell = spell
    @isCasting = true
  end

  def placeSpell(position,spell)
    spell.placeOnGrid(position)
  end
end
