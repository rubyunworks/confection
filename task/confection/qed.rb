#!/usr/bin/env ruby

# Create SimpleCov test coverage report.
#
# coverage_folder - the directory in which to store coverage report
#                   this defaults to `log/coverage`.

require 'simplecov'

SimpleCov.start do
  dir = properties.coverage_folder
  coverage_dir(dir || 'log/coverage')
  #add_group "Label", "lib/qed/directory"
end

