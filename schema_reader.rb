class SchemaReader
  attr_accessor :project_path
  
  CLASS_TEMPLATE = %{
    package #{package_name}
    /**
    * Auto generated code, don't change this!
    **/
    class #{class_name} {
      methods.each do |method|
        void #{method}{
        
        }
        
      end
    }
  }
  
  
  
  def run
    
  end
end