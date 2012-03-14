module Confection

  #
  module Config

    # Undefinded configuration type serves as a fallback for any configuraiton
    # format that is not recognized. It is basically a hybrid type, a cross
    # between a Text configuration and a Ruby configuration depending on what
    # method is called.
    #
    class Undef < Base

      #
      def self.apply?(too, options)
        return true
      end

      #
      def initialize(tool, options={})
        super(tool, options)
      end

      #
      # Get configuration text. If not set previously, reads the text
      # from `file`.
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

      #
      # Undefined configuration types are treated as Ruby scripts when
      # using `#call`.
      #
      def call(*arguments)
        Kernel.eval(text, file)
      end

      #
      # Undefined configuration types are treated as Ruby scripts when
      # using `#to_proc`.
      #
      def to_proc
        text = text()
        file = file() || '(eval)'
        lambda do |*arguments|
          instance_eval(text, file)
        end
      end

      #
      # Undefined configuration are handles like Text configs
      # when using `#to_s`.
      #
      alias to_s text

    end

  end

end
