class Grunt < Unit
  def initialize(position)
    HEALTH = 100
    PRODUCTION_TIME = 10
    SYMBOL = ""
    COLOR = ""
    if(isZombie)
      SYMBOL = "G"
      COLOR = "green"
    else
      SYMBOL = "G"
      COLOR = "LightSkyBlue"
    end
    super(position,HEALTH,1,COLOR,SYMBOL,PRODUCTION_TIME)
  end
end
