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
