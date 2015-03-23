# minitest-stub-const

[![Build Status](https://travis-ci.org/adammck/minitest-stub-const.svg)](https://travis-ci.org/adammck/minitest-stub-const)

Stub constants for the duration of a block in MiniTest.  
Like RSpec's [stub_const] [rspec], but boring and non-magical.


## Example

```ruby
it "calls a Thing.add when add_thing is called" do
  m = MiniTest::Mock.new
  m.expect(:add, nil)
  
  MyLib.stub_const(:Thing, m) do
    @subject.add_thing
  end

  m.verify
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
