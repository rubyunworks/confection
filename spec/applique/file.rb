require 'confection'

When 'configuration file `(((\S+)))` containing' do |slots, text|
  Confection.clear!
  fname = [slots].flatten.first  # temporary transition to new QED
  File.open(fname, 'w'){ |f| f << text }
end

