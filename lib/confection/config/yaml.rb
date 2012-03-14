module Confection

  module Config

    # YAML configuration.
    #
    class Yaml < Text

      EXTENSIONS = %w{.yaml .yml yaml yml}

      def self.apply?(too, options)
        return true if EXTENSIONS.include?(options[:type].to_s)
        return true if EXTENSIONS.include?(File.extname(options[:file].to_s))
        return false
      end

      #
      def initialize_require
        require 'yaml'
      end

      #
      # Calls #to_data.
      #
      def call(*)
        to_data
      end

      #
      # Alias for `#call`, which is the same as `#to_data`.
      #
      alias load call

      #
      # Encapsualte the loading of YAML in a Proc object.
      #
      def to_proc
        file = file()
        if file
          lambda{ YAML.load_file(file) }
        else
          lambda{ YAML.load(text) }
        end
      end

      #
      # Deserialize YAML into object.
      #
      def to_data
        if file
          YAML.load_file(file)
        else
          YAML.load(text)
        end
      end

    end

  end

end
