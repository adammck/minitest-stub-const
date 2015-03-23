require 'minitest/mock'

require File.expand_path('../../lib/minitest/stub_const', __FILE__)

module A
  module B
    def self.what
      :old
    end
  end
end

describe 'Object' do
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
end
