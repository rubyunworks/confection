module Confection

  module Config

    # Ruby script configuration.
    #
    class Ruby < Base

      EXTENSIONS = %w{.rb .rbx rb rbx ruby}

      #
      def self.apply?(too, options)
        return true if EXTENSIONS.include?(options[:type].to_s)
        return true if EXTENSIONS.include?(File.extname(options[:file].to_s))
        return false
      end

      #
      #def call(*args)
      #  hold, $arguments = $arguments, args
      #  Kernel.load(file)
      #  $arguments = hold
      #end

      #
      def call(*args)
        proc = Kernel.eval("lambda do |arguments|\n#{script}\nend", TOPLEVEL_BINDING, file)
        proc.call(args)
      end

      #
      alias load call

      #
      #
      #
      def to_proc
        script = script()
        file   = file() || '(eval)'
        lambda do |*arguments|
          instance_eval(script, file)
        end
      end

      #
      #
      #
      def script
        @script ||= (file && File.read(file))
      end 

      #
      # Scripts are not text configurations.
      #
      def text; nil; end

      #
      # Set configuration text.
      #
      # @param [String] text
      #   The configuration text.
      #
      def script=(script)
        @script = script
      end

      #
      #def copy(opts={})
      #  tool = opts[:tool] || @tool
      #  file = opts[:file] || @file
      #
      #  opts[:profile] ||= profile
      #  opts[:type]    ||= type
      #
      #  self.class.new(tool, file, opts)
      #end

    end

  end

end
