class Object

  #
  # Replace the +value+ of constant +name+ for the duration of a +block+. This
  # is useful when testing that the expected class methods are being called on
  # a Module or Class instance.
  #
  # Example:
  #
  #   m = MiniTest::Mock.new
  #   m.expect(:register, nil, [:whatever])
  #
  #   MyLib.stub_const(:Thing, m) do
  #     @subject.add_thing(:whatever)
  #   end
  #
  #   m.verify
  #
  def stub_const(name, val, &block)
    orig = const_get(name)

    silence_warnings do
      const_set(name, val)
    end

    yield
  ensure
    silence_warnings do
      const_set(name, orig)
    end
  end

  # Remove the constant +name+ for the duration of a block. This is
  # useful when testing code that checks whether a constant is defined
  # or not.
  #
  # Example:
  #
  #   Object.stub_remove_const(:File) do
  #     "Look ma, no File!" unless defined(File)
  #   end
  #   # => "Look ma, no File!"
  def stub_remove_const(name)
    orig = const_get(name)
    remove_const(name)
    yield
  ensure
    const_set(name, orig)
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
