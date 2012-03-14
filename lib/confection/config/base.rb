module Confection

  module Config

    # Base class for other config types.
    #
    class Base

      #
      # When inherited add subclass to `Config.types` list.
      #
      def self.inherited(subclass)
        Config.types << subclass
      end

      #
      # Override this in subclasses. If should return `true` if
      # the arguments provided indicate the Config class applies.
      #
      def self.apply?(tool, options)
        false
      end

      #
      # Initialize Config instance. Config instances are per-configuration,
      # which means they are associated with one and only one config entry or
      # file.
      #
      def initialize(tool, options)
        initialize_require

        self.tool    = tool
        self.profile = options[:profile]
        self.file    = options[:file]

        # only set the type if given b/c file also sets the type
        self.type    = options[:type] if options[:type]
      end

      #
      # Override this no-op in subclass if extrnal library is needed.
      #
      def initialize_require
      end

      # The name of tool being configured.
      attr :tool

      def tool=(name)
        @tool = name.to_sym
      end

      # Profile to which this configuration belongs.
      attr :profile

      def profile=(name)
        @profile = name.to_sym if name
      end

      # Configuration type.
      attr :type

      def type=(type)
        @type = type.to_sym
      end

      # The `file` attribute is set to the path of source file if the
      # configuration came from a dedicated configuration file.
      attr :file

      def file=(path)
        @file = path
        self.type = File.extname(path).sub(/\./, '') if path
      end

      # Treat as YAML and load.
      #def yaml
      #  @yaml ||= YAML.load(to_s)
      #end

      #
      # Copy the configuration with alterations.
      #
      # @param [Hash] alt
      #   Alternate values for configuration attributes.
      #
      def copy(alt={})
        copy = dup
        alt.each do |k,v|
          copy.__send__("#{k}=", v)
        end
        copy
      end

      #
      # Ruby 1.9 defines #inspect as #to_s, ugh.
      #
      def inspect
        "#<#{self.class.name}:#{object_id} @tool=%s @profile=%s @type=%s>" % [tool.inspect, profile.inspect, type.inspect]
      end

    end

  end

end
