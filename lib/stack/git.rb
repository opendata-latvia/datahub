package :git do
  description 'Git Distributed Version Control'
  case INSTALL_PLATFORM
  when 'ubuntu'
    apt 'git-core'
  end
end
