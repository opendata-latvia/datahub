REDIS_PORT = '6379'

package :redis do
  description 'Redis'
  version '2.4.13'

  source "http://redis.googlecode.com/files/redis-#{version}.tar.gz" do
    custom_install "sudo make && sudo make install"

    post :install, "sudo cp utils/redis_init_script /etc/init.d/redis"
    post :install, "sudo chmod +x /etc/init.d/redis"

    post :install, "sudo /usr/sbin/update-rc.d -f redis defaults"
    post :install, "sudo /etc/init.d/redis start"
  end

  verify do
    has_executable_with_version 'redis-server', version
    has_file "/etc/init.d/redis"
  end

  requires :build_essential, :redis_conf
end

package :redis_conf do

  transfer File.join(STACK_CONFIG_PATH,'redis/redis.conf.erb'), "/etc/redis/#{REDIS_PORT}.conf", :render => true do
    sudo true
    mode 0644

    pre :install, "sudo mkdir -p /etc/redis"
  end

end
