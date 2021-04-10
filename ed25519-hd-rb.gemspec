Gem::Specification.new do |s|
  s.name = "ed25519-hd-rb"
  s.version = "0.0.1"
  s.summary = "HD key derivation for ED25519"
  s.description = "Ruby hd key derivation for ED25519"
  s.authors = ["Kingsley Hendrickse"]
  s.email = "kingsley@axentro.io"
  s.files = Dir.glob("{lib,bin}/**/*")
  s.add_dependency("ed25519", "~> 1.2", ">=1.2.4")
  s.homepage =
    "https://rubygems.org/gems/ed25519-hd-rb"
  s.license = "MIT"
  s.require_path = "lib"

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
