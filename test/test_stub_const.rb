require File.expand_path('../../lib/minitest/stub_const', __FILE__)
require 'minitest/autorun'
require 'minitest/mock'

module A
  module B
    def self.what
      :old
    end
  end

  module C
    def self.who
      :you
    end
  end
end

describe 'Object' do
  describe '#stub_const' do
    before do
      @mock = MiniTest::Mock.new
      @mock.expect(:what, :new)
    end

    it 'replaces a constant for the duration of a block' do
      A.stub_const(:B, @mock) do
        assert_equal :new, A::B.what
      end
      @mock.verify
    end

    it 'restores the original value after the block' do
      A.stub_const(:B, @mock) { }
      assert_equal :old, A::B.what
    end

    it 'does not raise any warnings' do
      assert_silent { A.stub_const(:B, @mock) { } }
    end

    it 'should stub undefined constants' do
      refute defined?(A::X)
      A.stub_const(:X, @mock) do
        assert_equal :new, A::X.what
      end
      refute defined?(A::X)
      @mock.verify
    end
  end

  describe '#stub_remove_const' do
    it 'removes a constant for the duration of a block' do
      A.stub_remove_const(:B) do
        refute defined?(A::B)
      end
    end

    it 'restores the original value after the block' do
      A.stub_remove_const(:B) { }
      assert_equal :old, A::B.what
    end

    it 'does not raise any warnings' do
      assert_silent { A.stub_remove_const(:B) { } }
    end

    it 'leaves undefined constants undefined' do
      refute defined?(A::X)
      A.stub_remove_const(:X) { }
      refute defined?(A::X)
    end
  end

  describe '#stub_consts' do
    before do
      @mock = MiniTest::Mock.new
      @mock.expect(:what, :new)

      @mock2 = MiniTest::Mock.new
      @mock2.expect(:who, :me)

      @mock3 = MiniTest::Mock.new
      @mock3.expect(:where, :there)
    end

    def run_stub_block
      A.stub_consts(B: @mock, C: @mock2, D: @mock3) do
        assert_equal :new, A::B.what
        assert_equal :me, A::C.who
        assert_equal :there, A::D.where
      end
    end

    it 'replaces a set of constants for the duration of a block' do
      run_stub_block

      @mock.verify
      @mock2.verify
      @mock3.verify
    end

    it 'restores previous values' do
      run_stub_block

      assert_equal :old, A::B.what
      assert_equal :you, A::C.who
    end

    it 'removes constants that were undefined prior to the block' do
      run_stub_block

      refute A.const_defined?(:D)
    end
  end
end
