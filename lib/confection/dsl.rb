module Confection

  # The File class is used to evaluate the configuration file.
  #
  class DSL < Module #BasicObject

    #
    # @param [Store] Configuration storage instance.
    #
    def initialize(store)
      @_store   = store
      @_options = {}
    end

    # TODO: Separate properties from project metadata ?

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
      #raise ArgumentError, "use block or :from  setting" if options[:from]  && block

      return config_import(tool, options, &block) if options[:from]

      original_state = @_options.dup

      @_options.update(options)

      #@_options[:tool]  = tool
      @_options[:block] = block if block
      @_options[:text]  = text  if text

      raise ArgumentError, "use text or block" if text && block

      @_store << Config.factory(tool, @_options)

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
      from_profile = options[:from_profile] || options[:profile]

      raise ArgumentError, "nested profile sections" if options[:profile] && @_options[:profile]

      profile = options[:profile] || @_options[:profile]

      if from = options[:from]
        store = Project.load(from).store
      else
        store = @_store
      end

      raise "no configuration found in `#{from}'" unless store

      configs = store.lookup(from_tool, from_profile)

      configs.each do |config|
        new_config  = config.copy(:tool=>tool, :profile=>profile)

        #new_options = @_options.dup
        #new_options[:tool]    = tool
        #new_options[:profile] = profile
        #new_options[:block]   = config.block
        #new_options[:text]    = config.text

        # not so sure about this one
        if Config::Text === new_config
          new_config.text += ("\n" + options[:text].to_s) if options[:text]
        end

        @_store << new_config
      end

      if block
        options[:profile] = profile
        options[:block]   = block

        @_store << Config::Block.new(tool, options)
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
      instance_eval(::File.read(file), file) if file
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
