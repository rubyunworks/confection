require 'finder'
require 'yaml'
require 'ostruct'

require 'confection/basic_object'
require 'confection/config'
require 'confection/dsl'
require 'confection/controller'

# Welcome to Confection. Your easy means to tool configuration.
#
module Confection

  #
  @config = Hash.new{|h,k| h[k]=[]}

  #
  #def self.directory
  #  Dir.pwd
  #end

  #
  #
  #
  def self.filename
    @filename ||= (
      $CONFIG_FILE ? $CONFIG_FILE : '{.,}confile{.rb,}'
    )
  end

  #
  # Configuration file can be changed using this method.
  # Alternatively it can be changed using `$CONFIG_FILE`.
  #
  def self.filename=(glob)
    @filename = glob
  end

  def self.controller(scope, name, profile)
    configs = Confection.find(name, profile)
    Controller.new(scope, *configs)
  end

  #
  # Bootstrap the system, loading current configurations.
  #
  def self.bootstrap
    if file
      @config[root] = []
      begin
        DSL.load_file(file)
      rescue => e
        raise e if $DEBUG
        warn e.message
      end
    end
    @config[root]
  end

  #
  # Project properties.
  #
  def self.properties
    if File.exist?('.ruby')
      data = YAML.load_file('.ruby')
      OpenStruct.new(data)
    else
      OpenStruct.new
    end
  end

  #
  # Stores the configuration.
  #
  # @return [Hash] configuration store
  #
  def self.config
    if @config.key?(root)
      @config[root]
    else
      bootstrap
    end
  end

  #
  # Add as configuratio to the store.
  #
  def self.<<(conf)
    raise unless Config === conf
    config << conf
  end

  #
  # Lookup configuration by tool and optionally profile name.
  #
  def self.find(tool, profile=nil)
    config.select do |c| 
      c.tool == tool.to_sym && (profile ? c.profile == profile.to_sym : true) 
    end
  end

=begin
  #
  # Look-up configuration block.
  #
  # @param name [Symbol,String]
  #   The identifying name for the config block.
  #
  def self.[](key)
    key = key.split(':') if String === key
    config[key]
  end

  #
  # Set configuration block.
  #
  # @param name [Symbol,String]
  #   The identifying name for the config block.
  #
  # @param block [Proc]
  #   Code block for configuration.
  #
  # @return [Proc] code block
  #
  def self.[]=(key, conf)
    key = key.split(':') if String === key
    config[key] = conf
  end
=end

  #
  # Read config file.
  #
  # @return [String] contents of the `.conf.rb` file
  #
  def self.read
    File.read(file)
  end

  #
  # Lookup configuation file.
  #
  # @param dir [String]
  #   Optional directory to begin search.
  #
  # @return [String] file path
  #
  def self.file(dir=nil)
    dir  = dir || Dir.pwd
    while dir != '/'
      if file = Dir.glob(File.join(dir,filename),File::FNM_CASEFOLD).first
        return file
      end
      dir = File.dirname(dir)
    end
    nil
  end

  #
  # Root directory, where config file is located.
  #
  # @param dir [String]
  #   Optional directory to begin search.
  #
  # @return [String] directory path
  #
  def self.root(dir=nil)
    f = file(dir)
    f ? File.dirname(f) : Dir.pwd
  end

end

#
# Confection's primary use method.
#
# @return [Confection::Controller] config controller
#
def confection(tool, profile=nil)
  Confection.controller(self, tool, profile)
end

# Copyright (c) 2011 Rubyworks (BSD-2-Clause)
