module Confection

  # Base class for other config types.
  #
  class Config

    #
    # @param [Hash] settings
    #
    def self.collect(settings)
      if settings[:file]
        glob  = settings[:file]
        paths = Find.path(File.join('task', glob))
        paths.map do |path|
          settings[:file] = path
          new(settings)
        end
      else
        [ new(settings) ]
      end    
    end

    #
    # Initialize Config instance. Config instances are per-configuration,
    # which means they are associated with one and only one block, text or
    # configuration file. Developer's should use `Config.collect()` to gather
    # a set of configurations using on a file glob.
    #
    def initialize(settings, &block)
      @tool    = settings[:tool]
      @profile = settings[:profile]
      @text    = settings[:text]
      @file    = settings[:file]
      @block   = settings[:block] || block
    end

    # The name of tool being configured.
    attr :tool

    # The name of the profile to which this configuration belongs.
    attr :profile

    # File containing the configuration, if from file.
    attr :file

    # Confiration text.
    def text
       @text ||= File.read(file)
    end

    # Alias for `#text`.
    alias to_s text

    # The block, if block based configuration.
    attr :block

    # Alias for `#block`.
    alias to_proc block

    # Treat as YAML and load.
    def yaml
      @yaml ||= file ? YAML.load_file(file) : YAML.load(text)
    end

    # Ruby 1.9 defines #inspect as #to_s, ugh.
    def inspect
      "#<Confection::Config:#{object_id} @tool=%s @profile=%s>" % [tool.inspect, profile.inspect]
    end

  end

end
