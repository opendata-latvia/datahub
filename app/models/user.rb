class User < ActiveRecord::Base
  has_one :account, :dependent => :destroy

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :timeoutable

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
