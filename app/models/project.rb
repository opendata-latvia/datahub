# == Schema Information
#
# Table name: projects
#
#  id          :integer(4)      not null, primary key
#  account_id  :integer(4)      not null
#  shortname   :string(40)      not null
#  name        :string(255)     not null
#  description :text
#  homepage    :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Project < ActiveRecord::Base
  belongs_to :account
  has_many :datasets, :dependent => :destroy

  validates_presence_of :name, :shortname
  validates_length_of :shortname, :within => 4..40
  validates_format_of :shortname, :with => User::VALID_URL_COMPONENT_REGEXP
  validates_uniqueness_of :shortname, :scope => :account_id

  attr_accessible :shortname, :name, :description, :homepage

  def self.recent(count = 5)
    order("updated_at DESC").limit(count).includes(:account => :user).includes(:datasets)
  end

  extend Searchable
  self.search_per_page = 10
  self.search_joins = [:account]
  self.search_attributes = %w(projects.name projects.description accounts.login accounts.name)

end
