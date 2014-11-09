class Ranger < Unit
  def initialize(position,isZombie)
    HEALTH = 100
    PRODUCTION_TIME = 10
    SYMBOL = ""
    COLOR = ""
    if(isZombie)
      SYMBOL = "R"
      COLOR = "green"
    else
      SYMBOL = "R"
      COLOR = "LightSkyBlue"
    end
    super(position,HEALTH,5,COLOR,SYMBOL,PRODUCTION_TIME)
  end
end
    
