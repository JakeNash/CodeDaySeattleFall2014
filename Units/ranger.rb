class Ranger < Unit
  def initialize(position,isZombie)
    health = 100
    production_time = 10
    range = 5
    aggro_range = 10
    cost = 10
    symbol = ""
    color = ""
    if(isZombie)
      symbol = "R"
      color = "green"
    else
      symbol = "R"
      color = "LightSkyBlue"
    end
    super(position,health,range,color,symbol,production_time,aggro_range,isZombie,cost)
  end
end
    
