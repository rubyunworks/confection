unless Object.const_defined?(:BasicObject)
  require 'blankslate'
  Object::BasicObject = Object::BlankSlate
end

