module Confection

  #
  #
  module Manage

    #
    def controller(scope, tool, *options)
      params = (Hash === options.last ? options.pop : {})
      params[:profile] = options.shift unless options.empty?

      if from = params[:from]
        projects[from] ||= Project.load(from)
        projects[from].controller(scope, tool, params)
      else
        $properties ||= current_project.properties
        current_project.controller(scope, tool, params)
      end
    end

    #
    def projects
      @projects ||= {}
    end

    #
    def current_directory
      @current_directory ||= Dir.pwd
    end

    #
    def current_project
      projects[current_directory] ||= Project.lookup(current_directory)
    end

    #
    def clear!
      current_project.store.clear!
    end

    #
    def profiles(tool)
      current_project.profiles(tool)
    end

    #
    def each(&block)
      current_project.each(&block)
    end

    #
    def size
      current_project.size
    end

    #
    # Project properties.
    #
    def properties
      current_project.properties
    end

  end

  extend Manage

end
