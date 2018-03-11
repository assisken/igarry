require 'telegram/bot'
require 'igarry/command_controller'
require 'igarry/sovets'

module Igarry
  class Bot < Telegram::Bot::Client
    attr_reader :sovets

    def initialize(args = {})
      @token              = ENV['BOT_TOKEN']
      @command_controller = CommandController.new
      @sovets             = Sovets.new args[:file]
      @last_chat_id       = nil
      super @token, args
    end

    def add_state(state, id)
      @command_controller.add_state(state, id)
    end

    def remove_state(id)
      @command_controller.remove_state id
    end

    def command(command)
      @command_controller.add(command)
    end

    def execute(bot, message)
      @last_chat_id = message.chat.id
      @command_controller.call(bot, message)
    end

    def include!(command)
      @command_controller.add(command.instance_variable_get(:@command))
    end

    def reply(text, args = {})
      args[:chat_id] = @last_chat_id
      args[:text] = text
      api.send_message(args)
    end

    def start
      listen do |message|
        execute self, message
      end
    end
  end
end
