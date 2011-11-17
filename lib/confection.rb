require 'confection/basic_object'

# Welcome to Confection. Your easy means to tool configuration.
#
module Confection
 
  #
  @config = Hash.new{|h,k| h[k]={}}

  def self.filename
    @filename ||= (
      if $CONFIG_FILE
        [$CONFIG_FILE].flatten.compact
      else
        ['.conf.rb', 'conf.rb']
      end     
    )
  end

  # Configuration file can be changed using this method.
  # Alternatively it can be changed using `$CONFIG_FILE`.
  def self.filename=(fname)
    @filename = [fname].flatten.compact
  end

  # Bootstrap the system, loading current configurations.
  #
  def self.bootstrap
    if file
      @config[Dir.pwd] = {}
      begin
        ::Kernel.eval(read, Evaluator.binding, file)
      rescue => e
        raise e if $DEBUG
        warn e.message
      end
    end
    @config[Dir.pwd]
  end

  # Stores the configuration blocks.
  #
  # @return [Hash] configuration store
  def self.config
    if @config.key?(Dir.pwd)
      @config[Dir.pwd]
    else
      bootstrap
    end
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
  # @return [String] contents of the `.conf.rb` file
  def self.read
    File.read(file)
  end

  # Find config file by looking up the '.conf.rb' file.
  #
  # @param dir [String]
  #   Optional directory to begin search.
  #
  # @return [String] file path
  def self.file(dir=nil)
    #@file ||= (
      #file = nil
      dir  = dir || Dir.pwd
      while dir != '/'
        filename.each do |fname|
          f = File.join(dir, fname)
          if File.exist?(f)
            return f
          end
        end
        dir = File.dirname(dir)
      end
      nil
    #)
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
    def initialize(scope, &block)
      @scope = scope
      @block = block
    end
    def exec(*args)  # should this be named #call instead?
      @scope.instance_exec(*args, &@block)
    end
    def call(*args)
      ::Kernel.eval('self',::TOPLEVEL_BINDING).instance_exec(*args, &@block)
    end
    def to_proc
      @block
    end
  end

  class NullController
    def exec(*); end
    def call(*); end
    def to_proc; Proc.new{}; end
  end
end

# Confection's primary use method.
#
# @return [Confection::Controller] config controller
def confection(name, *args)
  config_block = Confection[name.to_sym]
  if config_block
    Confection::Controller.new(self, &config_block)
  else
    #warn "no configuration -- `#{name}'"
    Confection::NullController.new
  end
end

# Copyright (c) 2011 Rubyworks (BSD-2-Clause)
