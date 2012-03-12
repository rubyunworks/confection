# Welcome to Confection. Your easy means to tool configuration.
#
module Confection
end

require 'finder'
require 'yaml'
require 'ostruct'

require 'confection/basic_object'
require 'confection/manage'
require 'confection/config'
require 'confection/dsl'
require 'confection/controller'

#
# Confection's primary use method.
#
# @return [Confection::Controller] config controller
#
def confection(tool, profile=nil)
  Confection.controller(self, tool, profile)
end

# Copyright (c) 2011 Rubyworks (BSD-2-Clause)
