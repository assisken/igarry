require 'igarry/command_controller'
require 'igarry/command'
require 'logger'
require 'telegram/bot'

LOGGER = Logger.new nil

module Igarry
  describe CommandController do
    let(:controller)    { Igarry::CommandController.new }
    let(:user_command)  { Command.new(:test, permissions: [:ALL]) { 'Hello there!' } }
    let(:admin_command) { Command.new(:test_admin, permissions: [:ADMIN]) { 'I\'m test command' } }
    before do
      controller.add user_command
      controller.add admin_command
    end


    describe '.add' do
      subject { controller.instance_variable_get(:@container) }

      it('includes a user command') { expect include user_command.name }
      it('includes an admin command') { expect include admin_command.name }
    end

    describe '.get_command' do
      subject(:command) { controller.get_command('/test') }
      subject(:wrong_command) { controller.get_command('test') }

      it('transforms a string to a symbol') { expect(command.name).to be(:test) }
      it('calls a command') { expect(command.call(nil, nil)).to eq('Hello there!') }

      it 'calls wrong command' do
        expect { wrong_command.call(nil, nil) }
          .to raise_error(NoMethodError, 'undefined method `call\' for nil:NilClass')
      end
    end

    describe '.permission?' do
      context 'admin' do
        subject(:admin) { ENV['ADMIN'] }

        it('passes admin command') { expect(controller.permission?(user_command, admin)).to be_truthy }
        it('passes user command') { expect(controller.permission?(admin_command, admin)).to be_truthy }
      end

      context 'user' do
        subject(:user) { 0 }

        it('passes user command') { expect(controller.permission?(user_command, user)).to be_truthy }
        it('does\'t pass admin command') { expect(controller.permission?(admin_command, user)).to be_falsey }
      end
    end
  end
end
