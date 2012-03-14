module Confection

  class Store

    include Enumerable

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
    def initialize(*sources)
      @sources = sources

      @list = []

      @file_parser = FileParser.new(self)
      @path_parser = PathParser.new(self)

      sources.each do |source|
        if File.file?(source)
          @file_parser.parse(source)
        else
          @path_parser.parse(source)
        end
      end
    end

    #
    attr :sources

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
      raise TypeError unless Config::Base === conf
      @list << conf
    end

    #
    # Add a list of configs.
    #
    def concat(configs)
      configs.each{ |c| self << c }
    end

    #
    # Lookup configuration by tool and optionally profile name.
    #
    def lookup(tool, profile=nil)
      select do |c| 
        c.tool.to_sym == tool.to_sym && (profile ? c.profile.to_sym == profile.to_sym : true) 
      end
    end

    #
    # Returns list of profiles collected from all configs.
    #
    def profiles(tool)
      names = []
      each do |c|
        names << c.profile if c.tool == tool.to_sym
      end
      names.uniq
    end

    #
    # Clear configs.
    #
    def clear!
      @list = []
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
    #def config(*args, &block)
    #  dsl.config(*args, &block)
    #end

    #
    #def controller(scope, name, profile=nil)
    #  configs = lookup(name, profile)
    #  Controller.new(scope, *configs)
    #end

  end

end
