module Rigger
  class ServerResolver
    def initialize(config)
      @config = config
    end

    def call(task)
      roles = [*task.options[:role]].compact
      if roles.empty?
        @config.servers
      else
        roles.map do |role|
          @config.servers.select do |server|
            server.role == role
          end
        end.flatten
      end
    end
  end
end
