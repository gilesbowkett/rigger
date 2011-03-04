module Rigger
  class Error < RuntimeError; end
  class NoMatchingServers < Error; end
  class CommandError < Error; end
end
