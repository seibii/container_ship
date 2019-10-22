module ContainerShip
  module Command
    class InitCommand
      def run(cluster_name)
        FileUtils.mkdir_p(".container_ship/#{cluster_name}/tasks")
        puts "Created .container_ship/#{cluster_name}/tasks directory"
        FileUtils.mkdir_p(".container_ship/#{cluster_name}/services")
        puts "Created .container_ship/#{cluster_name}/services directory"

        puts "Next: Create tasks_definition.json file to deploy in tasks or services directory 🖖🏻"
      end
    end
  end
end
