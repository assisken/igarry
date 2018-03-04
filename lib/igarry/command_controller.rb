require 'igarry/command'
require 'logger'

module Igarry
  class CommandController
    def initialize
      @container = {}
      @users = { ADMIN: [ENV['ADMIN']] }
      @permissions = %i[ALL ADMIN].freeze
    end

    def get_command(command_name)
      command_name[0] = ''
      begin
        @container[command_name.to_sym]
      rescue NoMethodError => e
        LOGGER.error e
        nil
      end
    end

    def add(command)
      @container[command.name] = command if command.is_a? CommandClass
      LOGGER.debug "Adding command #{command.name}..."
      LOGGER.debug @container
    end

    def permission?(command, user_id)
      return true if command.permissions.include? :ALL
      ret = false
      command.permissions.each { |perm| ret = true if @users[perm].include? user_id }
      ret
    end

    def call(bot, message)
      command = get_command message.text
      if !command.nil? && (permission? command, message.from.id)
        command.call bot, message
      else
        LOGGER.info "User #{message.from.first_name} (#{message.from.id}) has no permission to command \"#{command.name}\""
      end
    end
  end
end
