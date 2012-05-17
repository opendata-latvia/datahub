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
    end
  end
end
ActiveRecord::Base.extend Addons::Commentable