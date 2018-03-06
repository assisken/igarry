module Igarry
  class Command
    attr_reader :name, :permissions
    def initialize(name, args = {}, &block)
      @name = name
      @block = block
      @permissions = args[:permissions] || [:ALL]
    end

    def call(bot, message)
      @block.call bot, message
    end
  end
end