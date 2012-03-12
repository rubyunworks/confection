module Confection

  #
  #
  module Manage

    #
    def controller(scope, name, profile)
      configs = confile.lookup(name, profile)
      Controller.new(scope, *configs)
    end

    #
    def confile
      @confile ||= Confile.load
    end

    #
    def clear!
      confile.clear!
    end

    #
    def profiles(tool)
      confile.profiles(tool)
    end

    #
    def each(&block)
      confile.each(&block)
    end

    #
    def size
      confile.size
    end

    #
    # Project properties.
    #
    def properties
      confile.properties
    end

  end

  extend Manage

end
