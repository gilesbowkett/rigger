require "spec_helper"
require "rigger/server_resolver"

describe "Rigger::ServerResolver" do
  before do
    @server1  = stub("Server", :options => {}, :role => :db)
    @server2  = stub("Server", :options => {}, :role => :app)
    @servers  = [@server1, @server2]
    @config   = stub("Config", :servers => @servers)
    @resolver = Rigger::ServerResolver.new(@config)
  end

  describe "when the task has no options" do
    before do
      @task = stub("Config", :options => {})
    end

    it "returns all the servers" do
      @resolver.call(@task).should == @servers
    end
  end

  describe "when the task specifies a role" do
    before do
      @task = stub("Config", :options => {:role => :app})
    end

    it "returns all the servers matching that role" do
      @resolver.call(@task).should == [@server2]
    end
  end
end
