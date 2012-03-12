# DSL

The DSL class handle evaluation of a project configuration file.

   dsl = Confection::DSL.new

The DSL instance will have a cached binding.

   dsl.__binding__ == dsl.__binding__

Under the hood, the `__eval__` method is used to evaluate a configuration
file.

    dsl.__eval__(<<-HERE)
      config :sample1 do
        "block code"
      end
    HERE

Evaluation of a configuration file, populate the Confection.config instance.

    sample = Confection.config.last
    sample.tool     #=> :sample1
    sample.profile  #=> nil
    sample.class    #=> Confection::Config

A profile can be used as a means fo defining multiple configuration options
for a single tool. This can be done by setting the `:profile` option.

    dsl.__eval__(<<-HERE)
      config :sample2, :profile=>:opt1 do
        "block code"
      end
    HERE

    sample = Confection.config.last
    sample.tool     #=> :sample2
    sample.profile  #=> :opt1

Or it can be done by using a `profile` block.

    dsl.__eval__(<<-HERE)
      profile :opt1 do
        config :sample2 do
          "block code"
        end
      end
    HERE

    sample = Confection.config.last
    sample.tool     #=> :sample2
    sample.profile  #=> :opt1

Different types of configuration can be defined. For instance, if a multi-line
string is passed to the `config` method will be a text-based configuration.

    dsl.__eval__(<<-HERE)
      config :sample3, %{
        text config
      }
    HERE

    sample = Confection.config.last
    sample.tool        #=> :sample3
    sample.profile     #=> nil
    sample.file        #=> nil
    sample.text.strip.assert == "text config"

