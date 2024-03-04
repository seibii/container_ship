# frozen_string_literal: true

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
          puts command

          status = nil
          Open3.popen3(command) do |_stdin, stdout, stderr, wait_thr|
            Thread.new(stdout) { |io| io.each { puts _1 } }
            Thread.new(stderr) { |io| io.each { puts _1 } }

            status = wait_thr.value
          end
          exit(status.exitstatus) unless status.success?
        end
      end
    end
  end
end
