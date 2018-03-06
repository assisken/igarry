require 'igarry/command_container'

module Igarry
  module Reload
    extend CommandContainer

    command :reload, permissions: [:ADMIN] do |bot|
      bot.sovets.reload
      bot.reply('Successfully reloaded!')
    end
  end
end