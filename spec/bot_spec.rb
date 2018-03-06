require 'igarry/bot'
require 'igarry/command_container'
require 'telegram/bot/types/message'

module Igarry
  module TestCommand
    extend CommandContainer
    command :test do
      'Test command...'
    end
  end

  describe Bot do
    let(:bot) { Bot.new }

    describe '.include!' do
      it 'adds command to controller' do
        bot.include! TestCommand
        message = Telegram::Bot::Types::Message.new
        from = Telegram::Bot::Types::User.new
        from.id = 0
        message.from = from
        message.text = '/test'
        expect(bot.execute(bot, message)).to eq('Test command...')
      end
    end
  end
end
