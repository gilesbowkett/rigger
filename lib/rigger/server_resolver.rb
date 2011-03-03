module Rigger
  class ServerResolver
    def initialize(config)
      @config = config
    end

    def call(task)
      # TODO: Might wanna implement this.
      @config.servers
    end
  end
end
