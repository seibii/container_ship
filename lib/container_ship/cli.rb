require 'fileutils'
require 'thor'

module ContainerShip
  class CLI < Thor
    desc 'init CLUSTER_NAME', 'create container_ship directory with ECS cluster name'
    def init(cluster_name)
      Command::InitCommand.new.run(cluster_name)
    end

    desc 'version', 'display gem version'
    def version
      say ContainerShip::VERSION
    end
  end
end
