require "capistrano"
require "sprinkle"

::STACK_CONFIG_PATH = File.expand_path('../stack', __FILE__)
::STACK_LIB_PATH = File.expand_path('../../lib', __FILE__)
$:<< STACK_LIB_PATH

# process command line parameters
params = ARGV.inject({}){|h,v| param, value = v.split('='); h[param]=value if value; h}

::INSTALL_SITE = params['SITE'] || 'local'
puts "==> Installing site: #{INSTALL_SITE}"

# site specific configuration parameters
case INSTALL_SITE
when 'local', 'opendata'
  ::INSTALL_CONFIG = {
    :rails_apps => {
      'datahub' => %w(production)
    },
    # specify ssh public keys which will be included in ~rails/.ssh/authorized_keys
    :rails_user_authorized_keys => %w()
  }
end
# common configuration parameters
# ::INSTALL_CONFIG.merge!()
# specify platform - ubuntu, redhat or centos
::INSTALL_PLATFORM = params['PLATFORM'] || 'ubuntu'
puts "==> Install platform: #{INSTALL_PLATFORM}"

# Require the stack base
Dir["#{STACK_LIB_PATH}/stack/*.rb"].each do |lib|
  require "stack/#{File.basename(lib)[0..-4]}"
end

# Install with
# sprinkle -c -s config/install.rb SITE=opendata
policy :stack, :roles => :app do
  # requires :sysadmin
  # requires :apache
  # requires :ruby
  # requires :rubygems
  # requires :rake
  # requires :bundler
  # requires :mysql
  # requires :redis
  # requires :git
  # requires :ufw
  # requires :passenger
  # requires :rails_apps
end

deployment do
  # mechanism for deployment
  delivery :capistrano do
    begin
      recipes 'Capfile'
    rescue LoadError
      recipes 'deploy'
    end
    # Uncomment next line to see server output after command execution
    logger.level = ::Capistrano::Logger::INFO
  end

  # source based package installer defaults
  source do
    prefix   '/usr/local'
    archives '/usr/local/src'
    builds   '/usr/local/src'
  end

  binary do
    prefix   '/usr/local'
    archives '/usr/local/src'
  end
end

# Depend on a specific version of sprinkle and erubis
begin
  gem 'sprinkle', "~> 0.4.2"
  gem 'erubis', "~> 2.7.0"
rescue Gem::LoadError
  puts "sprinkle 0.4.2 and erubis 2.7.0 required.\n Run: `[sudo] gem install sprinkle erubis`"
  exit
end
