# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

default_run_options[:pty] = true  # Must be set for the password prompt from git to work

if defined?(INSTALL_SITE)
  case INSTALL_SITE
  when 'local'
    role :app, 'data.local'
    set :user, 'root'
  when 'opendata'
    role :app, 'data.opendata.lv'
    set :user, 'root'
  end
else

set :stages, %w( production )
set :default_stage, "production"
require 'capistrano/ext/multistage'
require "bundler/capistrano"
# set :whenever_command, "bundle exec whenever"
# require "whenever/capistrano"

set :user, "rails"
set :application, "datahub"
set :keep_releases, 5
after "deploy", "deploy:cleanup"
set :use_sudo, false

set :scm , :git
set :repository, "git://github.com/opendata-latvia/datahub.git"
set :repository_cache, "git_cache"
set :branch, "master"
set :deploy_via, :remote_cache

set(:deploy_to) { "/home/rails/#{application}/production" }
set(:rails_env) { "production" }

set :default_environment, {
  'PATH' => '/usr/local/bin:/usr/bin:/bin',
  'GIT_SSL_NO_VERIFY' => '1'
}

namespace :deploy do

  after "deploy:setup",       "deploy:setup_config"
  after "deploy:update_code", "deploy:copy_config"

end

end
