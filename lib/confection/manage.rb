module Confection

  #
  @config = Hash.new{|h,k| h[k]=[]}

  #
  #
  module Manage

    include Enumerable

    def clear!
      @config = Hash.new{|h,k| h[k]=[]}
    end

    #
    # Stores the configuration.
    #
    # @return [Hash] configuration store
    #
    def config
      if @config.key?(root)
        @config[root]
      else
        bootstrap
      end
    end

    #
    def profiles(tool)
      list = []
      each do |c|
        list << c.profile if c.tool == tool.to_sym
      end
      list.uniq
    end

    #
    def controller(scope, name, profile)
      configs = lookup(name, profile)
      Controller.new(scope, *configs)
    end

    #
    def each(&block)
      config.each(&block)
    end

    #
    def size
      config.size
    end

    #
    #def self.directory
    #  Dir.pwd
    #end

    #
    #
    #
    def filename
      @filename ||= (
        $CONFIG_FILE ? $CONFIG_FILE : '{.,}confile{.rb,}'
      )
    end

    #
    # Configuration file can be changed using this method.
    # Alternatively it can be changed using `$CONFIG_FILE`.
    #
    def filename=(glob)
      @filename = glob
    end

    #
    # Bootstrap the system, loading current configurations.
    #
    def bootstrap
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
    def properties
      if File.exist?('.ruby')
        data = YAML.load_file('.ruby')
        OpenStruct.new(data)
      else
        OpenStruct.new
      end
    end

    #
    # Add as configuratio to the store.
    #
    def <<(conf)
      raise unless Config === conf
      config << conf
    end

    #
    #
    #
    def concat(configs)
      configs.each{ |c| self << c }
    end

    #
    # Lookup configuration by tool and optionally profile name.
    #
    def lookup(tool, profile=nil)
      select do |c| 
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
    def read
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
    def file(dir=nil)
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
    def root(dir=nil)
      f = file(dir)
      f ? File.dirname(f) : Dir.pwd
    end

  end

  extend Manage

end
