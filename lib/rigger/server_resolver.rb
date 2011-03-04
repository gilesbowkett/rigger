module Rigger
  class ServerResolver
    def initialize(config)
      @config = config
    end

    def call(task)
      roles = [*task.options[:role]].compact
      only  = task.options.fetch(:only, {})

      role_servers = roles.empty? ? @config.servers : from_roles(roles)
      only_servers = only.empty?  ? @config.servers : from_only(only)

      role_servers & only_servers
    end

    protected
      def from_roles(roles)
        roles.map do |role|
          @config.servers.select do |server|
            server.role == role
          end
        end.flatten
      end

      def from_only(only)
        @config.servers.select do |server|
          only.all? do |key, value|
            server.options[key] == value
          end
        end
      end
  end
end
