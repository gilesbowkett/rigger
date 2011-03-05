require "rigger/dsl"
require "rigger/task_execution_service"
require "optparse"

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
      options = parse_options
      load_config_file
      load_builtin_recipes

      if options[:display_tasks]
        display_tasks
      else
        run_tasks
      end
    end

    protected
      def load_config_file
        @config_file = locate_config_file
        @config      = @dsl.new
        @config.load_from_file(@config_file)
      end

      def load_builtin_recipes
        Dir[File.dirname(__FILE__) + "/recipes/**/*.rb"].each do |f|
          @config.load_from_file f
        end
      end

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

      def run_tasks
        executor = @task_execution_service_factory.new(@config)

        @args.each do |task_name|
          executor.call(task_name)
        end
      end

      def parse_options
        {}.tap do |options|
          OptionParser.new do |opts|
            opts.banner = "Usage: #{$0} [options]"
            opts.on("-T", "--tasks", "Display tasks.") do
              options[:display_tasks] = true
            end
          end.parse!
        end
      end

      def display_tasks
        @config.tasks.sort_by { |t| t.name }.each do |task|
          puts "rig #{task.name}"
        end
      end
  end
end
