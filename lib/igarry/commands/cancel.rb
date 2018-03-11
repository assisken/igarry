require 'igarry/command_container'

module Igarry
  module Cancel
    extend CommandContainer

    command :cancel, state: State::ALL do |bot, message|
      bot.remove_state message.from.id
      bot.reply 'Successfully canceled!'
    end
  end
end