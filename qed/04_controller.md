# Controller

When working with configurations, Confection wraps configurations in a
Controller instance.

An empty controller can be made simply enough.

    Confection::Controller.new(self, *[])

The #confection method simple calls this with the configs it finds.

    ctrl = config(:block)

    Confection::Controller.assert === ctrl

A controller will most oftern encapsulate just a sigle configuration,
but it may contain more if the search parameters used to create it
returned more than one matching configuration. We can see how many
configurations the controller is harnessing using the `#size` method.

    ctrl.size.assert == 1

With the controller, we can utilize the configuration(s) it encapsulates
through the handful of methods it provides for doing so. Probably the 
most useful, which applies to Ruby-based configurations is the `#call`
methods. This will execute the configuration script in the context
in which it was defined.

    result = ctrl.call

    result.assert == "example block config"

Instead of being executed in the context in which a configuration was
defined, it can be executed in the current scope using the #exec method.

    result = ctrl.exec

    result.assert == "example block config"

Of course, as this example only outputs a string, we won't notice any
difference here.

Lastly, script based configurations can be executed in the TOPLEVEL 
context by using `#main_exec`, or its alias `#load`.

    result = ctrl.main_exec

    result.assert == "example block config"

The controller can be converted to a Proc object, in which case the
underlying execution is equivalent to using `#exec`. This allows 
the procedure to be evaluated in other bindings as needed.

    proc = ctrl.to_proc

    result = proc.call

    result.assert == "example block config"

For text configuration, the controller will concat each configuration's 
content.

    ctrl = config(:text)

    text = ctrl.to_s

    text.strip.assert == 'example text config'

