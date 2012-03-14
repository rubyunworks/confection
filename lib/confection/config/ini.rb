module Confection

  module Config

    # INI configuration.
    #
    class Ini < Text

      EXTENSIONS = %w{.ini ini}

      def self.apply?(too, options)
        return true if EXTENSIONS.include?(options[:type].to_s)
        return true if EXTENSIONS.include?(File.extname(options[:file].to_s))
        return false
      end

      #
      def initialize_require
        require 'inifile'
      end

      #
      def call(*)
        to_data
      end

      #
      # Parse INI into IniFile object.
      #
      def to_data
        if file
          IniFile.load(file)
        else
          # HOW TO ?
          #IniFile.load(text)
          raise NotImplemented 
        end
      end

    end

  end

end
