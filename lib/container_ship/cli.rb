# frozen_string_literal: true

require 'fileutils'
require 'thor'

module ContainerShip
  class CLI < Thor
    desc 'init CLUSTER_NAME', 'create container_ship directory with ECS cluster name'
    def init(cluster_name)
      Command::InitCommand.new.run(cluster_name)
    end

    desc 'ship CLUSTER_NAME SERVICE_NAME ENVIRONMENT BUILD_NUMBER', 'deploy specified service'
    def ship(cluster_name, service_name, environment, build_number)
      Command::ShipCommand.new.run(cluster_name, service_name, environment, build_number)
    end

    desc 'exec CLUSTER_NAME SERVICE_NAME ENVIRONMENT BUILD_NUMBER', 'exec specified task'
    method_option 'timeout', desc: 'Timeout seconds for executing the task. Default 5 minutes.'
    def exec(cluster_name, service_name, environment, build_number)
      timeout = options['timeout']&.to_i || 300
      Command::ExecCommand.new.run(cluster_name, service_name, environment, build_number, timeout: timeout)
    end

    desc 'version', 'display gem version'
    def version
      say ContainerShip::VERSION
    end
  end
end
