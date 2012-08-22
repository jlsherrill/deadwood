# encoding: utf-8

require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rubygems/package_task'
require 'rake/testtask'
require 'rspec/core/rake_task'
require 'rdoc/task'
require './rake/rpmtask'

RPMBUILD_DIR = "#{File.expand_path('~')}/rpmbuild"
RPM_SPEC = "rubygem-deadwood.spec"
RPM_SPEC_IN = "rubygem-deadwood.spec.in"
PKG_VERSION = "0.0.1"

spec = Gem::Specification.new do |s|
  s.name = 'deadwood'
  s.version = PKG_VERSION
  s.summary= 'Ruby client for interacting with a Katello server'
  s.description = 'Ruby client for interacting with a Katello server'
  s.author = 'Chris Alfonso'
  s.email = 'calfonso@redhat.com'
  s.license = 'MIT'
  s.homepage = 'http://aeolusproject.org'

  s.files        = Dir["{lib}/**/*.rb", "COPYING", "*.md", "Rakefile", "rake/rpmtask.rb"]
  s.test_files   = Dir["spec/**/*.*", "examples/deadwood-config.yml"]
  s.require_path = "lib"
  s.add_dependency('nokogiri', '>=0.4.0')
  s.add_dependency('rest-client')
  s.add_dependency('activeresource', '~>3.0.10')
  s.add_dependency('oauth')
  s.add_development_dependency('rspec', '~>1.3.0')
end

Gem::PackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "deadwood #{version}"
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Rake::RpmTask.new(RPM_SPEC, {:suffix => '.in', :pkg_version => PKG_VERSION}) do |rpm|
  rpm.need_tar = true
  rpm.package_files.include("lib/*")
  rpm.topdir = "#{RPMBUILD_DIR}"
end

RSpec::Core::RakeTask.new do |t|
  t.pattern = FileList['spec/**/*.rb']
end
