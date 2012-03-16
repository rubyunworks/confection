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
      case args.first
      when Symbol
        profile = args.shift
      when String
        profile = args.shift unless args.first.index("\n")
      end

      case args.first
      when Hash
        data = args.shift
        from = data[:from] # special key
      when Proc
        data = args.shift
        # TODO convert data into OpenHash like object
      when String
        data = args.shift
        data = data.tabto(0)
      end

      raise ArgumentError, "too many arguments"      if args.first
      raise SyntaxError,   "nested profile sections" if profile && @_options[:profile]
      #raise ArgumentError, "use block or :from  setting" if options[:from]  && block

      profile = @_options[:profile] unless profile

      if from
        @_store.import(tool, profile, data, &block)
        data = nil
        return unless block
      end

      #original_state = @_options.dup

      if data && block
        raise ArgumentError, "must use data or block, not both"
      end
    
      #@_options[:tool]  = tool
      #@_options[:block] = block if block
      #@_options[:data]  = data  if data
      #@_options[:text]  = text  if text

      #raise ArgumentError, "use text or block" if text && block
      #raise ArgumentError, "use block or data" if block && data
      #raise ArgumentError, "use data or text"  if data && text

      @_store << Config.new(tool, profile, data, &block)

      #@_options = original_state
    end

    # TODO: use `:default` profile instead of `nil` ?

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
