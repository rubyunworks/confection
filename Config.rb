#!/usr/bin/env ruby

#
# Example configuration.
#
config :example do
  puts "Configuration Example!"
end

#
# QED test coverage report using SimpleCov.
#
# coverage_folder - the directory in which to store coverage report
#                   this defaults to `log/coverage`.
#
config :qed, :cov do
  require 'simplecov'

  dir = $properties.coverage_folder

  SimpleCov.start do
    coverage_dir(dir || 'log/coverage')
    #add_group "Label", "lib/qed/directory"
  end
end

#
# Detroit assembly.
#
config :detroit do
  email do
    mailto 'ruby-talk@ruby-lang.org', 'rubyworks-mailinglist@googlegroups.com'
  end

  gem do
    active true
  end

  github do
    folder 'web'
  end

  dnote do
    title  'Source Notes'
    output 'log/notes.html'
  end

  locat do
    output 'log/locat.html'
  end

  vclog do
    output 'log/history.html',
           'log/changes.html'
  end
end

