module Igarry
  class Sovets
    attr_reader :container

    def initialize(file = nil)
      @file = file
      @container = file.nil? ? [] : @file.read.split("\n")
    end

    def empty?
      @container.empty?
    end

    def random
      @container.sample
    end

    def reload(file = nil)
      LOGGER.info 'Reloading sovets...'
      @container = if file.nil?
                     @file.rewind
                     @file.read.split("\n")
                   else
                     file.read.split("\n")
                   end
    end
  end
end
File