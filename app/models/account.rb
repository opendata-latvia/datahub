class Account < ActiveRecord::Base
  belongs_to :user

  attr_accessible :login, :name

  def email
    if user
      user.email
    end
  end

end
