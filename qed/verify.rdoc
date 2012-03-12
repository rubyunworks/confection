== Verify

Lets say we have a confection configuration file `test.config` containing:

    config :foo do
      @a = 1
    end

We can get hold of the configuration for 'foo' using the `#confection`
method.

    config = confection(:foo)

    Confection::Controller.assert === config

Then if we execute it using `#call` it will be evaluate in the current
context.

    config.call

    @a  #=> 1

Alternately `#load` can be used to evaluate the code in the TOPLEVEL
context.

