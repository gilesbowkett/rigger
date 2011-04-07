require "net/ssh"
require "net/sftp"
require "popen4"

module Rigger
  class TaskExecutor
      class SFTPTransferWrapper
        attr_reader :operation

        def initialize(session, &callback)
          @sftp = session.sftp(false).connect  do |sftp|
            @operation = callback.call(sftp)
          end
        end

        def active?
          @operation.nil? || @operation.active?
        end

        def [](key)
          @operation[key]
        end

        def []=(key, value)
          @operation[key] = value
        end

        def abort!
          @operation.abort!
        end
      end

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
      execute(command, @current_servers) do |ch|
        ch.on_data do |c, data|
          data.split("\n").each do |line|
            puts " ** [#{ch[:host]} :: stdout] #{line}"
            $stdout.flush
          end
        end

        ch.on_extended_data do |c, type, data|
          data.split("\n").each do |line|
            puts " ** [#{ch[:host]} :: stderr] #{line}"
            $stderr.flush
          end
        end
      end
    end

    def capture(command)
      "".tap do |captured|
        execute(command, [@current_servers.first]) do |ch|
          ch.on_data do |c, data|
            captured << data
          end

          ch.on_extended_data do |c, type, data|
            data.split("\n").each do |line|
              puts " ** [#{server.connection_string} :: stderr] #{line}"
              $stderr.flush
            end
          end
        end
      end
    end

    def run_task(task_name)
      @execution_service.call(task_name)
    end

    def run_locally(command)
      puts "  * executing `#{command}` locally"
      status = POpen4.popen4(command) do |stdout, stderr, stdin, pid|
        stdout.each_line do |line|
          puts " ** [locally :: stdout] #{line}"
        end

        stderr.each_line do |line|
          puts " ** [locally :: stderr] #{line}"
        end
      end

      if status && status.exitstatus == 0
        puts "  * command finished"
      else
        raise CommandError, "Local command `#{command}` failed."
      end
    end

    def get(name)
      @config.get(name)
    end

    def set(name, value)
      @config.set(name, value)
    end

    def fetch(name, default)
      @config.fetch(name, default)
    end

    def put(data, path)
      servers  = @current_servers.dup
      channels = servers.map do |s|
        callback = Proc.new do |channel, name, sent, total|
          puts "[#{channel[:host]}] #{name}" if sent == 0
        end

        SFTPTransferWrapper.new(s.connection) do |sftp|
          io = StringIO.new(data.respond_to?(:read) ? data.read : data)
          sftp.upload(io, path, {}) do |status, we|
            if status == :finish
              sftp.close_channel
            end
          end
        end
      end

      puts "  * transerring data to #{path}"

      connections = servers.dup

      failing_servers = []
      errors          = []

      loop do
        connections.delete_if do |server|
          begin
            !server.connection.process(0.1) { |s| s.busy? }
          rescue Net::SFTP::StatusException => e
            failing_servers << server
            errors << e.message
          end
        end
        break if connections.empty?
      end

      if !failing_servers.empty?
        raise CommandError, "Upload failed on #{failing_servers.map { |s| s.connection_string }.inspect} with #{errors.join(", ")}."
      end

      puts "  * finished"
    end

    protected
      def execute(command, servers)
        puts "  * executing `#{command}`"
        puts "    servers: #{servers.map { |s| s.connection_string }.inspect}"
        channels = servers.map do |server|
          puts "    [#{server.connection_string}] executing command"
          server.connection.open_channel do |ch|
            ch.exec(command) do |ch, success|
              ch[:host] = server.connection_string

              yield ch

              ch.on_request("exit-status") do |ch, data|
                ch[:status] = data.read_long
              end

              ch.on_close do |ch|
                ch[:closed] = true
              end
            end
          end
        end

        connections = servers.map { |s| s.connection }

        loop do
          connections.delete_if { |ssh| !ssh.process(0.1) { |s| s.busy? } }
          break if connections.empty?
        end

        failing_servers = channels.select { |ch| ch[:status] != 0 }
        if failing_servers.empty?
          puts "  * command finished"
        else
          raise CommandError, "Command `#{command}` failed on #{failing_servers.map { |ch| ch[:host] }.inspect}."
        end
      end
    end
end
