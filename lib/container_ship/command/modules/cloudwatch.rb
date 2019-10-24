module ContainerShip
  module Command
    module Modules
      module Cloudwatch
        def show_log(task_definition, task_arn)
          return if task_definition.log_group_name.nil? || task_definition.log_stream_name(task_arn).nil?

          Aws::CloudWatchLogs::Client.new.get_log_events(
            log_group_name: task_definition.log_group_name,
            log_stream_name: task_definition.log_stream_name(task_arn)
          ).events.map(&:message).each(&method(:puts))
        end
      end
    end
  end
end
