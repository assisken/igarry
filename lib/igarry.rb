require 'logger'
require 'igarry/bot'

LOGGER = Logger.new STDOUT
LOGGER.level = Logger::DEBUG
LOGGER.progname = 'igarry'
LOGGER.formatter = proc do |severity, datetime, progname, msg|
  date_format = datetime.strftime('%Y-%m-%d %H:%M:%S')
  "[#{date_format}] #{severity} (#{progname}): #{msg}\n"
end



file = File.open 'sovets.txt', 'a+'
bot = Igarry::Bot.new file: file

require 'igarry/commands/sovet'
require 'igarry/commands/reload'

bot.include! Igarry::Sovet
bot.include! Igarry::Reload

LOGGER.debug bot.sovets.container

bot.start

file.close