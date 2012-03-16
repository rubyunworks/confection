# Config Classes

There are three classes of configuration: test, data and block. Block
configurations encapsulate a block of Ruby code. Text configurations
simply contain a text string --whatever that string may represent.
Data configuration contantain a table of key-value pairs.

## Block Configuration

File configuration come from separate files rather then from definitions
in a project's master configuration file.

    config = confection(:block).first

    Confection::Config.assert === config

A Ruby-based configuration file, like our example, can be called via the `#call`
method. This evaluates the code at the TOPLEVEL, like standard `Kernel.load`
would.

    result = config.call

    result.assert == "example block config"

The call can also be converted into a Proc object via `#to_proc`. This uses
`instance_eval` internally, so that the Proc object can be evaluated in
any context it may be needed.

    proc = config.to_proc

    Proc.assert === proc

    result = proc.call

    result.strip.assert == "example block config"


## Text Configuraiton

Text-based configurations

    config = confection(:text).first

    Confection::Config.assert === config

    result = config.to_s

    result.strip.assert == "example text config"

For a text-based configuration `#call` does the same thing as `#to_s`.

    result = config.call

    result.strip.assert == "example text config"

As with the other configuration classes, we may also convert this call
into a Proc instance.

    proc = config.to_proc

    Proc.assert === proc

The configuration object can be copied, with a special `#copy` method
that accepts option parameters for changing the tool or profile of the copy.

    alt = config.copy(:profile=>:alt)

    alt.profile.assert == :alt


## Data Configuration

Data-based configuration.

    config = confection(:example, :data).first

    Confection::Config.assert === config

    result = config.to_h

    result.assert == {:name=>'Tommy', :age=>42 }

For a Data-based configuration `#call` does the same thing as `#to_data`.

    data = OpenStruct.new

    result = config.call(data)

    data.to_h.assert == {:name=>'Tommy', :age=>42 }

As with the other configuration classes, we may also convert this call
into a Proc instance.

    proc = config.to_proc

    Proc.assert === proc

This just encapsulates the `#to_data` call in a lambda.

