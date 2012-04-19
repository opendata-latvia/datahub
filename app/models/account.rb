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

class Account < ActiveRecord::Base
  belongs_to :user
  has_many :projects, :dependent => :destroy

  attr_accessible :login, :name

  def email
    if user
      user.email
    end
  end

  def to_param
    login
  end

end
