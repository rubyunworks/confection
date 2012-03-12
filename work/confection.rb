
#  module MyApp
#    include Confection
#    include FileConfigurable
#  end
#

module Confection

  def self.apply(data, to)
    data.each do |k,v|
      to.__send__("#{k}=",v) if to.respond_to?("#{k}=")
    end
  end

  #
  #
  #
  module GlobalConfigurable

    def confection_read
      path = File.join(*name.downcase.split('::'))
      root = %w{./. ~/.config/ /etc/}.find do |r|
        File.exist?(r +  path)
      end
      data = YAML.load_file(root + path)
      confection_apply(data)
    end

    def confection_apply(data)
      Confection.apply(node, self)
    end

  end

  #
  # Get configuration only from current working directory.
  # Default file is `config.yml`.
  #
  #
  #
  module UnifiedLocalConfigurable

    def config_file
      'config.yml'
    end

    def confection_read
      path = name.downcase.split('::')
      if File.exist?(config_file)
        data = YAML.load_file(config_file)
        node = data
        path.each do |n|
          node = node ? node[n] : node
        end
        confection_apply(node)
      end
    end

    def confection_apply(data)
      Confection.apply(node, self)
    end
  end
  
end

