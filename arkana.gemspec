# frozen_string_literal: true

require_relative "lib/arkana/version"

Gem::Specification.new do |spec|
  spec.name = "arkana"
  spec.version = Arkana::VERSION
  spec.authors = ["Roger Oba"]
  spec.email = ["rogerluan.oba@gmail.com"]
  spec.license = 'BSD-2-Clause'
  spec.summary = "Store your keys and secrets away from your source code. Designed for Android and iOS projects."
  spec.homepage = "https://github.com/rogerluan/arkana"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/rogerluan/arkana"
  spec.metadata["changelog_uri"] = "https://github.com/rogerluan/arkana/blob/main/CHANGELOG.md"

  spec.files = Dir['lib/**/*.{rb,erb}'] + Dir['bin/*']
  spec.executables = ["arkana"]
  spec.require_paths = ["lib"]

  spec.add_dependency "colorize", "~> 0.8"
  spec.add_dependency "dotenv", "~> 2.7"
  spec.add_dependency "yaml", "~> 0.2"

  # For more information and examples about making a new gem, check out our guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
