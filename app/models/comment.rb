# == Schema Information
#
# Table name: comments
#
#  id               :integer(4)      not null, primary key
#  commentable_type :string(255)
#  commentable_id   :integer(4)
#  user_id          :integer(4)
#  content          :text
#  ancestry         :string(255)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic=>true
  belongs_to :user
  has_ancestry
  
  attr_accessible :commentable_id, :commentable_type, :parent_id, :content
  
  validates :commentable_type, presence: true
  validates :commentable_id, presence: true
  validates :content, :presence => true
  validates :user_id, :presence => true
  
  def unread?(time)
    time < created_at
  end
  
  def self.recent(commentable = nil, count = 5)
    if commentable.class == Fixnum
      count = commentable
      commentable = nil
    end
    if commentable
      if commentable.respond_to?(:each)
        conditions = where(:commentable_type => commentable.map{|c| c.class.to_s}.uniq, :commentable_id => commentable.map{|c| c.id}.uniq)
      else
        conditions = where(:commentable_type => commentable.class, :commentable_id => commentable.id)
      end
    else
      conditions = order
    end
    conditions.order("created_at DESC").limit(count).includes(:commentable).includes(:user)
  end
end
