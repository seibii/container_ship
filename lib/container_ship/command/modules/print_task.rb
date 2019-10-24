module ContainerShip
  module Command
    module Modules
      module PrintTask
        private

        def print_around_task(message)
          print message
          result = yield
          puts "Done"
          result
        end
      end
    end
  end
end
