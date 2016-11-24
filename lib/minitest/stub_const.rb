class Object
  # Replace the +value+ of constant +name+ for the duration of a
  # +block+. This is especially useful when testing that the expected
  # class methods are being called on a Module or Class instance.
  #
  # Example:
  #
  #   module Foo
  #     BAR = :original
  #   end
  #
  #   Foo.stub_const(:BAR, :stubbed) do
  #     Foo::BAR
  #   end
  #   # => :stubbed
  #
  #   Foo::BAR
  #   # => :original
  def stub_const(name, val = nil, &block)
    stub_consts(name => val, &block)
  end

  # Same as stub_const except it supports a Hash of +name+ to +value+ pairs
  # of the constants that will be stubbed for the duration of the +block+.
  #
  # Example:
  #
  #   module Foo
  #     BAR = :original1
  #     BAZ = :original2
  #   end
  #
  #   Foo.stub_consts(BAR: :stubble, BAZ: :stubby) do
  #     [Foo::BAR, Foo::BAZ]
  #   end
  #   # => [:stubble, :stubby]
  #
  #   [Foo::BAR, Foo::BAZ]
  #   # => [:original1, :original2]
  def stub_consts(consts, &block)
    original_values = {}
    consts.each_pair do |name, val|
      if const_defined?(name)
        original_value = const_get(name)
        original_values[name] = original_value
      end
      silence_warnings { const_set(name, val) }
    end

    yield

  ensure
    consts.keys.each do |name|
      if original_values.key?(name)
        silence_warnings { const_set(name, original_values[name]) }
      else
        remove_const(name)
      end
    end
  end

  # Remove the constant +name+ for the duration of a block. This is
  # useful when testing code that checks whether a constant is defined
  # or not. Simply yields to the passed block if the constant is not
  # currently defined.
  #
  # Example:
  #
  #   Object.stub_remove_const(:File) do
  #     "Look ma, no File!" unless defined?(File)
  #   end
  #   # => "Look ma, no File!"
  def stub_remove_const(name)
    if const_defined?(name)
      begin
        orig = const_get(name)
        remove_const(name)
        yield
      ensure
        const_set(name, orig)
      end
    else
      yield
    end
  end

  # Add a minimal implementation of ActiveSupport's silence_warnings if it
  # hasn't already been defined, to call a block with warnings disabled.
  unless respond_to?(:silence_warnings)
    def silence_warnings
      orig = $VERBOSE
      $VERBOSE = nil
      yield
    ensure
      $VERBOSE = orig
    end
  end
end
