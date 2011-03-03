require "rigger/connection_set"
require "rigger/server_resolver"

module Rigger
  class TaskExecutionService
    def initialize(server_resolver   = ServerResolver.new,
                   execution_context = ExecutionContext.new)
      @server_resolver   = server_resolver
      @execution_context = execution_context
    end

    def call(task)
      servers = @server_resolver.call(task)
      @execution_context.call(&task.block)
    end
  end
end
