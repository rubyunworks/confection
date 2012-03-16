= Confection

The idea of confection is a unified configuration management across multiple
tools for Ruby. The structure of a confection configuration file is very simple.
It is a ruby script sectioned into named blocks:

  config :rake do
    # ... rake tasks ...
  end

  config :vclog do
    # ... configure vclog ...
  end

Utilization of the these configurations is strictly up to the consuming 
application. For example, save native support in Rake itself, we can add
to a Rakefile:

  require 'confection'

  confection('rake').call

ANALYSIS:

  config :qed, :coverage, -> do
    name 'Tommy'
    age 42
  end

  config :qed, :coverage do
    puts "Scripted"
  end

