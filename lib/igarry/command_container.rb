module Igarry
  module State
    NONE = 0
    ALL = 1
    ADDING = 2
  end

  module CommandContainer
    def command(name, args = {}, &block)
      @command = Command.new(name, args, &block)
    end
  end
end