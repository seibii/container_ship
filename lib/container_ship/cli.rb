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
    method_option 'timeout', default: 300, type: :numeric, desc: 'Timeout seconds for executing the task.'
    method_option 'no_wait', default: false, type: :boolean, desc: 'Exit without waiting for the task execution results. Default false.'
    def exec(cluster_name, service_name, environment, build_number)
      timeout = options['timeout']
      no_wait = options['no_wait']
      Command::ExecCommand.new.run(cluster_name, service_name, environment, build_number, timeout: timeout, no_wait: no_wait)
    end

    desc 'version', 'display gem version'
    def version
      say ContainerShip::VERSION
    end
  end
end
