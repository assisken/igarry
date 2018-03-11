require 'igarry/command_container'

module Igarry
  class StateController
    def initialize
      @container = {}
    end

    def add(state, id)
      @container[id] = state
    end

    def has?(state, id)
      return true if @container[id] == state || state == State::ALL || @container[id].nil? && state == State::NONE
      raise 'Wrong state!' unless @container[id] == state
    end

    def remove(id)
      @container.delete id
    end
  end
end
