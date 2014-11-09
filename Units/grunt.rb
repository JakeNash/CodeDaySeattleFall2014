class Grunt < Unit
  def initialize(position,isZombie)
    HEALTH = 100
    PRODUCTION_TIME = 10
    AGGRO_RANGE = 10
    COST = 10
    SYMBOL = ""
    COLOR = ""
    if(isZombie)
      SYMBOL = "G"
      COLOR = "green"
    else
      SYMBOL = "G"
      COLOR = "LightSkyBlue"
    end
    super(position,HEALTH,1,COLOR,SYMBOL,PRODUCTION_TIME,AGGRO_RANGE,isZombie,COSTa)
  end
end
