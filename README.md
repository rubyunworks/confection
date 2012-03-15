# Confection

[Homepage](http://rubyworks.github.com/confection) |
[Source Code](http://github.com/rubyworks/confection) |
[Report Issue](http://github.com/rubyworks/confection/issues) |
[Mailing List](http://googlegroups.com/group/rubyworks-mailinglist) |
[IRC Channel](http://chat.us.freenode.net/rubyworks)

[![Build Status](https://secure.travis-ci.org/rubyworks/confection.png)](http://travis-ci.org/rubyworks/confection)


## Description

Confection is multi-tenant configuration system for Ruby projects. If was 
designed to facilitate Ruby-based configuration for multiple tools in a
single file. It is extremely simple, which makes it easy to understand
and flexible in use.


## Instruction

There are two ways to define configurations --as a `config` entry in the master
configuration file or a separate file in a project's `task` directory.

For the former, create a file in you project called `Confile`. The file can
have any name that matches the glob `{.,}confile{.rb,}` case insensitive. In
this file add configuration blocks by name. For example, let's demonstrate
how we could use this to configure Rake tasks.

    $ cat Confile
    config :rake do
      desc 'generate yard docs'
      task :yard do
        sh 'yard'
      end
    end

In our Rakefile:

    $ cat Rakefile
    require 'confection'
    confection(:rake).call

Now you might wonder why the heck you would do this. That's where the *multi-tenancy*
comes into play. Let's add another configuration, and this time for a tool that has
native support for Confection.

    $ cat Confile
    title = "myapp"

    config :rake do
      desc 'generate yard docs'
      task :yard do
        sh "yard doc --title #{title}"
      end
    end

    config :qedoc do
      self.title = "#{title} Demonstrandum"
    end

Now we have configuration for both the rake tool and the qed test tool in
a single file. Thus we gain the advantage of reducing the file count of our 
project while pulling our tool configurations together into one place.
Moreover, these configurations can potentially share settings as demonstrated
here via the `title` variable.

Confection also supports profiles, either via a `profile` block or via a
`:profile` option.

    profile :cov
      config :qed do
        require 'simplecov'
        ...
      end
    end

Using Confection in your libraries is very simple. As you can see from our
example Rakefile. The `#confection` method is used to get a handle on a named
configuration. With it you have two options, `#call`, `#exec` or `#load`.
The first calls the block which is evaluated in the context in which it was
defined. This is recommended. The second will evaluate the block in the 
context of the caller and the last in the context of the toplevel.
For instance, QED uses `#exec` to import user configuration directly into
its Settings instance.

    confection(:qed, profile_name).exec

An alternative to adding entries to a project's master configuration file,
configurations can be placed in individual files in a project's `task/`
directory. These must follow the naming scheme  `<tool>-<profile>.<type>`
or in some cases `<profile>.<tool>` (e.g `test.rake`).

Accessing configuration in the task directory works in the exact same fashion
as those in the master confgiuration file.


## Release Notes

Please see HISTORY.rdoc file.


## Copyrights

Copyright (c) 2011 Rubyworks

Confection is distributable in accordance with the **BSD-2-Clause** license.

See LICENSE.txt file for details.

