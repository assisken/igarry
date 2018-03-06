require 'igarry/sovets'
require 'securerandom'
require 'fileutils'

module Igarry
  describe Sovets do
    let(:file)         { StringIO.new "test\nsovet" }
    let(:empty_file)   { StringIO.new }
    let(:sovets)       { Sovets.new file }
    let(:empty_sovets) { Sovets.new empty_file }

    describe 'loading' do
      it('contains test, sovet') { expect(sovets.container).to contain_exactly('test', 'sovet') }
      it('contains empty file') { expect(empty_sovets.container).to be_empty }
    end

    describe '.random' do
      context 'not empty' do
        subject { sovets.random }
        it('returns a random sovet') { expect satisfy { |value| %w[test sovet].include? value } }
      end

      context 'empty' do
        it('returns a nil') { expect(empty_sovets.random).to be_nil }
      end
    end

    describe '.reload' do
      context 'sovets' do
        it('nothing happened') { expect(sovets.reload).to contain_exactly('test', 'sovet') }

        subject(:new) { StringIO.new file.string + "\nthird" }
        it('adds new item') do
          expect(sovets.reload(new))
            .to contain_exactly('test', 'sovet', 'third')
        end
      end

      context 'empty' do
        it('nothing happened') { expect(empty_sovets.reload).to be_empty }
        it('should contain test, sovet') do
          expect(empty_sovets.reload(file))
            .to contain_exactly('test', 'sovet')
        end
      end
    end
  end
end
