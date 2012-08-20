Gem::Specification.new do |s|
  s.name        = "deadwood"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Chris Alfonso"]
  s.email       = ["calfonso@redhat.com"]
  s.homepage    = "https://github.com/calfonso/deadwood"
  s.summary     = "Ruby library to interact with Katello"
  s.description = "Ruby library to interact with Katello"
  s.license = "MIT"

  s.add_dependency "oauth"
  s.add_dependency "activeresource"
  s.add_dependency "rest-client"
  s.add_dependency "nokogiri"

  # If you need to check in files that aren't .rb files, add them here
  s.files        = Dir["{lib}/**/*.rb", "COPYING", "*.md", "Rakefile", "rake/rpmtask.rb"]
  s.test_files   = Dir["spec/**/*.*", "examples/deadwood-config.yml"]
  s.require_path = 'lib'
end
