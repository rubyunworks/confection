module Confection

  # The Controller class is used to encapsulate the two types of invocation
  # that are posible on configuration blocks.
  #
  class Controller #< Module

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
        if config.block
          config.block.call(*args)
        else
          load config.file
        end
      end
    end

    #
    # Evaluate config as script code in context of caller.
    #
    def eval
      each do |config|
        #@scope.extend(config.dsl)
        if config.block
          @scope.instance_eval(&config)
        else
          @scope.instance_eval(config.text, config.file)
        end
      end
    end

    # TODO: TOPLEVEL_BINDING.eval

    #
    # Load config as script code in context of TOPLEVEL.
    #
    def load
      each do |config|
        #Kernel.eval('self', ::TOPLEVEL_BINDING).extend(config.dsl)
        if config.block
          Kernel.eval('self', ::TOPLEVEL_BINDING).instance_eval(&config)
        elsif code.file
          Kernel.eval(config.text, ::TOPLEVEL_BINDING, config.file)
        else

        end
      end
    end

    # @deprecated Alias for `#load` might be deprecated in future.
    alias eval load

    #
    # Only applicable to script and block configs, this method converts
    # a set of code configs into a single block ready for execution.
    #
    def to_proc
      properties = ::Confection.properties  # do these even matter here ?
      __configs__ = @configs
      block = Proc.new do |*args|
        #extend dsl  # TODO: extend DSL into instance convtext ?
        __configs__.each do |config|
          if config.block
            instance_exec(*args, &config.block)
          else
            instance_eval(config.text, config.file)
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
    # Treat configurations as INI documents, load, merge and return.
    # This method utilizes the optional `inifile` gem.
    #
    # Note that this currently only works with file-based configurations.
    #
    def ini(options)
      require 'inifile'
      configs = @configs.dup
      cfg = configs.shift
      ini = IniFile.load(cfg.file, options)
      configs.each do |c|
        ini.merge(IniFile.load(c.file, options))
      end
      ini
    end

    #
    # Treat configuration as XML document, load and return.
    #
    # @todo What library to use?
    #
    def xml
      raise NotImplementedError
    end

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
