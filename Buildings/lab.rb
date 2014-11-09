class Lab < Building
  def initialize(position,isZombie)
    SIZE = 2
    HEALTH = 100
    BUILD_TIME = 10
    SYMBOL = ""
    COLOR = ""
    if(isZombie)
      SYMBOL = "L"
      COLOR = "green"
    else
      SYMBOL = "L"
      COLOR = "LightSkyBlue"
    end
    super(position,SIZE,HEALTH,BUILD_TIME,SYMBOL,COLOR,isZombie)
  end
end
    
