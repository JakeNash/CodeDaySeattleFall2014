class Spell
  def initialize(name,effect)
    @name = name
    @effect = effect
    @isZombie = false
  end

  def placeOnGrid(position)
    Board.new_spell(position,self)
  end
end
