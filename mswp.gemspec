require_relative 'lib/mswp/version'

Gem::Specification.new do |spec|
  spec.name          = "mswp"
  spec.version       = MSwp::VERSION
  spec.authors       = ["ysk_univ"]
  spec.email         = ["ysk.univ.1007@gmail.com"]

  spec.summary       = %q{mswp}
  spec.description   = %q{mswp}
  spec.homepage      = "https://github.com/yskuniv/mswp"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yskuniv/mswp"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "curses", "~> 1.4"
  spec.add_runtime_dependency "thor", "~> 1.2"

  spec.add_development_dependency "rubocop", "~> 1.33"
end
