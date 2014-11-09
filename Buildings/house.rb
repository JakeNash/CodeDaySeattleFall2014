class House < Building
  def initialize(position,isZombie)
    SIZE = 2
    HEALTH = 100
    BUILD_TIME = 10
    COST = 100
    SYMBOL = ""
    COLOR = ""
    if(isZombie)
      SYMBOL = "S"
      COLOR = "green"
    else
      SYMBOL = "S"
      COLOR = "LightSkyBlue"
    end
    super(position,SIZE,HEALTH,BUILD_TIME,SYMBOL,COLOR,isZombie,COST)
  end
end
