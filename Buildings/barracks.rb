require_relative '../Units/grunt.rb'
require_relative '../Units/ranged.rb'
require_relative '../Units/healer.rb'

class Barracks < Building
  def initialize(position,isZombie)
    SIZE = 3
    HEALTH = 100
    BUILD_TIME = 10
    SYMBOL = ""
    COLOR = ""
    if(isZombie)
      SYMBOL = "B"
      COLOR = "green"
    else
      SYMBOL = "B"
      COLOR = "LightSkyBlue"
    end
    super(position,SIZE,HEALTH,BUILD_TIME,SYMBOL,COLOR,isZombie)
    @canBuildMelee = true;
    @canBuildRanged = false;
    @canBuildHealer = false;
  end
  
  def queueProduction(key)
    if(key == "grunt")
      @productionQueue.push(Grunt.new(@productionPos,false))
    elsif(key == "ranged")
      @productionQueue.push(Ranged.new(@productionPos,false))
    elsif(key == "healer")
      @productionQueue.push(Healer.new(@productionPos,false))
    elsif(key == "research_ranged")
      @productionQueue.push(Research.new(key))
    elsif(key == "research_healer")
      @productionQueue.push(Research.new(key))
    end
  end
end
