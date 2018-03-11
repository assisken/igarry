require 'igarry/command_container'

module Igarry
  module Add
    extend CommandContainer

    command :add, permissions: [:ADMIN] do |bot, message|
      bot.add_state State::ADDING, message.from.id
      bot.reply 'Type message to add sovet.'
    end
  end
end