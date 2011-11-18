
When 'file `(((\S+)))` containing' do |slots, text|
  fname = slots.first
  File.open(fname, 'w'){ |f| f << text }
end

