require "rigger/task"
require "rigger/server"

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

    def load_from_file(filename)
      instance_eval(@file.read(filename), filename)
    end

    def locate_task(name)
      @tasks.detect { |t| t.name == name.to_sym } || missing_task(name)
    end

    protected
    def missing_task(name)
      raise "Can't find a task called #{name}."
    end
  end
end
