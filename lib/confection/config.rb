module Confection

  module Config

    #
    # List of Config::Base subclases.
    #
    def self.types
      @types ||= []
    end

    #
    # Produce a new Config object based on the given `tool` and `options`.
    #
    # Types are checked in reverse order of definition so that
    # subclasses of other types have precedence.
    #
    def self.factory(tool, profile, data, &block)
      object = nil
      types.reverse_each do |c|
        if c.apply?(tool, profile, data, &block)
          object = c.new(tool, profile, data, &block)
          break(object)
        end
      end
      object
    end

  end

end

require 'confection/config/base'
require 'confection/config/text'
require 'confection/config/data'
require 'confection/config/block'

