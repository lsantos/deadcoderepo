module AccessControl
  extend self

    def configure(&block)
      instance_eval(&block)
    end

    def definitions
      @definitions ||= Hash.new
    end

    def role(level, options={})  
      puts "calling role with => #{level}, #{options.inspect}"
      definitions[level] = Role.new(level, options)
    end

    def roles_with_permission(permission)
      definitions.select { |k,v| v.allows?(permission) }.map { |k,_| k }
    end

    def [](level)
      definitions[level]
    end

    class Role
      def initialize(name, options)
        @name        = name
        @permissions = options[:permissions]
        @parent      = options[:parent]
      end

      attr_reader :parent

      def permissions
        return @permissions unless parent

        @permissions + AccessControl[parent].permissions
      end

      def allows?(permission)
        permissions.include?(permission)
      end

      def to_s
        @name
      end
    end

end

AccessControl.configure do
  role "basic", 
      :permissions => [:read_answers, :answer_questions]

  role "premium", 
    :parent      => "basic",
    :permissions => [:hide_advertisements]

  role "manager", 
    :parent      => "premium",
    :permissions => [:create_quizzes, :edit_quizzes]

  role "owner",
    :parent      => "manager",
    :permissions => [:edit_users, :deactivate_users]
end    

