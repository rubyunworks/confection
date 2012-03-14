module Confection

  module Config

    #
    # Like {Config::Ruby} but derived from a block definition
    # in a project's master configuration file.
    #
    class Block < Base

      #
      def self.apply?(too, options)
        return true if options[:block]
        return false
      end

      #
      def initialize(tool, options={})
        super(tool, options)
        self.block = options[:block]
      end

      #
      # Configuration procedure.
      #
      attr :block

      #
      # Set configuration procedure.
      #
      # @param [#to_proc] proc
      #   Configuration procedure.
      #
      def block=(proc)
        raise TypeError, "must be Proc object" unless proc.respond_to?(:to_proc)
        @block = proc
      end

      #
      # Call the procedure.
      #
      def call(*args)
        @block.call(*args)
      end

      #
      # Convert the underlying procedure into an `instance_exec`
      # procedure.
      #
      def to_proc
        block = @block
        lambda do |*args|
          instance_exec(*args, &block)
        end
      end

      #
      def to_s
        text
      end

      # @TODO does this really make sense ?
      def text
        @text ||= @block.call.to_s
      end

      #
      #def copy(opts={})
      #  tool  = opts[:tool]  || @tool
      #  block = opts[:block] || @block
      #
      #  opts[:profile] ||= profile
      #  opts[:type]    ||= type 
      #
      #  self.class.new(tool, opts, &block)
      #end

    end

  end

end
