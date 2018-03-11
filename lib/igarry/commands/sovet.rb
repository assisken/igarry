require 'igarry/command_container'

module Igarry
  module Sovet
    extend Igarry::CommandContainer
    command :sovet do |bot|
      if bot.sovets.empty?
        bot.reply('Советов нет. И не жди!')
      else
        bot.reply(bot.sovets.random)
      end
    end
  end
end
