require "rigger/dsl"
require "rigger/task_execution_service"

module Rigger
  class CLI
    def initialize(args                           = ARGV,
                   dsl                            = DSL,
                   task_execution_service_factory = TaskExecutionService)
      @args                           = args
      @dsl                            = dsl
      @task_execution_service_factory = task_execution_service_factory
    end

    def start
      @config_file = locate_config_file
      @config      = @dsl.new
      @config.load_from_file(@config_file)
      executor     = @task_execution_service_factory.new(@config)

      @args.each do |task_name|
        executor.call(task_name)
      end
    end

    protected
      def locate_config_file
        location = possible_config_locations.detect { |l| File.exist?(l) }
        location || raise_missing_config_file
      end

      def possible_config_locations
        ["config/rig.rb"]
      end

      def raise_missing_config_file
        raise "Couldn't find a config file in #{possible_config_locations.inspect}"
      end
  end
end
