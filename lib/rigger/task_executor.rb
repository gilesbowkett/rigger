require "net/ssh"

module Rigger
  class TaskExecutor
    def initialize(task, servers, execution_service, config)
      @task              = task
      @current_servers   = servers
      @execution_service = execution_service
      @config            = config
    end

    def call
      instance_eval(&@task.block)
    end

    def run(command)
      puts "  * executing `#{command}`"
      puts "    servers: #{@current_servers.map { |s| s.connection_string }.inspect}"
      channels = @current_servers.map do |server|
        puts "    [#{server.connection_string}] executing command"
        server.connection.open_channel do |ch|
          ch.exec(command) do |ch, success|
            ch[:host] = server.connection_string

            ch.on_data do |c, data|
              data.split("\n").each do |line|
                puts " ** [#{server.connection_string} :: stdout] #{line}"
              end
            end

            ch.on_extended_data do |c, type, data|
              data.split("\n").each do |line|
                puts " ** [#{server.connection_string} :: stderr] #{line}"
              end
            end

            ch.on_request("exit-status") do |ch, data|
              ch[:status] = data.read_long
            end

            ch.on_close do |ch|
              ch[:closed] = true
            end
          end
        end
      end

      threads = @current_servers.map { |server| Thread.new { server.connection.loop }  }

      loop do
        break if threads.all? { |t| !t.alive? }
      end

      failing_servers = channels.select { |ch| ch[:status] != 0 }
      if failing_servers.empty?
        puts "  * command finished"
      else
        raise CommandError, "Command `#{command}` failed on #{failing_servers.map { |ch| ch[:host] }.inspect}."
      end
    end

    def run_task(task_name)
      @execution_service.call(task_name)
    end

    def get(name)
      @config.get(name)
    end

    def set(name, value)
      @config.set(name, value)
    end
  end
end
