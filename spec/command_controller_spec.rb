require 'igarry/command_controller'
require 'igarry/command'
require 'logger'
require 'telegram/bot'

LOGGER = Logger.new nil
LOGGER.level = Logger::ERROR

module Igarry
  describe CommandController do
    let(:controller)    { Igarry::CommandController.new }
    let(:user_command)  { Command.new(:test, permissions: [:ALL]) { 'Hello there!' } }
    let(:admin_command) { Command.new(:test_admin, permissions: [:ADMIN]) { 'I\'m test command' } }
    let(:user_message) do
      message = Telegram::Bot::Types::Message.new
      message.from = Telegram::Bot::Types::User.new
      message.from.id = 0
      message.text = '/test'
      message
    end
    let(:admin_message) do
      admin = user_message.clone
      admin.from.id = 1
      admin.text = '/test_admin'
      admin
    end
    before do
      controller.instance_variable_set :@users, ADMIN: [1]
      controller.add user_command
      controller.add admin_command
    end


    describe '.add' do
      subject { controller.instance_variable_get(:@container) }

      it('includes a user command') { expect include user_command.name }
      it('includes an admin command') { expect include admin_command.name }
    end

    describe '.call' do
      subject(:wrong_message) do
        wrong = user_message.clone
        wrong.text = 'test'
        wrong
      end

      it('calls a command') { expect(controller.call(nil, user_message)).to eq('Hello there!') }
      it 'calls wrong command' do
        expect { controller.call(nil, wrong_message) }
          .to raise_error(RuntimeError, 'No such command')
      end
    end

    describe 'permission' do
      context 'for admin' do
        subject(:admin) { 1 }

        it('passes admin command') { expect(controller.call(nil, admin_message)).to eq('I\'m test command') }
        it('passes user command')  { expect(controller.call(nil, admin_message)).to eq('I\'m test command') }
      end

      context 'for user' do
        subject(:user) { 0 }
        subject(:user_message2) do
          message = admin_message.clone
          message.from.id = user
          message
        end

        it('passes user command') { expect(controller.call(nil, user_message)).to eq('Hello there!') }
        it('does\'t pass admin command') { expect(controller.call(nil, user_message2)).to be_instance_of RuntimeError }
      end
    end
  end
end
