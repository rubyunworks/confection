module Confection

  # Parse a unified configuration file.
  #
  class FileParser

    #
    def initialize(store)
      @store = store
    end

    #
    def parse(file)
      dsl = DSL.new(@store)
      dsl.__eval__(::File.read(file), file)
    end

    #
    attr :store

  end

end
