module Rigger
  class Server < Struct.new(:role, :connection_string, :options)
    def host
      @connection_string.split("@").last
    end

    def user
      @connection_string.split("@").first
    end
  end
end
