require "net/ssh"

module Rigger
  class TaskExecutor
    def initialize(task, servers)
      @task            = task
      @current_servers = servers
    end

    def call
      instance_eval(&@task.block)
    end

    def run(command)
      @current_servers.map do |server|
        Thread.new do
          exec = server.connection.exec!(command) do |channel, stream, data|
            data.split("\n").each { |line| puts "[#{server.connection_string} #{stream}]: #{line}" }
          end
          puts(exec.inspect)
        end
      end.each { |t| t.join }
    end
  end
end
