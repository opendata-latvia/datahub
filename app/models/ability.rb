class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    # === Forums ===
    can :manage, Forum if user.super_admin?
    can :read, Forum

    # # === Topics ===
    can :manage, Topic if user.super_admin?
    can :create, Topic if user.persisted?
    can :update, Topic, :user_id => user.id
    can :read, Topic

    # === Comments ===
    can :manage, Comment if user.super_admin?
    can :create, Comment if user.persisted?
    can :destroy, Comment do |comment|
      comment.user_id == user.id && comment.created_at > (Time.zone.now - 5.minutes)
    end

  end
end
