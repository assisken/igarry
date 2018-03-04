require 'logger'

LOGGER = Logger.new STDOUT
LOGGER.level = Logger::DEBUG

require 'igarry/version'
require 'igarry/bot'
require 'igarry/commands/sovet'

module Igarry
  # bot = Bot.instance
  # bot.run
end
