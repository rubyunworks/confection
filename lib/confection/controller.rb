module Confection

  # The Controller class is used to encapsulate the two types of invocation
  # that are posible on configuration blocks.
  #
  class Controller

    include Enumerable

    #
    # Initialize new Controller instance.
    #
    # @param [Object] scope
    #
    # @param [Array<Config>] configs
    #
    def initialize(scope, *configs)
      @scope   = scope
      @configs = configs
    end

    #
    # Iterate over each config.
    #
    def each(&block)
      @configs.each(&block)
    end

    #
    # Number of configs.
    #
    def size
      @configs.size
    end

    #
    # Execute the configuration code.
    #
    def call(*args)
      each do |config|
        config.block.call(*args) if config.block
      end
    end

    #
    # Evaluate configuration in the context of the caller.
    #
    # This is the same as calling:
    #
    #   instance_exec(*args, &config)
    #
    def exec(*args)
      each do |config|
        if config.block
          #@scope.extend(config.dsl) # ?
          @scope.instance_exec(*args, &config)
        end
      end
    end

    #
    # Load config as script code in context of TOPLEVEL.
    #
    # This is the same as calling:
    #
    #   main = ::TOPLEVEL_BINDING.eval('self')
    #   main.instance_exec(*args, &config)
    #
    def main_exec(*args)
      main = ::Kernel.eval('self', ::TOPLEVEL_BINDING)  # ::TOPLEVEL_BINDING.eval('self') [1.9+]
      each do |config|
        if config.block
          #main.extend(config.dsl)
          main.instance_exec(*args, &config)
        end
      end
    end

    # @deprecated Alias for `#main_exec` might be deprecated in future.
    alias load main_exec

    #
    # Only applicable to script and block configs, this method converts
    # a set of code configs into a single block ready for execution.
    #
    def to_proc
      properties = ::Confection.properties  # do these even matter here ?
      __configs__ = @configs
      block = Proc.new do |*args|
        #extend dsl  # TODO: extend DSL into instance context ?
        __configs__.each do |config|
          if config.block
            instance_exec(*args, &config.block)
          end
        end
      end
    end

    #
    # Configurations texts joins together the contents of each
    # configuration separated by two newlines (`\n\n`).
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
    # Treat configurations as YAML mappings, load, merge and return.
    #
    def yaml
      @configs.inject({}) do |h, c|
        h.merge(c.yaml)
      end
    end

    #
    # Inspection string for controller.
    #
    def inspect
      "#<#{self.class}##{object_id}>"
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
