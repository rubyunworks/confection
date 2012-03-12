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
      @_confile = confile
      @_options = {}
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
      raise SyntaxError, "nested tool sections" if @_options[:profile]

      original_state = @_options.dup

      @_options.update(options)  # TODO: maybe be more exacting about this
      @_options[:profile] = name.to_sym

      instance_eval(&block)

      @_options = original_state
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
    def config(tool, *args, &block)
      options = (Hash === args.last ? args.pop : {})

      text = args.shift

      raise ArgumentError, "too many arguments"      if args.first
      raise SyntaxError,   "nested profile sections" if options[:profile] && @_options[:profile]
      raise ArgumentError, "tool option not allowed" if options[:tool]
      raise ArgumentError, "use text argument or :text option" if options[:text] && text
      raise ArgumentError, "use block or :from  setting" if options[:from]  && block

      return config_import(tool, options) if options[:from]

      original_state = @_options.dup

      @_options.update(options)

      @_options[:tool]  = tool
      @_options[:block] = block if block
      @_options[:text]  = text  if text

      raise ArgumentError, "use text or block" if @_options[:text] && @_options[:block]

      @_confile << Config.new(@_options)

      @_options = original_state
    end

    # TODO: should probably use `:default` profile instead of `nil`.

    #
    # Import configuration from another project's configuration file.
    #
    # @todo Better method method name for #remote.
    #
    def config_import(tool, options={}, &block)
      from_tool    = options[:from_tool] || tool
      from_profile = options[:from_profile]  # || options[:profile]  # could use if :default ?

      raise ArgumentError, "nexted profile sections" if options[:profile] && @_options[:profile]

      profile = options[:profile] || @_options[:profile]

      if from = options[:from]
        cf = Confile.load(from)
      else
        cf = @_confile
      end

      raise "no configuration file found in `#{from}'" unless cf

      if cf
        config = confile.lookup(from_tool, from_profile)
        if config
          new_options = @_options.dup
          new_options[:tool]    = tool
          new_options[:profile] = profile
          new_options[:block]   = config.block
          new_options[:text]    = config.text

          # not so sure about this one
          new_options[:text] += ("\n" + options[:text]) if options[:text]

          @_confile << Config.new(new_options)
        end

        if block
          options[:block] = block
          options[:text]  = nil

          @confile << Config.new(options)
        end
      end
    end
 
    #
    # Evaluate script directory into current scope.
    #
    # @todo Make a core extension ?
    #
    def import(feature)
      file = Find.load_path(feature).first
      raise LoadError, "no such file -- #{feature}" unless file
      instance_eval(File.read(file), file) if file
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
