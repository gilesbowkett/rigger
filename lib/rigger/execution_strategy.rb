module Rigger
  module ExecutionStrategy
    class BasicExecutionStrategy
      def initialize(executor_factory = TaskExecutor)
        @executor_factory = TaskExecutor
      end

      def call(task, servers, config, execution_service)
        @executor_factory.new(task, servers, config, execution_service).call
      end
    end

    class SerialExecutionStrategy < BasicExecutionStrategy
      def call(task, servers, config, execution_service)
        servers.each do |s|
          super(task, [s], config, execution_service)
        end
      end

      def appropriate_strategy_for?(task)
        task.options[:serial]
      end
    end

    class SingleExecutionStrategy < BasicExecutionStrategy
      def call(task, servers, config, execution_service)
        super(task, [servers.first], config, execution_service)
      end

      def appropriate_strategy_for?(task)
        task.options[:single]
      end
    end

    class Selector
      def initialize(basic_strategy = BasicExecutionStrategy.new,
                     strategies     = [SerialExecutionStrategy.new,
                                       SingleExecutionStrategy.new])
        @basic_strategy = basic_strategy
        @strategies     = strategies
      end

      def call(task)
        appropriate_strategies = @strategies.select do |s|
          s.appropriate_strategy_for?(task)
        end

        if appropriate_strategies.length > 1
          raise MultipleAppropriateStrategies, 
            "More than one strategy was appropriate for #{task.name}."
        else
          appropriate_strategies.first || @basic_strategy
        end
      end
    end
  end
end
