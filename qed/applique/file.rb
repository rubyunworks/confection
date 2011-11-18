
When 'file `(((\S+)))` containing' do |(fname), text|
  File.open(fname, 'w'){ |f| f << text }
end

