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
  def stub_const(name, val, &block)
    defined = const_defined?(name)
    orig = const_get(name) if defined
    silence_warnings { const_set(name, val) }
    yield
  ensure
    if defined
      silence_warnings { const_set(name, orig) }
    else
      remove_const(name)
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
