# == Schema Information
#
# Table name: forums
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)     not null
#  slug        :string(255)     not null
#  description :text            default(""), not null
#  position    :integer(4)      not null
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Forum < ActiveRecord::Base
  
  validates :slug, :position, :presence => true
  validates :title, :presence => true, :uniqueness => {:scope => :slug}
  validates_numericality_of :position, :only_integer => true, :allow_nil => false

  has_many :topics, :dependent => :destroy

  attr_accessible :slug, :title, :position, :description

  default_scope order(:position)
end
