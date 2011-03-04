require "spec_helper"

describe "Rigger::ServerResolver" do
  before do
    @server = stub("Server", :options => {})
    @config = stub("Config", :servers => [@server])
  end

  it "flunks" do
    true.should == false
  end
end
