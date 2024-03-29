# DSL

The DSL class handle evaluation of a project configuration file.

   store = Confection::Store.new

   dsl = Confection::DSL.new(store)

The DSL instance will have a cached binding.

   #dsl.__binding__ == dsl.__binding__

We can use the `#instance_eval` method to evaluate a configuration for our
demonstration.

    dsl.instance_eval(<<-HERE)
      config :sample1 do
        "block code"
      end
    HERE

Evaluation of a configuration file, populate the Confection.config instance.

    sample = store.last
    sample.tool     #=> :sample1
    sample.profile  #=> nil
    sample.class    #=> Confection::Config

A profile can be used as a means fo defining multiple configuration options
for a single tool. This can be done by setting the second argument to a Symbol.

    dsl.instance_eval(<<-HERE)
      config :sample2, :opt1 do
        "block code"
      end
    HERE

    sample = store.last
    sample.tool     #=> :sample2
    sample.profile  #=> :opt1

Or it can be done by using a `profile` block.

    dsl.instance_eval(<<-HERE)
      profile :opt1 do
        config :sample2 do
          "block code"
        end
      end
    HERE

    sample = store.last
    sample.tool     #=> :sample2
    sample.profile  #=> :opt1

Different types of configuration can be defined. For instance, if a multi-line
string is passed to the `config` method will be a text-based configuration.

    dsl.instance_eval(<<-HERE)
      config :sample3, %{
        text config
      }
    HERE

    sample = store.last
    sample.tool        #=> :sample3
    sample.profile     #=> nil
    sample.to_s.strip.assert == "text config"

