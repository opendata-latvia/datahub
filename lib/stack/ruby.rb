package :ruby do
  description 'Ruby 1.9'
  version '1.9.3'
  patchlevel '194'
  RUBY19_PATH = "/usr/local"
  source "http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-#{version}-p#{patchlevel}.tar.gz"

  verify do
    has_executable_with_version "#{RUBY19_PATH}/bin/ruby", "#{version}p#{patchlevel}"
  end

  requires :build_essential, :ruby_dependencies
end

package :ruby_dependencies do
  description 'Ruby 1.9 Build Dependencies'
  apt %w( openssl libreadline6 libreadline6-dev curl libcurl4-openssl-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf ncurses-dev bison )
end

package :rubygems do
  description 'Ruby rubygems'
  rubygems_version = INSTALL_CONFIG[:rubygems_version] || '1.8.24'

  noop do
    pre :install, "gem install rubygems-update -v #{rubygems_version}"
    pre :install, "update_rubygems"
  end

  verify do
    has_executable_with_version "#{RUBY19_PATH}/bin/gem", rubygems_version
  end

  requires :ruby
end

package :rake do
  description 'Ruby rake'
  rake_version = INSTALL_CONFIG[:rake_version] || '0.9.2.2'

  noop do
    pre :install, "gem install rake -v #{rake_version}"
  end

  verify do
    has_executable_with_version "#{RUBY19_PATH}/bin/rake", rake_version, '--version'
  end

  requires :rubygems
end
