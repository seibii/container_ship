# frozen_string_literal: true

module ContainerShip
  module Command
    module Modules
      module Ecs
        def register(task_definition)
          aws_ecs_client
            .register_task_definition(task_definition.to_h)
            .task_definition
            .revision
        end

        def update_service(task_definition, revision)
          aws_ecs_client.update_service(
            cluster: task_definition.full_cluster_name,
            service: task_definition.full_name,
            task_definition: "#{task_definition.full_name}:#{revision}"
          )
        end

        def run_task(task_definition, revision)
          aws_ecs_client
            .run_task(
              cluster: task_definition.full_cluster_name,
              task_definition: "#{task_definition.full_name}:#{revision}"
            )
            .tasks
            .first
            .task_arn
        end

        def wait_task(task_definition, task_arn)
          do_every_5_seconds do
            aws_ecs_client.describe_tasks(cluster: task_definition.full_cluster_name, tasks: [task_arn])
              .tasks
              .first
              .containers
              .first
              .exit_code
          end
        end

        private

        def aws_ecs_client
          @aws_ecs_client ||= Aws::ECS::Client.new
        end

        def do_every_5_seconds
          count = 0
          loop do
            sleep 3
            print '.'
            exit_status = yield
            count += 1
            next if exit_status.nil?
            return 124 if count > 60

            return exit_status
          end
        end
      end
    end
  end
end
