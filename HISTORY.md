# RELEASE HISTORY

## 0.3.0 | 2012-04-02

This release renames the mast configuraiton file from `Confile`
to `Config.rb` --I mean really, it makes more sense.

Changes:

* Rename configuration file to `Config.rb`.


## 0.2.0 | 2012-03-11

The API has changed and no longer uses #method_missing magic.
Instead the `config` method is used to define a configuration.
In addition Confection now supports profiles via either a
block clause or via a second argument, as well as the ability
to import configurations from other projects.

Changes:

* Use #config method instead of method_missing trick.
* Add support for configuration profiles.
* Add #confect method to automatically handle typical configuration.


## 0.1.0 | 2011-11-17

This major release, probably the first truly usable release,
adds support for multiple configration files by storing them
on a per working directory basis, renames the default config
file name to `.confile` or `confile` with or without an optional
`.rb` extension, and adds a class method for changing the file
name (though using the global variable still works if needed).

Changes:

* Configuration file default is '{.,}confile{.rb,}'.
* Default can be changed via class method or global.
* Configrations are stored per-working directory, to
  support multiple configurations at once.


## 0.0.2 | 2011-11-07

You can now use $CONFIG_FILE to change the default config file.
Just set the variable prior to using confection. Confection
should also work with Ruby 1.8.7 and older now.

Changes:

* Lazy load configuration, rather then loading upfront.
* Add dependency on blankslate gem for Ruby 1.8 and older.
* Add $CONFIG_FILE to allow default config file to be adjusted.


## 0.0.1 | 2011-11-06

This is the initial release of Confection.

Changes:

* Happy 1st Release!

