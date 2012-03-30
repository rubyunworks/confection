# Confection

[Homepage](http://rubyworks.github.com/confection) /
[Source Code](http://github.com/rubyworks/confection) /
[Report Issue](http://github.com/rubyworks/confection/issues) /
[Mailing List](http://googlegroups.com/group/rubyworks-mailinglist) /
[IRC Channel](http://chat.us.freenode.net/rubyworks)

[![Build Status](https://secure.travis-ci.org/rubyworks/confection.png)](http://travis-ci.org/rubyworks/confection)


## Description

Confection is multi-tenant configuration system for Ruby projects. If was 
designed to facilitate Ruby-based configuration for multiple tools in a
single file. It is extremely simple, which makes it easy to understand
and flexible in use.


## Instruction

To get started, create a master configuration file for your project called
`Config.rb`. The file can have any name that matches `.config.rb`, `Config.rb`
or `config.rb`, in that order of precedence. In this file add configuration
blocks by name. For example, let's demonstrate how we could use this to 
configure Rake tasks.

    $ cat Config.rb
    config :rake do
      desc 'generate yard docs'
      task :yard do
        sh 'yard'
      end
    end

In our Rakefile:

    $ cat Rakefile
    require 'confection'
    confection(:rake, '*').load

Now you might wonder why the heck you would do this. That's where the *multi-tenancy*
comes into play. Let's add another configuration, and this time for a tool that has
native support for Confection.

    $ cat Config.rb
    title = "MyApp"

    config :rake do
      desc 'generate yard docs'
      task :yard do
        sh "yard doc --title #{title}"
      end
    end

    config :qedoc do |doc|
      doc.title = "#{title} Demonstrandum"
    end

Now we have configuration for both the rake tool and the qedoc tool in
a single file. Thus we gain the advantage of reducing the file count of our 
project while pulling our tool configurations together into one place.
Moreover, these configurations can potentially share settings as demonstrated
here via the `title` variable.

Confection also supports profiles, either via a `profile` block or via a
second config argument.

    config :qed, :cov do
      require 'simplecov'
      ...
    end

Or,

    profile :cov
      config :qed do
        require 'simplecov'
        ...
      end
    end

Using Confection in your libraries is very simple, as can be seen from our
Rakefile example. The `#confection` method (alias `#config`) is used to get
a handle on a named configuration. With it you have a few options, `#call`,
`#exec` or `#load`, `#to_s` or `#to_h`.

The `#call` method evaluates a config's block in a separate per-configuration
file context in which it was defined. This is recommended. The `#exec` method,
on the other hand, will evaluate the block in the  context of the caller. Where 
as the `#load` method evaluates the block in the toplevel context.

For instance, QED uses `#exec` to import user configuration directly into
its Settings instance.

    confection(:qed, profile_name).exec

The last two methods, `#to_s` and `#to_h` are used for text-based or hash-based
configurations. The `qedoc` configuration above is a good example of the later.
It can be converted directly into a Hash.

    confection(:qedoc, :cov).to_h  #=> {:title => "MyApp Demonstration"}

Lastly, there is the `#confect` method (alias `#configure`). This is just like the
`#confection` method, but automatically invokes `configure(self)` on each
selected configuration. In most cases that's exactly what is needed, so it 
saves having to make the additional invocation on the return value of `#confection`.


## Dependencies

### Libraries

Confection depends on the [Finder](http://rubyworks.github.com/finder) library
to provide reliable load path and Gem searching. This is used when importing
configurations from external projects.

Confection also depends on [Ruby Facets](http://rubyworks.github.com/facets)
for just a few very useful core extensions.

To use Confection on Ruby 1.8 series, the `BlankSlate` library is also needed
in order to emulate Ruby's BasicObject. (This may change to the `Backports`
project in a future version.)

### Core Extensions

Confection uses two core extensions, `#to_h`, which applies a few different
classes, `String#tabto`. These come from Ruby Facets to ensure a high standard 
of interoperability. 

Both of these methods have been suggested for inclusion in Ruby proper.
Please head over to Ruby Issue Tracker and add your support.

* http://bugs.ruby-lang.org/issues/749
* http://bugs.ruby-lang.org/issues/6056


## Release Notes

Please see HISTORY.rdoc file.


## Copyrights

Copyright (c) 2011 Rubyworks

Confection is distributable in accordance with the **BSD-2-Clause** license.

See LICENSE.txt file for details.

