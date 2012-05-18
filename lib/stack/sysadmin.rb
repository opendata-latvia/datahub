package :sysadmin do
  requires :curl, :vim, :dnsutils, :strace, :lsof, :dupx
  # :newrelic_sysmond
end

# package :newrelic_sysmond do
#   requires :curl
# 
#   apt 'newrelic-sysmond' do
#     pre :install, 'curl -L http://download.newrelic.com/debian/newrelic.list -o /etc/apt/sources.list.d/newrelic.list'
#     pre :install, 'apt-get update'
#   end
# 
#   verify do
#     has_executable 'nrsysmond'
#     has_file '/etc/init.d/newrelic-sysmond'
#   end
# end

package :dnsutils do
  apt 'dnsutils'
  verify { has_executable 'nslookup' }
end

package :strace do
  apt 'strace'
  verify { has_executable 'strace' }
end

package :lsof do
  apt 'lsof'
  verify { has_executable 'lsof' }
end

package :gdb do
  apt 'gdb'
  verify { has_executable 'gdb' }
end

package :dupx do
  description 'Dupx'
  version '0.1'

  source "http://www.isi.edu/~yuri/dupx/dupx-#{version}.tar.gz"

  verify { has_executable 'dupx' }

  requires :gdb
end

package :monit do
  apt 'monit'
  verify do
    has_executable 'monit'
    has_file '/etc/init.d/monit'
  end

  optional :monit_conf
end

package :monit_conf do
  transfer File.join(STACK_CONFIG_PATH,'monit/monit.erb'), "/etc/default/monit", :render => true do
    sudo true
    mode 0644
  end

  rails_apps = INSTALL_CONFIG[:rails_apps]
  transfer File.join(STACK_CONFIG_PATH,'monit/monitrc.erb'), "/etc/monit/monitrc", :render => true,
      :locals => {:rails_apps => rails_apps} do
    sudo true
    mode 0600
    pre :install, "sudo mkdir -p /etc/monit"
    post :install, "/etc/init.d/monit restart"
  end
end
