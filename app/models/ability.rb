class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    
    if user.super_admin?
      can :manage, :all
    end
    
    can :manage, Topic, :user_id => user.id
    can :read, Topic  
  
    can :manage, Comment, :user_id => user.id
    
  end
end
