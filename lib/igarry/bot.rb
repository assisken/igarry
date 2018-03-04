require 'telegram/bot'
require 'igarry/command_controller'

module Igarry
  class Bot
    include Singleton
    def initialize
      @token              = ENV['BOT_TOKEN']
      @command_controller = CommandController.new
    end

    def command(command)
      @command_controller.add(command)
    end

    def run
      Telegram::Bot::Client.run(@token) do |bot|
        bot.listen do |message|
          @command_controller.call(bot, message)
        end
      end
    end
  end
end
