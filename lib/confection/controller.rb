module Confection

  # The Controller class is used to encapsulate the two types of invocation
  # that are posible on configuration blocks.
  #
  class Controller < Module

    #
    #
    #
    def initialize(scope, *configs)
      @scope   = scope
      @configs = configs
    end

    #
    #
    #
    def text
      txt = []
      @configs.each do |c|
        str << c.text if c.text
      end
      txt.join("\n\n")
    end

    alias to_s text


    #
    #
    #
    def call
      @scope.instance_eval(&self)
      #@config.each do |config|
      #  instance_eval(config.text, config.file)
      #end
    end

    #
    #
    #
    def load #(*args)
      #::Kernel.eval('self',::TOPLEVEL_BINDING).instance_exec(*args, &self)
      ::Kernel.eval('self',::TOPLEVEL_BINDING).instance_eval(&self)
    end

    #
    # Only applicable to script and block configs.
    #
    def to_proc
      properties = ::Confection.properties
      __configs__ = @configs
      block = Proc.new do
        __configs__.each do |config|
          case config
          when ScriptConfig
            Kernel.eval(config.read, binding, config.file)
          when BlockConfig
            config.block.call
            #binding.eval(&config.block) #Kernel.eval(config.read, binding, config.file)
          end
        end
      end
    end

  end

  #
  class NullController
    def exec(*); end
    def call(*); end
    def text; ''; end
    alias to_s text
  end

end
