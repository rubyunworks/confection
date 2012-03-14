module Confection

  module Config

    # JSON configuration.
    #
    class Json < Text

      EXTENSIONS = %w{.json json}

      #
      def self.apply?(too, options)
        return true if EXTENSIONS.include?(options[:type].to_s)
        return true if EXTENSIONS.include?(File.extname(options[:file].to_s))
        return false
      end

      #
      def initialize_require
        require 'json'
      end

      #
      def call(*)
        to_data
      end

      #
      # Deserialize YAML into object.
      #
      def to_data
        if file
          JSON.load_file(file)
        else
          JSON.load(text)
        end
      end

    end

  end

end
