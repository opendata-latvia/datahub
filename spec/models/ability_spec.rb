require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  before(:all) do
    @anonymous_ability = Ability.new(nil)
  end

  before(:each) do
    @user = create(:user)
    @ability = nil
  end

  def ability
    @ability ||= Ability.new(@user)
  end

  describe "forums" do
    it "can manage forum when super admin" do
      @user.super_admin = true
      ability.can?(:manage, Forum).should be_true
    end

    it "cannot manage forum when normal user" do
      ability.can?(:manage, Forum).should be_false
    end

    it "can read forum when normal user" do
      ability.can?(:read, create(:forum)).should be_true
    end
  end

  describe "topics" do
    it "can manage topic when super admin" do
      @user.super_admin = true
      ability.can?(:manage, Topic).should be_true
    end

    it "can create topic when normal user" do
      ability.can?(:create, Topic).should be_true
    end

    it "cannot create topic when anonymous user" do
      @anonymous_ability.can?(:create, Topic).should be_false
    end

    it "can update topic when creator" do
      ability.can?(:update, create(:topic, :user_id => @user.id)).should be_true
    end
    
    it "cannot update topic when other user" do
      ability.can?(:update, create(:topic)).should be_false
    end

    it "cannot destroy topic when creator" do
      ability.can?(:destroy, create(:topic, :user_id => @user.id)).should be_false
    end

    it "can read topic when other user" do
      ability.can?(:read, create(:topic)).should be_true
    end

    it "can read topic when anonymous user" do
      ability.can?(:read, create(:topic)).should be_true
    end
  end

  describe "comments" do
    it "can manage comment when super admin" do
      @user.super_admin = true
      ability.can?(:manage, Comment).should be_true
    end

    it "can create comment when normal user" do
      ability.can?(:create, Comment).should be_true
    end

    it "cannot create comment when anonymous user" do
      @anonymous_ability.can?(:create, Comment).should be_false
    end

    it "can destroy comment when creator" do
      ability.can?(:destroy, create(:comment, :user_id => @user.id)).should be_true
    end
    
    it "cannot destroy comment after 5 minutes when creator" do
      comment = create(:comment, :user_id => @user.id)
      Timecop.freeze(Time.now + 4.minutes) do
        ability.can?(:destroy, comment).should be_true
      end
      Timecop.freeze(Time.now + 6.minutes) do
        ability.can?(:destroy, comment).should be_false
      end
    end

    it "cannot destroy topic when other user" do
      ability.can?(:destroy, create(:comment)).should be_false
    end

  end


end