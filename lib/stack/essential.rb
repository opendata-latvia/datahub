package :build_essential do
  description 'Build tools'
  case INSTALL_PLATFORM
  when 'ubuntu'
    apt 'build-essential' do
      pre :install, 'apt-get update'
    end
  end
end

package :curl do
  description 'curl'
  
  apt 'curl'

  verify do
    has_executable 'curl'
  end
end

package :vim do
  description 'vim'

  apt 'vim'

  verify do
    has_executable 'vim'
  end
end
