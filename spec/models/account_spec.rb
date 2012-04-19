# == Schema Information
#
# Table name: accounts
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  login      :string(40)      not null
#  name       :string(255)     default("")
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Account do
end
