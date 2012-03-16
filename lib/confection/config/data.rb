module Confection

  module Config

    # Data configuration.
    #
    class Data < Base

      #
      def self.apply?(tool, profile, data, &block)
        return true if Hash === data
        return true if Proc === data
        return false
      end

      #
      def initialize_require
        #require 'construct'  # TODO: Use construct in future maybe ?
      end

      #
      def call(*)
        to_data
      end

      #
      def to_proc
        lambda do 
          to_data
        end
      end

      #
      # Parse data into Construct object.
      #
      def to_data
        case data
        when Proc
          hash = {}
          BlockParser.new(hash, &data)
        else
          hash = data.dup
        end
        hash
      end

      #
      class BlockParser < BasicObject
        def initialize(data={}, &block)
          @data = data
          instance_eval(&block)
        end

        def method_missing(name, *args, &block)
          if block
            @data[name] = {}
            BlockParser.new(@data[name], &block)
          else
            case args.size
            when 0
              @data[name]
            when 1
              @data[name] = args.first
            else
              @data[name] = args
            end
          end
        end
      end

    end

  end

end
