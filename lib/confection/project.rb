module Confection

  #
  class Project

    #
    PATTERN = '{task/,{.,}confile{.rb,}}'

    def self.cache
      @cache ||= {}
    end

    #
    def self.load(lib=nil)
      if lib
        cache[lib] ||= (
          config_path = Find.path(PATTERN, :from=>lib).first
          new(File.dirname(config_path))
        )
      else
        lookup
      end
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
        if file = Dir.glob(File.join(dir, PATTERN), File::FNM_CASEFOLD).first
          return new(File.dirname(file))
        end
        dir = File.dirname(dir)
      end
      return nil
    end

    #
    def initialize(root)
      @root  = root
      @store = Store.new(*sources)
    end

    attr :root

    alias :directory :root

    attr :store

    #
    def sources
      Dir.glob(File.join(root, PATTERN), File::FNM_CASEFOLD)
    end

    #
    #
    #
    def profiles(tool)
      store.profiles(tool)
    end

    #
    # Project properties.
    #
    # @todo Use separate class.
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

    include Enumerable

    #
    def each(&block)
      store.each(&block)
    end

    #
    def size
      store.size
    end

    #
    def controller(scope, tool, options={})
      profile = options[:profile]
      configs = store.lookup(tool, profile)
      Controller.new(scope, *configs)
    end

  end

end
