require 'confection'

Confection.filename = "test.config"

When 'configuration file `(((\S+)))` containing' do |slots, text|
  Confection.clear!
  fname = [slots].flatten.first  # temporary transition to new QED
  File.open(fname, 'w'){ |f| f << text }
end

