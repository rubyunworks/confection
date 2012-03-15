# Manage

The Confection module has some convenice class methods for working
with the configuration of the *current* project --the one relative
to the current working directory.

The current project root directory can be had via the `current_directory`
method.

    Confection.current_directory

The Project instance can be had via the `current_project` method.

    project = Confection.current_project

    Confection::Project.assert === project

The configuration properties of the current project can be
had via the `properties` method.

    Confection.properties

The profile names can be looked up for any given tool via the `profiles`
method.

    Confection.profiles(:file)

The number of configurations in the current project can be had via
the `size` method. (This is the number of configurations we have
defined in our test fixture.)

    Confection.size.assert == 3

And we can loop through each configuration via the `each` method.

    Confection.each{ |c| c }


