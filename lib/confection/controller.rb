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
    # Evaluate config as script code in context of caller.
    #
    def call
      each do |config|
        if config.block
          @scope.instance_eval(&config)
        else
          @scope.instance_eval(config.text, config.file)
        end
      end
    end

    #
    # Load config as script code in context of TOPLEVEL.
    #
    def load
      each do |config|
        if config.block
          ::Kernel.eval('self', ::TOPLEVEL_BINDING).instance_eval(&config)
        else
          ::Kernel.eval(config.text, ::TOPLEVEL_BINDING, config.file)
        end
      end
    end

    # @deprecated Alias for `#load` might be deprecated in future.
    alias eval load

=begin
    #
    # Only applicable to script and block configs, this method converts
    # a set of code configs into a single block ready for execution
    # by either the #call or #load methods. 
    #
    def to_proc
      properties = ::Confection.properties
      __configs__ = @configs
      block = Proc.new do
        __configs__.each do |config|
          if config.block
            config.block.call
          else
            #binding.eval(&config.block)
            Kernel.eval(config.text, binding, config.file)
          end
        end
      end
    end
=end

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
