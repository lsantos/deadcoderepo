  class Base
    attr_accessor :format, :width, :height, :zoom, :maptype, :latitude, :longitude

    def initialize
      @width = "250"
      @height = "250"
      @zoom = "15"
      @maptype = "mobile"
      @latitude = "-26.23472"
      @longitude = "27.98266"
    end

    def get_url(*args)
      if args.length < 2
        args[0] = @latitude
        args[1] = @longitude
      end
      return "http://maps.google.com/staticmap?center=#{args[0]},#{args[1]}&zoom=#{@zoom}&size=#{@width}x#{@height}&maptype=#{@maptype}\&markers=#{args[0]},#{args[1]}\&sensor=false";
    end
  end

  b=Base.new
  p b.get_url

