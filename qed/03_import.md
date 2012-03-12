# Importing

Configurations can be imported from another project's configuration file.

    config :sample, :from=>'fruitbasket'

Another way to do this, such that the import can also me augmeted is via
the `#import` method.

    config :sample do
      import :sample, :from=>'fruitbasket'
    end

The `#import` method also can also import from a different profile.

    config :sample do
      import :sample, :from=>'fruitbasket', :profile=>:alternate
    end

