require "rigger/connection_set"
require "rigger/server_resolver"
require "rigger/task_executor"
require "rigger/execution_strategy"

module Rigger
  class TaskExecutionService
    def initialize(config,
                   server_resolver             = ServerResolver.new(config),
                   execution_strategy_selector = ExecutionStrategy::Selector.new)
      @config                      = config
      @server_resolver             = server_resolver
      @execution_strategy_selector = execution_strategy_selector
    end

    def call(task_name)
      task    = @config.locate_task(task_name)
      servers = @server_resolver.call(task)
      
      puts "  * executing '#{task_name}'"

      strategy = @execution_strategy_selector.call(task)
      strategy.call(task, servers, @config, self)
    end
  end
end
