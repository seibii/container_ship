# frozen_string_literal: true

require 'aws-sdk-ecs'
require 'json'
require 'open3'

require 'container_ship/command/modules/cloudwatch'
require 'container_ship/command/modules/docker'
require 'container_ship/command/modules/ecs'
require 'container_ship/command/modules/print_task'

module ContainerShip
  module Command
    class ExecCommand
      include Modules::Cloudwatch
      include Modules::Docker
      include Modules::Ecs
      include Modules::PrintTask

      def run(cluster_name, task_name, environment, build_number, timeout: nil, no_wait: false)
        task_definition = TaskDefinition.new(cluster_name, 'tasks', task_name, environment, build_number)

        push_image task_definition

        revision = print_around_task('Registering task definition... ') do
          register task_definition
        end

        task_arn = print_around_task('Sending task request... ') do
          run_task task_definition, revision
        end

        return if no_wait

        exit_status = print_around_task('Waiting task is completed... ') do
          wait_task task_definition, task_arn, timeout: timeout
        end

        show_log task_definition, task_arn

        exit exit_status
      end
    end
  end
end
