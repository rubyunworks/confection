# Setup the fixtures.

dir = File.dirname(__FILE__) + '/fixture'
Dir.entries(dir).each do |file|
  next if file == '.' or file == '..'
  path = File.join(dir, file)
  next if File.directory?(path)
  FileUtils.install(path, Dir.pwd)
end

FileUtils.mkdir_p('task') unless File.directory?('task')
dir = File.dirname(__FILE__) + '/fixture/task'
Dir.entries(dir).each do |file|
  next if file == '.' or file == '..'
  path = File.join(dir, file)
  next if File.directory?(path)
  FileUtils.install(path, File.join(Dir.pwd,'task'))
end

