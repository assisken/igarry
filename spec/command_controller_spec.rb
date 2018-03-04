require 'igarry/command_controller'
require 'igarry/command'
require 'logger'
require 'telegram/bot'

LOGGER = Logger.new nil

module Igarry
  describe CommandController do
    before :all do
      @command_admin = CommandClass.new(:test_admin, permissions: [:ADMIN]) do
        'I\'m test command'
      end
      @command = CommandClass.new(:test, permissions: [:ALL]) do
        'Hello there!'
      end
      @command_controller = Igarry::CommandController.new
      @command_controller.add @command_admin
      @command_controller.add @command
    end

    context 'using commands' do
      it 'must correctly transform string to symbol' do
        expect(@command_controller.get_command('/test').name).to be(:test)
      end

      it 'must correctly call command' do
        expect(@command_controller.get_command('/test').call(nil, nil)).to eq('Hello there!')
        expect { @command_controller.get_command('test').call(nil, nil) }
          .to raise_error(NoMethodError, 'undefined method `call\' for nil:NilClass')
      end

      it 'must recognise permissions correctly' do
        admin = ENV['ADMIN']
        id = 0
        expect(@command_controller.permission?(@command_admin, admin)).to be true
        expect(@command_controller.permission?(@command_admin, id)).to be false
        expect(@command_controller.permission?(@command, admin)).to be true
        expect(@command_controller.permission?(@command, id)).to be true
      end
    end
  end
end
