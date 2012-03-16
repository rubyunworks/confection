# Welcome to Confection. Your easy means to tool configuration.
#
module Confection
end

require 'finder'
require 'yaml'
require 'ostruct'

#require 'confection/basic_object'
require 'confection/project'
require 'confection/store'
require 'confection/dsl'
require 'confection/config'
require 'confection/controller'
require 'confection/manage'

#
# Confection's primary use method.
#
# @return [Confection::Controller] config controller
#
def confection(tool, *options)
  Confection.controller(self, tool, *options)
end

def configure(tool, *options)
  controller = Confection.controller(self, tool, *options)
  controller.call  # default action
end

# Copyright (c) 2011 Rubyworks (BSD-2-Clause)

