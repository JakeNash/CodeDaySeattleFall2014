class Hero < Unit
  def initialize(position,productionTime,isZombie)
    health = 100
    production_time = productionTime
    range = 10
    aggro_range = 10
    cost = 0
    symbol = ""
    color = ""
    if(isZombie)
      symbol = "$"
      color = "gold2"
    else
      symbol = "$"
      color = "gold2"
    end
    super(position,health,range,color,symbol,production_time,aggro_range,isZombieCOST)
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
