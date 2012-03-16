## Store

A Confection::Store encapsulates the list of configurations that belong
to a project.

    store = Confection::Store.new

Only Config instance can be added to a store. Any other type of object
will raise an error.

    expect TypeError do
      store << 1
    end

We can get a list of profiles for a given tool.

    profiles = store.profiles(:text)

    profiles.assert == []

