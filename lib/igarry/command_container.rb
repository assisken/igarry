module Igarry
  module CommandContainer
    def command(name, args = {}, &block)
      @command = Command.new(name, args, &block)
    end
  end
end