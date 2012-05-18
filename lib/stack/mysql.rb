package :mysql, :provides => :database do
  description 'MySQL Database'

  case INSTALL_PLATFORM
  when 'ubuntu'
    apt %w( mysql-server mysql-client libmysqlclient-dev )
  end

  verify do
    has_executable 'mysqld'
    has_executable 'mysql'
  end

  optional :mysql_conf
end

package :mysql_conf do

  transfer File.join(STACK_CONFIG_PATH,'mysql/my.cnf.erb'), "/etc/mysql/my.cnf", :render => true do
    sudo true
    mode 0644

    pre :install, "sudo mkdir -p /etc/mysql"
    post :install, "/etc/init.d/mysql restart"
  end

end
