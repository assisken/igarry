require 'igarry/sovets'
require 'securerandom'
require 'fileutils'

module Igarry
  describe Sovets do
    before :all do
      @file = 'test_sovets.txt'
      @rand_file = 'test_' + SecureRandom.gen_random(5).delete("\000")
      @sovets = Sovets.instance

      File.write @file, "test\nsovet"
    end

    after :all do
      FileUtils.remove @file
      FileUtils.remove @rand_file
    end

    context 'file loading' do
      it 'should contain test and sovet' do
        @sovets.load @file
        expect(@sovets.sovets).to contain_exactly('test', 'sovet')
      end

      it 'should be empty' do
        @sovets.load @rand_file
        expect(@sovets.sovets).to be_empty
        expect(File.exist?(@rand_file)).to be true
      end
    end

    context 'corrent working' do
      it 'should get random sovet' do
        @sovets.load @file
        expect(@sovets.random).to(satisfy) { |value| %w[test sovet].include? value }
        @sovets.load @rand_file
        expect(@sovets.random).to be_nil
      end
    end
  end
end
