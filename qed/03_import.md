# Importing
 
## Configuration Importing

Configurations can be imported from another project's configuration file
using the `:from` option.

    confile = Confection::Confile.new

    confile.config :example, :from=>'qed'

The configuration can also be imported from a different profile.

    confile.config :example, :from=>'qed', :from_profile=>:alternate

Although it will rarely be useful, it may also be imported from another tool.

    confile.config :example, :from=>'qed', :from_tool=>:sample

Imported configurations can also be augmented via a block.

    confile.config :example, :from=>'qed' do
      # additional code here
    end

Technically this last form just creates two configurations for the same
tool and profile, but the ultimate effect is the same.

## Script Importing

Library files can be imported directly into configuration blocks via the
`#import` method.

    confile.config :example do
      import "fruitbasket/example.rb"
    end

This looks up the file via the `finder` gem and then evals it in the context
of the config block.

