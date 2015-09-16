# minitest-stub-const

[![Build Status](https://travis-ci.org/adammck/minitest-stub-const.svg)](https://travis-ci.org/adammck/minitest-stub-const)

Stub constants for the duration of a block in MiniTest.  
Like RSpec's [stub_const] [rspec], but boring and non-magical.


## Example
Stub a constant for the duration of a block:

```ruby
module Foo
  BAR = :original
end

Foo.stub_const(:BAR, :stubbed) do
  Foo::BAR
end
# => :stubbed

Foo::BAR
# => :original
```

This is especially useful when testing that the expected class methods
are being called on a `Module` or `Class` instance:

```ruby
module SomeLib
  class Thing
    def self.add
      fail NotImplementedError
    end
  end
end

class ThingAdder
  def add_thing
    SomeLib::Thing.add
  end
end

describe ThingAdder do
  describe '#add_thing' do
    it 'should call Thing.add' do
      adder = ThingAdder.new
      mock = Minitest::Mock.new
      mock.expect(:add, nil)

      SomeLib.stub_const(:Thing, mock) do
        adder.add_thing
      end
      assert mock.verify
    end
  end
end
```

## Installation

```sh
gem install minitest-stub-const # duh
```


## License

[minitest-stub-const] [repo] is free software, available under [the MIT license]
[license].




[repo]: https://raw.github.com/adammck/minitest-stub-const
[license]: https://raw.github.com/adammck/minitest-stub-const/master/LICENSE
[rspec]: https://www.relishapp.com/rspec/rspec-mocks/v/2-12/docs/mutating-constants
