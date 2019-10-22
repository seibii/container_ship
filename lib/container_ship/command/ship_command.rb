require 'aws-sdk-ecs'
require 'json'
require 'open3'

module ContainerShip
  module Command
    class ShipCommand
      def run(cluster_name, service_name, environment, build_number)
        json = read_task_definition(cluster_name, service_name, environment)

        definition = json[:container_definitions]
          .find { |definition| definition[:image].include?('<image_number>') }

        image_name = definition[:image].split(':').first
        definition[:image] = definition[:image].gsub('<image_number>', build_number.to_s)

        push_image(image_name, build_number)
        revision = register(json)
        update_service(cluster_name, service_name, environment, revision)
      end

      private

      def aws_ecs_client
        @aws_ecs_client ||= Aws::ECS::Client.new
      end

      def sh(command)
        Open3.popen3(command) { |_i, o, _e, _w| o.each { |line| puts line } }
      end

      def read_task_definition(cluster_name, service_name, environment)
        file = File.read(File.join('.container_ship', cluster_name, 'services', service_name, environment, "task_definition.json"))
        JSON.parse(file, symbolize_names: true)
      end

      def push_image(image_name, build_number)
        sh "docker build -t \"#{image_name}:#{build_number}\" ."
        sh "docker push #{image_name}:#{build_number}"
      end

      def register(json)
        print "Registering task definition... "
        revision = aws_ecs_client
          .register_task_definition(json)
          .task_definition
          .revision
        puts "Done"
        revision
      end

      def update_service(cluster_name, service_name, environment, revision)
        print "Updating service... "
        aws_ecs_client.update_service(
          cluster: "#{cluster_name}-#{environment}",
          service: "#{cluster_name}-#{service_name}-#{environment}",
          task_definition: "#{cluster_name}-#{environment}:#{revision}"
        )
        puts 'Done'
      end
    end
  end
end
