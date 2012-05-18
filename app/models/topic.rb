# == Schema Information
#
# Table name: topics
#
#  id               :integer(4)      not null, primary key
#  forum_id         :integer(4)      not null
#  user_id          :integer(4)      not null
#  title            :string(255)     not null
#  slug             :string(255)     not null
#  description      :text            default(""), not null
#  commentable      :boolean(1)      default(FALSE)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

class Topic < ActiveRecord::Base
  is_commentable
  
  validates :slug, :description, :user_id, :presence => true
  validates :title, :presence => true, :uniqueness => {:scope => [:slug, :forum_id]}
  
  belongs_to :forum
  belongs_to :user

  attr_accessible :commentable, :description, :slug, :title
  attr_accessible :commentable, :description, :slug, :title, :user_id, :forum_id, :as => :admin

  default_scope order("updated_at desc")

  def self.recent(count = 5)
    order("updated_at DESC").limit(count).includes(:forum, :user)
  end

end
