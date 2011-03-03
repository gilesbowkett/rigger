require "rigger/connection_set"
require "rigger/server_resolver"

module Rigger
  class TaskExecutionService
    def initialize(server_resolver  = ServerResolver.new,
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
      def execut(task, servers)
        @executor_factory.new(task, servers.call
      end
  end
end
