module Confection

  # Base class for other config types.
  class Config

    #
    def self.subtypes
      @subtypes ||= []
    end

    #
    def self.inherited(subtype)
      subtypes << subtype
    end

    #
    #
    #
    def self.factory(settings)
      subtypes.each do |subtype|
        return subtype.new(settings) if subtype.applies?(settings)
      end
      raise ArgumentError
    end

    def initialize(settings)
      @tool    = settings[:tool]
      @profile = settings[:profile]
    end

    #
    attr :tool

    #
    attr :profile

    #
    def source
      nil
    end

    #
    # @return [String] load path to file
    #
    # @raise [NoMethodError] if config does not support `#file`
    #
    def path
      Find.path(File.join('task', file))
    end

  end

  # YAML configuration.
  #
  class YAMLConfig < Config

    EXTENSIONS = %{.yml .yaml}

    def self.applies?(settings)
      return true if settings[:type] == :yaml
      if file = settings[:file]
        ext = File.extname(file)
        return true if EXTENSIONS.include?(ext)
      end
      return false
    end

    def initialize(text, settings={})
      super(settings)

      @text = settings[:text]
      @file = settings[:file]
    end

    def source
      @source ||= File.read(path)
    end

    def data
      @data ||= YAML.load(text)
    end
  end

  # TODO: INIConfig

  # Block configuration is used when a code block is provided
  # directly to the `#config` method.
  #
  class BlockConfig < Config

    def self.applies?(settings)
      return true if settings[:block]
      return false
    end

    def initialize(settings={})
      super(settings)

      @block = settings[:block]
    end

    attr :block

    def source
      nil  #@todo any way to show the source code of a block?
    end
  end

  #
  #
  class ScriptConfig < Config

    EXTENSIONS = %{.rb .rbx .rake}  # FIXME: others supported extensions ?

    def self.applies?(settings)
      if file = settings[:file]
        ext = File.extname(file)
        return true if EXTENSIONS.include?(ext)
      end
      return false
    end

    def initialize(settings={})
      super(settings)

      @file = settings[:file]
    end

    attr :file

    #
    # Read source code.
    #
    def source
      @source ||= File.read(path)
    end

  end

  #
  #
  class TextConfig < Config

    EXTENSIONS = %{.txt .text}

    def self.applies?(settings)
      return true if settings[:type] == :text
      return true if settings[:text] && settings[:type].nil?
      if file = settings[:file]
        ext = File.extname(file)
        return true if EXTENSIONS.include?(ext)
      end
      return false
    end

    def initialize(settings={})
      super(settings)

      @text = settings[:text]
      @file = settings[:file]
    end

    attr :file

    def source
      @source ||= (@file ? File.read(path) : @text)
    end

    alias text source

  end

end
