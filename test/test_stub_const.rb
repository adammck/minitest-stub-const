require File.expand_path("../../lib/minitest/stub_const", __FILE__)
require "minitest/mock"

module A
  module B
    def self.what
      :old
    end
  end
end

describe "Object" do
  before do
    @old_stderr = $stderr
    $stderr = StringIO.new
    @mock = MiniTest::Mock.new
    @mock.expect(:what, :new)
  end

  after do
    $stderr = @old_stderr
  end

  it "replaces a constant for the duration of a block" do
    A.stub_const(:B, @mock) do
      assert_equal :new, A::B.what
    end
  end

  it "restores the original value after the block" do
    A.stub_const(:B, @mock) { }
    assert_equal :old, A::B.what
  end

  it "doesn't raise warnings" do
    A.stub_const(:B, @mock) { }
    assert_empty $stderr.string
  end
end
