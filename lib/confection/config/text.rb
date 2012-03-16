module Confection

  #
  module Config

    # Text configuration.
    #
    class Text < Base

      def self.apply?(tool, profile, data, &block)
        return true if String === data
        return false
      end

      #
      def text
        data
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

    end

  end

end
