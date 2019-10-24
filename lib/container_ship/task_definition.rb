module ContainerShip
  class TaskDefinition
    attr_reader :cluster_name, :name, :environment, :build_number

    def initialize(cluster_name, type, name, environment, build_number)
      @cluster_name = cluster_name
      @type = type
      @name = name
      @environment = environment
      @build_number = build_number
    end

    def to_h
      task_definition_hash
        .merge(
          family: full_name,
          container_definitions: task_definition_hash[:container_definitions].map do |d|
            next d unless d[:essential]

            d.merge(name: full_name, image: "#{image_name}:#{@build_number}")
          end
        )
    end

    def full_cluster_name
      "#{@cluster_name}-#{@environment}"
    end

    def full_name
      "#{@cluster_name}-#{@name}-#{@environment}"
    end

    def image_name
      ENV.fetch('ECR_REPOSITORY') + full_cluster_name
    end

    def log_group_name
      return nil unless main_container_definition.dig(:log_configuration, :log_driver).to_s == 'awslogs'

      main_container_definition.dig(:log_configuration, :options, :'awslogs-group')
    end

    def log_stream_name(task_arn)
      return nil unless main_container_definition.dig(:log_configuration, :log_driver).to_s == 'awslogs'

      task_name = main_container_definition.dig(:name)
      prefix = main_container_definition.dig(:log_configuration, :options, :'awslogs-stream-prefix')

      "#{prefix}/#{task_name}/#{task_arn.split('/').last}"
    end

    private

    def task_definition_hash
      @task_definition_hash ||= JSON.parse(File.read(task_definition_path), symbolize_names: true)
    end

    def task_definition_path
      File.join('.container_ship', @cluster_name, @type, @name, @environment, 'task_definition.json')
    end

    def main_container_definition
      task_definition_hash[:container_definitions].find { |definition| definition[:essential] }
    end
  end
end
