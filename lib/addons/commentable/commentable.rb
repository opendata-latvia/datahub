module Addons
  module Commentable
    def is_commentable
      has_many :comments, as: :commentable, dependent: :destroy, class_name: "Comment"
      include InstanceMethods
    end
    
    module InstanceMethods
      def commentable?
        true
      end
      
      def any_comment?
        comments.count > 0
      end
    end
  end
end
ActiveRecord::Base.extend Addons::Commentable