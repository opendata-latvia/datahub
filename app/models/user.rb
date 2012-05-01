# == Schema Information
#
# Table name: users
#
#  id                     :integer(4)      not null, primary key
#  login                  :string(40)      not null
#  name                   :string(255)     default("")
#  super_admin            :boolean(1)
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer(4)      default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  failed_attempts        :integer(4)      default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#

class User < ActiveRecord::Base
  has_one :account, :dependent => :destroy
  has_many :user_tokens, :dependent => :destroy

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :timeoutable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :login, :name

  validates_presence_of :login
  validates_uniqueness_of :login

  validates_length_of :login, :within => 4..40
  VALID_URL_COMPONENT_REGEXP = /\A[a-z][a-z0-9\-]+[a-z0-9]\Z/
  validates_format_of :login, :with => VALID_URL_COMPONENT_REGEXP

  after_create :create_user_account
  after_update :update_user_account

  def display_name
    "#{login}#{ name.present? ? " (#{name})" : nil}"
  end

  def apply_omniauth(omniauth)
    data = omniauth["info"]
    if data
      self.name = data["name"] if name.blank?
      self.login = data["nickname"] if login.blank?
      self.email = data["email"] if email.blank?
    end

    user_tokens.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def password_required?
    (user_tokens.empty? && new_record?) || (!password.blank? && super)
  end

  def has_provider?(provider)
    user_tokens.where(:provider => provider).count > 0
  end

  private

  def create_user_account
    create_account(:login => login, :name => name)
  end

  def update_user_account
    if login_changed? || name_changed?
      account.update_attributes(:login => login, :name => name)
    end
  end

end
