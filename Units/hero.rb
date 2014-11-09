class Hero < Unit
  def initialize(position,productionTime)
    HEALTH = 100
    PRODUCTION_TIME = productionTime
    SYMBOL = ""
    COLOR = ""
    if(isZombie)
      SYMBOL = "H"
      COLOR = "gold2"
    else
      SYMBOL = "H"
      COLOR = "gold2"
    end
    super(position,HEALTH,10,COLOR,SYMBOL,PRODUCTION_TIME)
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
