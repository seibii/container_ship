# frozen_string_literal: true

module ContainerShip
  module Command
    module Modules
      module Docker
        def push_image(task_definition)
          puts "docker build -t \"#{task_definition.image_name}:#{task_definition.build_number}\" ."
          sh "docker build -t \"#{task_definition.image_name}:#{task_definition.build_number}\" ."
          puts "docker push #{task_definition.image_name}:#{task_definition.build_number}"
          sh "docker push #{task_definition.image_name}:#{task_definition.build_number}"
        end

        private

        def sh(command)
          status = nil
          Open3.popen3(command) do |_i, o, e, w|
            o.each { |line| puts line }
            e.each { |line| puts line }
            status = w.value
          end
          exit(status.exitstatus) unless status.success?
        end
      end
    end
  end
end
