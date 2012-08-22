#  Copyright (c) 2012 Chris Alfonso
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

require 'rubygems'
require 'rake'
require 'rake/packagetask'

require 'rbconfig' # used to get system arch

module Rake

  # Create a package based upon a RPM spec.
  # RPM packages, can be produced by this task.
  class RpmTask < PackageTask
    # filename for output RPM spec
    attr_accessor :rpm_spec

    # RPM build dir
    attr_accessor :topdir

    # Include extra_release information in the rpm
    attr_accessor :include_extra_release

    def initialize(rpm_spec, args = {})
      init(rpm_spec,args)
      yield self if block_given?
      define if block_given?
    end

    def init(rpm_spec,args)
      @rpm_spec = rpm_spec

      if args[:suffix]
        rpm_spec_in = @rpm_spec + args[:suffix]
        @include_extra_release = eval `grep -q '^[[:space:]]*Release:[[:space:]]*0' #{rpm_spec_in} && echo true || echo false`

        git_head = `git log -1 --pretty=format:%h`
        extra_release = @include_extra_release ? ("." + Time.now.strftime("%Y%m%d%H%M%S").gsub(/\s/, '') + "git" + "#{git_head}") : ''

        if args[:pkg_version]
          pkg_version = args[:pkg_version]
          `sed -e "s|@VERSION@|#{pkg_version}|;s|^\\(Release:[^%]*\\)|\\1#{extra_release}|" #{rpm_spec_in} > #{@rpm_spec}`
        else
          `sed -e "s|^\\(Release:[^%]*\\)|\\1#{extra_release}|" #{rpm_spec_in} > #{@rpm_spec}`
        end
      end

      # parse this out of the rpmbuild macros,
      # not ideal but better than hardcoding this
      File.open('/etc/rpm/macros.dist', "r") { |f|
        f.read.scan(/%dist\s*\.(.*)\n/)
        @distro = $1
      }

      # Parse rpm name / version out of spec
      # FIXME hacky way to do this for now
      #   (would be nice to implement a full blown rpm spec parser for ruby)
      File.open(rpm_spec, "r") { |f|
        contents = f.read
        # Parse out definitions and crudely expand them
        contents.scan(/%define .*\n/).each do |definition|
          words = definition.strip.split(' ')
          key = words[1]
          value = words[2..-1].to_s
          # Modify the contents with expanded values, unless they contain
          # a shell command (since we're not modifying them)
          contents.gsub!("%{#{key}}", value) unless value.match('%\(')
        end
        @name    = contents.scan(/\nName: .*\n/).first.split.last
        @version = contents.scan(/\nVersion: .*\n/).first.split.last
        @release = contents.scan(/\nRelease: .*\n/).first.split.last
        @release.gsub!("%{?dist}", ".#{@distro}")
        @arch    =  contents.scan(/\nBuildArch: .*\n/) # TODO grab local arch if not defined
        if @arch.nil?
          @arch = Config::CONFIG["target_cpu"] # hoping this will work for all cases,
                                               # can just run the 'arch' cmd if we want
        else
          @arch = @arch.first.split.last
        end
      }
      super(@name, @version)

      @rpmbuild_cmd = 'rpmbuild'
    end

    def define
      super

      directory "#{@topdir}/SOURCES"
      directory "#{@topdir}/SPECS"

      desc "Build the rpms"
      task :rpms, [:include_extra_release] => [rpm_file]

      # FIXME properly determine :package build artifact(s) to copy to sources dir
      file rpm_file, [:include_extra_release] => [:package, "#{@topdir}/SOURCES", "#{@topdir}/SPECS"] do |t,args|
        cp "#{package_dir}/#{@name}-#{@version}.tgz", "#{@topdir}/SOURCES/"
        # FIXME - This seems like a hack, but we don't know the gem's name
	cp "#{package_dir}/#{@name.gsub('rubygem-', '')}-#{@version}.gem", "#{@topdir}/SOURCES/"
        cp @rpm_spec, "#{@topdir}/SPECS"
        sh "#{@rpmbuild_cmd} " +
           "--define '_topdir #{@topdir}' " +
           "-ba #{@rpm_spec}"
      end
    end

    def rpm_file
      # FIXME support all a spec's subpackages as well
      "#{@topdir}/RPMS/#{@arch}/#{@name}-#{@version}-#{@release}.#{@arch}.rpm"
    end
  end
end
