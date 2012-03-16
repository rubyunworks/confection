# Importing
 
## Configuration Importing

Configurations can be imported from another project
using the `:from` option.

    store = Confection::Store.new

    dsl = Confection::DSL.new(store)

    dsl.config :qed, :profile=>'example', :from=>'qed'

    store.size.assert == 1

The configuration can also be imported from a different profile.

    dsl.config :qed, :coverage, :from=>'qed', :profile=>:simplecov

    store.size.assert == 2

Although it will rarely be useful, it may also be imported from another tool.

    dsl.config :example, :from=>'qed', :tool=>:sample

Imported configurations can also be augmented via a block.

    store = Confection::Store.new

    dsl = Confection::DSL.new(store)

    dsl.config :qed, :from=>'qed', :profile=>:simplecov do
      # additional code here
    end

    store.size.assert == 2

Technically this last form just creates two configurations for the same
tool and profile, but the ultimate effect is the same.

## Script Importing

Library files can be imported directly into configuration blocks via the
`#import` method.

    dsl.config :example do
      import "fruitbasket/example.rb"
    end

This looks up the file via the `finder` gem and then evals it in the context
of the config block.

