require 'igarry/command'
require 'igarry/state_controller'
require 'logger'

module Igarry
  class CommandController
    def initialize
      @container = {}
      @state_controller = StateController.new
      @users = { ADMIN: [ENV['ADMIN'].to_i] }
      @permissions = %i[ALL ADMIN].freeze
    end

    def add(command)
      raise 'Already has' if @container.include? command.name
      @container[command.name] = command if command.is_a? Command
      LOGGER.debug "Adding command #{command.name}..."
      LOGGER.debug @container
    end

    def call(bot, message)
      command = get_command message.text
      author = message.from.id
      begin
        command.call bot, message if !command.nil? && (permission? command, author) && (@state_controller.has? command.state, author)
      rescue RuntimeError => e
        LOGGER.error e
        e
      end
    end

    def add_state(state, id)
      @state_controller.add state, id
    end

    def remove_state(id)
      @state_controller.remove id
    end

    private

    def get_command(command_name)
      command_name[0] = ''
      name = command_name.to_sym
      raise 'No such command' unless @container.include? name
      @container[name]
    end

    def permission?(command, user_id)
      return true if command.permissions.include? :ALL
      has_permission = false
      command.permissions.each { |perm| return true if @users[perm].include? user_id }
      raise 'No such permissions!' unless has_permission
    end
  end
end
