require "rigger/connection_set"
require "rigger/server_resolver"
require "rigger/task_executor"

module Rigger
  class TaskExecutionService
    def initialize(config,
                   server_resolver  = ServerResolver.new(config),
                   executor_factory = TaskExecutor)
      @server_resolver  = server_resolver
      @executor_factory = executor_factory
    end

    def call(task)
      servers  = @server_resolver.call(task)

      if task.options[:serial]
        servers.each { |s| execute(task, [s]) }
      else
        execute(task, servers)
      end
    end

    private
      def execute(task, servers)
        @executor_factory.new(task, servers).call
      end
  end
end
