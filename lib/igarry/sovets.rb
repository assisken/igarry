require 'singleton'
require 'fileutils'

module Igarry
  class Sovets
    include Singleton
    attr_reader :sovets

    def initialize
      @sovets = []
      load 'sovets.txt'
    end

    def load(path)
      @sovets = File.open(path, 'r').read.split("\n")
    rescue Errno::ENOENT
      FileUtils.touch path
      @sovets = []
    end

    def random
      @sovets.sample
    end
  end
end
