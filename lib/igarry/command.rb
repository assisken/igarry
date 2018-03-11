require 'igarry/command_container'

module Igarry
  class Command
    attr_reader :name, :permissions, :state
    def initialize(name, args = {}, &block)
      @name = name
      @block = block
      @permissions = args[:permissions] || [:ALL]
      @state = args[:state] || State::NONE
    end

    def call(bot, message)
      @block.call bot, message
    end
  end
end