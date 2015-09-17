Gem::Specification.new do |s|
  s.name        = "minitest-stub-const"
  s.version     = 0.5

  s.authors     = ["Adam Mckaig"]
  s.email       = ["adam.mckaig@gmail.com"]
  s.homepage    = "https://github.com/adammck/minitest-stub-const"
  s.summary     = "Stub constants for the duration of a block in MiniTest"
  s.licenses    = ["MIT"]

  s.files         = Dir.glob("lib/**/*") + ["LICENSE", "README.md"]
  s.test_files    = Dir.glob("test/**/*")
  s.require_paths = ["lib"]
end
