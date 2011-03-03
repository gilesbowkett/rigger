require "net/ssh"

module Rigger
  class ConnectionSet
    def initialize
      @connections = {}
    end

    def call(server)
      @connections[server] ||= Net::SSH.start(server.host, server.user)
    end
  end
end
