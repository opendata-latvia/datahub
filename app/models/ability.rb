class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    # === Forums ===
    if user.super_admin?
      can :manage, Forum
    else
      can :read, Forum
    end

    # # === Topics ===
    if user.super_admin?
      can :manage, Topic
    elsif user.persisted?
      can :create, Topic
      can :update, Topic, :user => user
    end
    can :read, Topic

    # === Comments ===
    if user.super_admin?
      can :manage, Comment
    elsif user.persisted?
      can :create, Comment
      can :destroy, Comment do |comment|
        comment.user == user && comment.created_at > (Time.zone.now - 5.minutes)
      end
    end

    # === Accounts ===
    if user.persisted?
      can :manage, Account do |account|
        account == user.account
      end
    end

    # === Projects ===
    if user.persisted?
      can :manage, Project do |project|
        project.account == user.account
      end
    end
    can :read, Project

    # === Datasets ===
    if user.persisted?
      can :manage, Dataset do |dataset|
        dataset.project.account == user.account
      end
    end
    can :read, Dataset

  end
end
