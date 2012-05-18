require "stack/ruby"

package :apache do
  description 'Apache2 web server.'
  case INSTALL_PLATFORM
  when 'ubuntu'
    apt 'apache2 apache2.2-common apache2-mpm-prefork apache2-utils libexpat1 ssl-cert' do
      %w(rewrite expires proxy proxy_http ssl).each do |module_name|
        post :install, "a2enmod #{module_name}"
      end
      post :install, 'a2dissite default'
    end

    verify do
      has_executable '/usr/sbin/apache2'
    end

  end

  requires :build_essential
  optional :apache_sites

end

package :apache_dev do
  description 'A dependency required by some packages.'
  case INSTALL_PLATFORM
  when 'ubuntu'
    apt 'apache2-prefork-dev'
  end
end

package :apache_sites do
  case INSTALL_PLATFORM
  when 'ubuntu'
    APACHE_SITES_PATH = "/etc/apache2/sites-available"
  end

  noop do
    pre :install, "mkdir -p #{APACHE_SITES_PATH}"
  end

  Array(INSTALL_CONFIG[:apache_sites]).each do |site|
    puts "==> Installing Apache site: #{site}"
    site_file = File.join(STACK_CONFIG_PATH, "apache/sites/#{site}.erb")
    raise "Missing file #{site_file}" unless File.file?(site_file)

    transfer site_file, "#{APACHE_SITES_PATH}/#{site}", :render => true do
      sudo true
      mode 0644

      case INSTALL_PLATFORM
      when 'ubuntu'
        post :install, "a2ensite #{site}"
        post :install, '/etc/init.d/apache2 reload'
      end
    end

  end

end

package :passenger do
  description 'Phusion Passenger (mod_passenger)'
  version '3.0.12'
  PASSENGER_VERSION = version

  requires :apache, :apache_dev, :ruby
  requires :passenger_gem, :passenger_conf
end

package :passenger_gem do
  gem 'passenger', :version => PASSENGER_VERSION do
    post :install, 'echo -en "\n\n\n\n" | sudo passenger-install-apache2-module'
  end

  verify do
    has_file "#{RUBY19_PATH}/lib/ruby/gems/1.9.1/gems/passenger-#{PASSENGER_VERSION}/ext/apache2/mod_passenger.so"
  end
end

package :passenger_conf do
  apache_conf_file = case INSTALL_PLATFORM
    when 'ubuntu'
      '/etc/apache2/conf.d/passenger.conf'
    end

  # Create the passenger conf file
  transfer File.join(STACK_CONFIG_PATH,'apache/passenger.conf.erb'), "#{apache_conf_file}", :render => true do
    sudo true
    mode 0644
    # Do not restart apache as rails_apps package will update site specific configuration files and will restart at the end
    # post :install, "/etc/init.d/apache2 restart"
  end

end
