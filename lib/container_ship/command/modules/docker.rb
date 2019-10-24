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
          Open3.popen3(command) { |_i, o, _e, _w| o.each { |line| puts line } }
        end
      end
    end
  end
end
