module Rigger
  class Server < Struct.new(:role, :host, :options)
    attr_accessor :connection
  end
end
