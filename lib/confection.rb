# Welcome to Confection.
#
module Confection

  FILENAME = '.co.rb'

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
  def self.file(dir=nil)
    @file ||= (
      file = nil
      dir  = dir || Dir.pwd
      while dir != '/'
        f = File.join(dir, FILENAME)
        break file = f if File.exist?(f)
        dir = File.dirname(dir)
      end
      file
    )
  end

  # Root directory, where config file is located.
  def self.root(dir=nil)
    f = file(dir)
    f ? File.dirname(f) : nil
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

