class Filter
  attr_reader :objects
  
  def initialize(objects)
    @objects = objects
  end
  
  def filter(pattern)
    attrs = pattern.match(//)
    # attrs[0]  
  end
  
end