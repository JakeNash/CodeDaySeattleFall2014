class ModelData
  
  def initialize (grid, name, health, max_health, resources, supply, cap)
    @grid = grid
    @name = name
    @health = health
    @max_health = max_health
    @resources = resources
    @supply = supply
    @cap = cap
  end

  def data
    @data = Hash.new
  end

end
