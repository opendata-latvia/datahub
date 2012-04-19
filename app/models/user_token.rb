# == Schema Information
#
# Table name: user_tokens
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  provider   :string(255)
#  uid        :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class UserToken < ActiveRecord::Base
  attr_accessible :provider, :uid, :user_id
  
  belongs_to :user
  validates :provider, :presence => true
  validates :uid, :presence => true
  
  def provider_name
    UserToken.provider_name(provider)
  end
  
  def self.provider_name(name)
    if name.to_sym == :draugiem
      "Draugiem.lv"
    elsif name.to_sym == :google_oauth2
      "Google"
    else
      name.to_s.titleize
    end
  end
end
