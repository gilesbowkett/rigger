require "rigger/connection_set"
require "rigger/server_resolver"
require "rigger/task_executor"

module Rigger
  class TaskExecutionService
    def initialize(config,
                   server_resolver  = ServerResolver.new(config),
                   executor_factory = TaskExecutor)
      @config           = config
      @server_resolver  = server_resolver
      @executor_factory = executor_factory
    end

    def call(task_name)
      task    = @config.locate_task(task_name)
      servers = @server_resolver.call(task)

      if task.options[:serial]
        servers.each { |s| execute(task, [s]) }
      else
        execute(task, servers)
      end
    end

    private
      def execute(task, servers)
        @executor_factory.new(task, servers, self, @config).call
      end
  end
end
