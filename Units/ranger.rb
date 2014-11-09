class Ranger < Unit
  def initialize(position,isZombie)
    HEALTH = 100
    PRODUCTION_TIME = 10
    RANGE = 5
    AGGRO_RANGE = 10
    SYMBOL = ""
    COLOR = ""
    if(isZombie)
      SYMBOL = "R"
      COLOR = "green"
    else
      SYMBOL = "R"
      COLOR = "LightSkyBlue"
    end
    super(position,HEALTH,RANGE,COLOR,SYMBOL,PRODUCTION_TIME,AGGRO_RANGE,isZombie)
  end
end
    
