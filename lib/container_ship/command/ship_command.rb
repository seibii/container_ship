# frozen_string_literal: true

require 'aws-sdk-ecs'
require 'json'
require 'open3'

require 'container_ship/command/modules/docker'
require 'container_ship/command/modules/ecs'
require 'container_ship/command/modules/print_task'

module ContainerShip
  module Command
    class ShipCommand
      include Modules::Docker
      include Modules::Ecs
      include Modules::PrintTask

      def run(cluster_name, service_name, environment, build_number)
        task_definition = TaskDefinition.new(
          cluster_name,
          'services',
          service_name,
          environment,
          build_number
        )

        push_image task_definition

        revision = print_around_task('Registering task definition... ') do
          register task_definition
        end

        print_around_task('Updating service... ') do
          update_service task_definition, revision
        end
      end
    end
  end
end
