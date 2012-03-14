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
    def self.factory(tool, options)
      object = nil
      types.reverse_each do |c|
        if c.apply?(tool, options)
          object = c.new(tool, options)
          break(object)
        end
      end
      object
    end

  end

end

require 'confection/config/base'
require 'confection/config/undef'
require 'confection/config/text'
require 'confection/config/ini'
require 'confection/config/json'
require 'confection/config/yaml'
require 'confection/config/ruby'
require 'confection/config/block'
