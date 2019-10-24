module ContainerShip
  module Command
    module Modules
      module Docker
        def push_image(task_definition)
          sh "docker build -t \"#{task_definition.image_name}:#{task_definition.build_number}\" ."
          sh "docker push #{task_definition.image_name}:#{task_definition.build_number}"
        end

        private

        def sh(command)
          status = nil
          Open3.popen3(command) do |_i, o, _e, w|
            o.each { |line| puts line }
            status = w.value
          end
          exit(status.exit_status) unless status.success?
        end
      end
    end
  end
end
