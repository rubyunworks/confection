module Confection

  # Parse a directory of configuration files.
  #
  class PathParser

    #
    # Recognized file types. If a config file follows the simple `<name>.<type>`
    # pattern then this list determines if `<type>` represents a tool or not.
    # If it is in this list then it is not a tool.
    #
    TYPES = %{txt text yml yaml ini xml rb rbx js}

    #
    def initialize(store)
      @store = store
    end

    #
    attr :store

    #
    def parse(directory)
      Dir.entries(directory).each do |file|
        next if file == '.' or file == '..'
        if File.directory?(file)

        else
          parse_file(file, directory)
        end
      end
    end

    #
    def parse_file(file, directory)
      tool = nil

      case file
      when /^(\w+)-(\w+)\.(\w+)$/
        tool, profile, type = $1, $2, $3
      when /^(\w+).(\w+)/
        name, type = $1, $2
        if TYPES.include?(type)
          tool    = name
          profile = nil
        else
          tool    = type
          profile = name
        end
      end

      if tool
        new_config(tool, profile, type, File.join(directory, file))
      end
    end

    #
    def parse_directory(dir)
      Dir.entries(dir).each do |subfile|
        next if subfile == '.' or subfile == '..'
        parse_subfile(subfile, dir)
      end
    end

    #
    def parse_subfile(file, profile)
      ext  = ::File.extname(file)
      name = file.chomp(ext)
      type = ext.sub(/^\./, '')
      new_config(name, profile, type, file)
    end

    #
    def new_config(tool, profile, type, file)
      config = Config.factory(tool, :file=>file, :profile=>profile, :type=>type)
if !config
  p config
  p tool, file, profile, type
end

      @store << config 
    end

  end

end
