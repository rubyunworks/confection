# Welcome to Confection.
#
module Confection

  FILENAME = '.co'

  def self.[](name)
    evaluator.__config__[name.to_sym]
  end

  def self.evaluator
    @evaluator ||= (
      e = Evaluator.new
      e.instance_eval(read)
      e
    )
  end

  # Read config file.
  def self.read
    File.read(file)
  end

  # Find config file by looking up the '.co' file.
  def self.file
    @file ||= (
      dir = Dir.pwd
      while dir != '/'
        file = File.join(dir, FILENAME)
        break file if File.exist?(file)
        dir = File.dirname(dir)
      end
      file
    )
  end

  # Root directory, where config file is located.
  def self.root
    File.dirname(file)
  end

  #
  class Evaluator < BasicObject
    def initialize
      @__config__ = {}
    end

    def __config__
      @__config__
    end

    def method_missing(sym, &block)
      @__config__[sym] = block
    end 
  end

end

#
def confection(name, *args)
  config_block = Confection[name.to_sym]
  if config_block
    instance_exec *args, &config_block
  else
    warn "no configuration -- `#{name}'"
  end
end

