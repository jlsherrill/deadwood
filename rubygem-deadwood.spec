%if 0%{?fedora} > 16
%global rubyabi 1.9.1
%global gem_name deadwood
%global gemname %{gem_name}
%global geminstdir %{gem_instdir}
%global gemdir %{gem_dir}
%else
%global rubyabi 1.8
%global gemdir %(ruby -rubygems -e 'puts Gem::dir' 2>/dev/null)
%global gemname deadwood
%global geminstdir %{gemdir}/gems/%{gemname}-%{version}
%endif


Summary: Ruby Client for interacting with a Katello server
Name: rubygem-deadwood
Version: 0.0.1
Release: 0.20120816104647git3722de0%{?dist}
Group: Development/Languages
License: ASL 2.0
URL: http://aeolusproject.org

Source0: %{gemname}-%{version}.gem

Requires: ruby(abi) = %{rubyabi}
Requires: rubygems
Requires: rubygem(nokogiri) >= 1.4.0
Requires: rubygem(rest-client)
Requires: rubygem(oauth) >= 0.4.6

BuildRequires: ruby
BuildRequires: rubygems

%if 0%{?fedora} > 16
BuildRequires: rubygems-devel
%endif

BuildArch: noarch
Provides: rubygem(%{gemname}) = %{version}

%description
Ruby Client for Katello

%prep
%setup -q -c -T
mkdir -p ./%{gemdir}
gem install --local --install-dir ./%{gemdir} --force --rdoc %{SOURCE0}

%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}%{gemdir}
cp -a .%{gemdir}/* %{buildroot}%{gemdir}/

rm -rf %{buildroot}%{gemdir}/gems/%{gemname}-%{version}/.yardoc

%files
%doc %{geminstdir}/COPYING
%doc %{gemdir}/doc/%{gemname}-%{version}
%dir %{geminstdir}
%{geminstdir}/Rakefile
%{geminstdir}/lib
%{gemdir}/cache/%{gemname}-%{version}.gem
%{gemdir}/specifications/%{gemname}-%{version}.gemspec

%changelog
* Fri Jul 27 2012  <calfonso@redhat.com> - 0.0.1-1
- Initial package
