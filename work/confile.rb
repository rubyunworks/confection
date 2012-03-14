# DEPRECATED

module Confection

  class Confile

    include Enumerable

    #
    FILE_PATTERN = '{.,}confile{.rb,}'

    #
    DIR_PATTERN = 'task/*'

    def self.load(store, source)

    end

    #
    def self.load(lib=nil)
      if lib
        file = Find.path(FILE_PATTERN, :from=>lib).first
      else
        #file = Dir.glob(File.join(dir, FILE_PATTERN), File::FNM_CASEFOLD).first
        file = lookup()
      end
      new(file)
    end

    #
    # Lookup configuation file.
    #
    # @param dir [String]
    #   Optional directory to begin search.
    #
    # @return [String] file path
    #
    def self.lookup(dir=nil)
      dir = dir || Dir.pwd
      home = File.expand_path('~')
      while dir != '/' && dir != home
        if file = Dir.glob(File.join(dir, FILE_PATTERN), File::FNM_CASEFOLD).first
          return file
        end
        dir = File.dirname(dir)
      end
      nil
    end

=begin
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
=end

    #
    def initialize(file=nil)
      @file = file
      @list = []

      @dsl = DSL.load(self)
    end

    #
    attr :file

    #
    attr :dsl

    #
    #def load
    #  dsl.load_file(self)
    #end

    #
    def each(&block)
      @list.each(&block)
    end

    #
    def size
      @list.size
    end

    #
    # Add as configuratio to the store.
    #
    def <<(conf)
      raise unless Config === conf
      @list << conf
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

    #
    #
    #
    def profiles(tool)
      names = []
      each do |c|
        names << c.profile if c.tool == tool.to_sym
      end
      names.uniq
    end

    #
    #
    #
    def clear!
      @list = []
    end

    #
    # Project properties.
    #
    def properties
      dotruby = File.join(directory,'.ruby')
      if File.exist?(dotruby)
        data = YAML.load_file(dotruby)
        OpenStruct.new(data)
      else
        OpenStruct.new
      end
    end

    #
    #
    #
    def directory
      File.dirname(file)
    end

    #
    def first
      @list.first
    end

    #
    def last
      @list.last
    end

    #
    def config(*args, &block)
      dsl.config(*args, &block)
    end

    #
    def load_task_configs
      Dir.glob(DIR_PATTERN).each do |file|
        ext  = File.extname(file)
        name = file.chomp(ext)
        tool, profile = name.split('-')
        dsl.config tool, :profile=>profile, :file=>file
      end
    end

    #
    def controller(scope, name, profile=nil)
      configs = lookup(name, profile)
      Controller.new(scope, *configs)
    end

  end

end
