require "rigger/task"
require "rigger/server"

module Rigger
  class DSL
    attr_reader :tasks, :servers

    def initialize(server_factory = Server,
                   task_factory   = Task,
                   file           = File)
      @server_factory    = server_factory
      @task_factory      = task_factory
      @file              = file
      @tasks             = []
      @servers           = []
      @current_namespace = []
      @vars              = {}
    end

    def namespace(name, &block)
      @current_namespace << name
      yield
      @current_namespace.pop
    end

    def server(role, host, options = {})
      @servers << @server_factory.new(role, host, options)
    end

    def task(name, options = {}, &block)
      @tasks << @task_factory.new((@current_namespace + [name]).join(":"), options, block)
    end

    def load_from_file(filename)
      instance_eval(@file.read(filename), filename)
    end

    def locate_task(name)
      @tasks.detect { |t| t.name == name } || missing_task(name)
    end

    def set(name, value)
      @vars[name.to_s] = value
    end

    def get(name)
      @vars[name.to_s] || missing_var(name)
    end

    protected
    def missing_task(name)
      raise "Can't find a task called #{name}."
    end

    def missing_var(name)
      raise "Can't find a variable named #{name}."
    end
  end
end
