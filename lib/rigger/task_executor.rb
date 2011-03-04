require "net/ssh"

module Rigger
  class TaskExecutor
    def initialize(task, servers, execution_service)
      @task              = task
      @current_servers   = servers
      @execution_service = execution_service
    end

    def call
      instance_eval(&@task.block)
    end

    def run(command)
      @current_servers.map do |server|
        puts "Running #{command} on #{server.connection_string}."
        Thread.new do
          server.connection.exec!(command) do |channel, stream, data|
            data.split("\n").each { |line| puts "[#{server.connection_string} #{stream}]: #{line}" }
          end
        end
      end.each { |t| t.join }
    end

    def run_task(task_name)
      @execution_service.call(task_name)
    end
  end
end
