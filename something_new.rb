class SomethingNew
  module Base
    def my_method
      puts "(A)"
    end
  end

  module Extension
    def my_method
      puts "(B)"
      super
    end
  end

  include Base
  include Extension
end

SomethingNew.new.my_method