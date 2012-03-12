module Confection

  # The DSL class is used to evaluate the configuration file.
  #
  class DSL < Module #BasicObject

    #
    # Class method initializes the DSL and evaluates the file.
    #
    def self.load(confile)
      cf = new(confile)
      if confile.file
        cf.__eval__(File.read(confile.file), confile.file)
      end
      cf
    end

    #
    # @param [Confile] confile
    #
    def initialize(confile)
      @confile = confile
    end

    # TODO: Separate properties from project metadata ?

    #
    # Project configuration properties.
    #
    def properties
      @properties ||= ::Confection.properties
    end

    #
    # Profile block.
    #
    def profile(name, options={}, &block)
      raise SyntaxError, "nested profile sections" if @_profile

      @_profile = name.to_sym
      instance_eval(&block)
      @_profile = nil
    end

    #
    # Configure a tool.
    #
    # @param [Symbol] tool
    #   The name of the tool to configure.
    #
    # @param [Hash] opts
    #   Configuration options.
    #
    # @options opts [String] :file
    #   File from which to load configuration.
    #
    # @options opts [String] :text
    #   Text of text-based configuration.
    #
    # @example
    #   config :rake, "*.rake"
    #
    # @example
    #   profile :cov do
    #     config :qed, "qed/simplecov.rb"
    #   end
    #
    # @todo Clean this code up.
    #
    def config(tool, *opts, &block)
      settings = (Hash === opts.last ? opts.pop : {})

      raise ArgumentError, "use block or :block setting" if settings[:block] && block

      settings[:tool]  = tool
      settings[:block] = block if block

      arg = opts.pop

      raise ArgumentError, "too many arguments" if opts.first

      if arg
        if arg.index("\n")  # not a file path
          settings[:text] = arg
        else
          raise ArgumentError if settings[:file]
          settings[:file] = arg
          settings[:text] = nil
        end
      end

      raise ArgumentError, "use file or text"   if settings[:file] && settings[:text]
      raise ArgumentError, "use file or block"  if settings[:file] && settings[:block]
      raise ArgumentError, "use text or block"  if settings[:text] && settings[:block]

      raise SyntaxError, "nested profile sections" if @_profile && settings[:profile]

      settings[:profile] ||= @_profile

      @confile.concat(Config.collect(settings))
    end

    #
    def import(tool, options={})
      if from = options[:from]
        cf = Confile.load(from)
      else
        cf = @confile
      end
      if cf
        config = confile.lookup(tool, options[:profile])
        @conffile << config if config
      else
        warn "no configuration file found in `#{from}'"
      end
    end

    #
    # Cached binding.
    #
    def __binding__
      @_binding ||= binding
    end

    #
    #
    #
    def __eval__(code, file=nil)
      Kernel.eval(code, __binding__, file || '(eval)')
    end

  end

end
