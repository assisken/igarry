module Igarry
  class CommandClass
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

  module Command
    def command(name, args = {}, &block)
      Bot.instance.command_admin(CommandClass.new(name, args, &block))
    end
  end
end