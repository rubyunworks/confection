require 'confection/basic_object'

# Welcome to Confection. Your easy means to tool configuration.
#
module Confection

  #
  if $CONFIG_FILE
    FILENAMES = [$CONFIG_FILE].flatten.compact
  else
    FILENAMES = ['.config.rb', 'config.rb']
  end

  # Bootstrap the system, loading current configurations.
  #
  def self.bootstrap
    @config = {}
    begin
      ::Kernel.eval(read, Evaluator.binding, file)
    rescue => e
      raise e if $DEBUG
      abort e.message
    end
    @config
  end

  # Stores the configuration blocks.
  #
  # @return [Hash] configuration store
  def self.config
    @config ||= bootstrap
  end

  # Look-up configuration block.
  #
  # @param name [Symbol,String]
  #   The identifying name for the config block.
  #
  def self.[](name)
    config[name.to_sym]
  end

  # Set configuration block.
  #
  # @param name [Symbol,String]
  #   The identifying name for the config block.
  #
  # @param block [Proc]
  #   Code block for configuration.
  #
  # @return [Proc] code block
  def self.[]=(name, block)
    config[name.to_sym] = block.to_proc
  end

  # Read config file.
  #
  # @return [String] contents of the `.co.rb` file
  def self.read
    File.read(file)
  end

  # Find config file by looking up the '.co.rb' file.
  #
  # @param dir [String]
  #   Optional directory to begin search.
  #
  # @return [String] file path
  def self.file(dir=nil)
    @file ||= (
      file = nil
      dir  = dir || Dir.pwd
      while dir != '/'
        FILENAMES.each do |fname|
          f = File.join(dir, fname)
          break(file = f) if File.exist?(f)
        end
        dir = File.dirname(dir)
      end
      file
    )
  end

  # Root directory, where config file is located.
  #
  # @param dir [String]
  #   Optional directory to begin search.
  #
  # @return [String] directory path
  def self.root(dir=nil)
    f = file(dir)
    f ? File.dirname(f) : nil
  end

  # The Evaluator class is used to evaluate the `.co.rb` file.
  #
  class Evaluator < Module #BasicObject
    def self.binding
      new.__binding__
    end
    def __binding__ 
      ::Kernel.binding
    end
    def method_missing(sym, *args, &block)
      #def block.call
      #  ::Kernel.eval('self',::TOPLEVEL_BINDING).instance_exec(&self)
      #end
      ::Confection[sym] = block
    end
  end

  # The Controller class is used to encapsulate the two types of invocation
  # that are posible on configuration blocks.
  #
  class Controller
    def initialize(block, &exec_block)
      @block      = block
      @exec_block = exec_block
    end
    def exec(*args)
      @exec_block.call(*args)
    end
    def call(*args)
      ::Kernel.eval('self',::TOPLEVEL_BINDING).instance_exec(*args, &@block)
    end
  end

end

# Confection's primary use method.
#
# @return [Confection::Controller] config controller
def confection(name, *args)
  config_block = Confection[name.to_sym]
  if config_block
    Confection::Controller.new(config_block) do |*args|
      instance_exec *args, &config_block
    end
  else
    warn "no configuration -- `#{name}'"
  end
end

# Copyright (c) 2011 Rubyworks (BSD-2-Clause)
