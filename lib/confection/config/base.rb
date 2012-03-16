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
      def self.apply?(tool, profile, data, &block)
        false
      end

      #
      # Initialize Config instance. Config instances are per-configuration,
      # which means they are associated with one and only one config entry or
      # file.
      #
      def initialize(tool, profile, data, &block)
        self.tool    = tool
        self.profile = profile
        self.data    = data
        self.block   = block if block
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

      #
      attr :data

      def data=(data)
        @data = data
      end

      #
      attr :block

      def block=(proc)
        @block = proc.to_proc
      end

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
        "#<#{self.class.name}:#{object_id} @tool=%s @profile=%s>" % [tool.inspect, profile.inspect]
      end

    end

  end

end
