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
  module NoneCommand
    extend CommandContainer
    command :none, state: State::NONE do
      'Hi!'
    end
  end
  module AddingCommand
    extend CommandContainer
    command :adding, state: State::ADDING do
      'I\'m grout!'
    end
  end

  describe Bot do
    let(:bot) { Bot.new }
    let(:message) do
      message = Telegram::Bot::Types::Message.new
      message.from = Telegram::Bot::Types::User.new
      message.chat = Telegram::Bot::Types::Chat.new
      message
    end

    describe '.include!' do
      it 'adds command to controller' do
        bot.include! TestCommand
        mess = message.clone
        mess.from.id = 0
        mess.text = '/test'
        expect(bot.execute(bot, mess)).to eq('Test command...')
      end
    end

    describe 'state' do
      context 'none command' do
        subject(:mess) do
          mess = message.clone
          mess.from.id = 0
          mess.text = '/none'
          bot.include! NoneCommand
          mess
        end

        it('calls normally') do
          expect(bot.execute(nil, mess)).to eq('Hi!')
        end

        it('raises error at wrong state') do
          bot.add_state State::ADDING, 0
          expect(bot.execute(nil, mess)).to be_instance_of RuntimeError
          bot.remove_state 0
        end
      end

      context 'adding command' do
        subject(:mess) do
          mess = message.clone
          mess.from.id = 0
          mess.text = '/adding'
          bot.include! AddingCommand
          mess
        end

        it('calls normally') do
          bot.add_state State::ADDING, 0
          expect(bot.execute(nil, mess)).to eq('I\'m grout!')
          bot.remove_state 0
        end

        it('raises error at wrong state') do
          expect(bot.execute(nil, mess)).to be_instance_of RuntimeError
        end
      end
    end
  end
end
