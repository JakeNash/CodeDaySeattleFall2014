class Spell
  def initialize(name,effect)
    @name = name
    @effect = effect
  end

  def placeOnGrid(position)
    Board.new_spell(position,self)
  end
end
