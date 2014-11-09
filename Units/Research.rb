class Research < Unit
  def initialize(name)
    PRODUCTION_TIME = 10
    super(nil,0,0,"","",PRODUCTION_TIME,0,false)
    @name = name
  end
end
