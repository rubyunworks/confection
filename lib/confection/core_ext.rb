# All core extensions come from Ruby Facets to maintain high standard for
# careful core extensions.

require 'facets/string/tabto'

#require 'facets/ostruct/to_h'  # TODO: Newer version of facets.

require 'ostruct'

class OpenStruct
  def to_h
    @table.dup
  end
end

