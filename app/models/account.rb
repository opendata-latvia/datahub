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
