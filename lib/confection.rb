# Welcome to Confection. Your easy means to tool configuration.
#
module Confection
end

require 'finder'
require 'yaml'
require 'ostruct'

require 'confection/basic_object'
require 'confection/core_ext'
require 'confection/project'
require 'confection/store'
require 'confection/dsl'
require 'confection/hash_builder'
require 'confection/config'
require 'confection/controller'
require 'confection/current'

#
# Confection's primary use method, lookups a configuration
# given the tool and profile.
#
# To select all profiles for a given tool, use `'*'`.
#
# @return [Confection::Controller] config controller
#
def config(tool, *options)
  Confection.controller(self, tool, *options)
end

#
# Alias for #config.
#
alias confection config

#
# 
#
def configure(tool, *options)
  controller = Confection.controller(self, tool, *options)
  controller.configure
end

#
# Alias for #configure.
#
alias confect configure

# Copyright (c) 2011 Rubyworks (BSD-2-Clause)
