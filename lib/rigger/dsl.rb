module Rigger
  class DSL
    attr_reader :tasks, :servers

    def initialize(server_factory = Server,
                   task_factory   = Task,
                   file           = File)
      @server_factory = server_factory
      @task_factory   = task_factory
      @file           = file
      @tasks          = []
      @servers        = []
    end

    def server(role, host, options = {})
      @servers << @server_factory.new(role, host, options)
    end

    def task(name, options = {}, &block)
      @tasks << @task_factory.new(name, options, block)
    end

    def load_file(filename)
      instance_eval(@file.read(filename))
    end
  end
end
