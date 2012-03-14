module Confection

  #
  module Config

    # Plain text configuration.
    #
    class Text < Base

      EXTENSIONS = %w{.txt txt .text text}

      def self.apply?(too, options)
        return true if EXTENSIONS.include?(options[:type].to_s)
        return true if EXTENSIONS.include?(File.extname(options[:file].to_s))
        return true if options[:text]
        return false
      end

      #
      def initialize(tool, options={})
        super(tool, options)
        self.text = options[:text]
      end

      #
      def text
        @text ||= (file && File.read(file))
      end 

      #
      # Set configuration text.
      #
      # @param [String] text
      #   The configuration text.
      #
      def text=(text)
        @text = text
      end

      # TODO: ERB ?

      #
      # Returns the configuration text.
      #
      def call(*)
        text
      end

      #
      # Simply wraps the configuration text in a lambda.
      #
      def to_proc
        text = self.text
        lambda do |*args|
          text
        end
      end

      #
      # Returns the configuration text.
      #
      alias to_s text

      #
      #def copy(opts={})
      #  tool = opts[:tool] || @tool
      #
      #  opts[:text]    ||= text
      #  opts[:profile] ||= profile
      #  opts[:type]    ||= type
      #
      #  self.class.new(tool, opts)
      #end

    end

  end

end
