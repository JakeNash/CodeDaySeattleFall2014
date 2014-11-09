class Grunt < Unit
  def initialize(position,isZombie)
    health = 100
    production_time = 10
    aggro_range = 10
    cost = 10
    symbol = ""
    color = ""
    if(isZombie)
      symbol = "G"
      color = "green"
    else
      symbol = "G"
      color = "LightSkyBlue"
    end
    super(position,health,1,color,symbol,production_time,aggro_range,isZombie,cost)
  end
end
