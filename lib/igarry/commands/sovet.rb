require 'igarry/command'
require 'igarry/sovets'

module Igarry
  extend Command
  command :sovet do |bot, message|
    sovet = Sovets.instance.random
    if sovet.nil?
      bot.api.send_message(chat_id: message.chat.id,
                           text: 'Советов нет. И не жди!')
    else
      bot.api.send_message(chat_id: message.chat.id,
                           text: Sovets.instance.random)
    end
  end
end
