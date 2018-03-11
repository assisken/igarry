require 'logger'
require 'igarry/bot'

LOGGER = Logger.new STDOUT
LOGGER.level = Logger::DEBUG
LOGGER.progname = 'igarry'
LOGGER.formatter = proc do |severity, datetime, progname, msg|
  date_format = datetime.strftime('%Y-%m-%d %H:%M:%S')
  "[#{date_format}] #{severity} (#{progname}): #{msg}\n"
end

sov_file = File.open 'sovets.txt', 'a+'
bot = Igarry::Bot.new file: sov_file

Dir["#{File.dirname(__FILE__)}/igarry/commands/*.rb"].each { |file| require file }

bot.include! Igarry::Add
bot.include! Igarry::Cancel
bot.include! Igarry::Reload
bot.include! Igarry::Sovet

LOGGER.debug bot.sovets.container

bot.start

sov_file.close