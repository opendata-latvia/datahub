require 'spec_helper'

describe TopicsController do

  before(:each) do
    @forum = create(:forum)
    @topic = create(:topic, :forum => @forum)
  end
  
  def valid_attributes
    attributes_for(:topic).except(:id, :created_at, :updated_at, :forum, :user)
  end
  
  describe "As anonymous" do

    it "should show topic" do
      get :show, :forum_id => @forum.slug, :id => @topic.slug
      assigns(:topic).title.should eq(@topic.title)
      response.should be_success
    end

    it "should not permit new topic" do
      get :new, :forum_id => @forum.slug
      response.should redirect_to new_user_session_path
    end

    it "should not permit create topic" do
      post :create, :forum_id => @forum.slug, :topic => valid_attributes
      response.should redirect_to new_user_session_path
    end

    it "should not permit edit topic" do
      get :edit, :forum_id => @forum.slug, :id => @topic.slug
      response.should redirect_to new_user_session_path
    end

    it "should not permit update topic" do
      put :update, :forum_id => @forum.slug, :id => @topic.slug, :topic => valid_attributes
      response.should redirect_to new_user_session_path
    end

    it "should not permit destroy topic" do
      delete :destroy, :forum_id => @forum.slug, :id => @topic.slug
      response.should redirect_to new_user_session_path
    end
    
  end
  
  describe "As user" do
    
    before(:each) do
      @user = create(:user)
      sign_in @user
      @my_topic = create(:topic, :forum => @forum, :user => @user)
    end
    
    describe "GET show" do
      it "should show topic" do
        get :show, :forum_id => @forum.slug, :id => @my_topic.slug
        assigns(:topic).title.should eq(@my_topic.title)
        response.should be_success
      end
    end
    
    describe "GET new" do
      it "should permit new topic" do
        get :new, :forum_id => @forum.slug
        response.should be_success
      end
    end
    
    describe "POST create" do
      it "should create forum" do
        expect {
          post :create, :forum_id => @forum.slug, :topic => valid_attributes
        }.to change(Topic, :count).by(1)
      end
      
      it "assigns a newly created forum as @forum" do
        post :create, :forum_id => @forum.slug, :topic => valid_attributes
        assigns(:forum).should be_a(Forum)
        assigns(:forum).should be_persisted
      end

      it "redirects to the forum" do
        params = valid_attributes
        post :create, :forum_id => @forum.slug, :topic => params
        forum = assigns(:forum)
        response.should redirect_to(forum_topic_path(forum.slug, params[:slug]))
      end
      
      it "re-renders the 'new' template" do
        post :create, :forum_id => @forum.slug, :topic => {}
        response.should render_template("new")
      end
    end
    
    describe "GET edit" do
      
      it "should permit edit topic" do
        get :edit, :forum_id => @forum.slug, :id => @my_topic.slug
        response.should be_success
      end
    end

    describe "PUT udpate" do
      
      it "should not permit update topic" do
        put :update, :forum_id => @forum.slug, :id => @topic.slug, :topic => valid_attributes
        response.should redirect_to root_path
      end
      
      it "should update topic" do
        Topic.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :forum_id => @forum.slug, :id => @my_topic.slug, :topic => {'these' => 'params'}
      end
      
      it "redirects to the topic" do
        put :update, :forum_id => @forum.slug, :id => @my_topic.slug, :topic => valid_attributes
        response.should redirect_to(forum_topic_path(@forum.slug, assigns(:topic).slug))
      end
      
      it "re-renders the 'edit' template" do
        put :update, :forum_id => @forum.slug, :id => @my_topic.slug, :topic => {:title => nil}
        response.should render_template("edit")
      end
    end

    it "should not permit destroy other topic" do
      delete :destroy, :forum_id => @forum.slug, :id => @my_topic.slug
      response.should redirect_to root_path
    end
    
  end
  
  describe "As admin" do
    
    before(:each) do
      sign_in create(:admin)
    end
    
    it "should permit new topic" do
      get :new, :forum_id => @forum.slug
      response.should be_success
    end
    
    it "should create forum" do
      expect {
        post :create, :forum_id => @forum.slug, :topic => valid_attributes
      }.to change(Topic, :count).by(1)
    end
    
    it "should permit edit topic" do
      get :edit, :forum_id => @forum.slug, :id => @topic.slug
      response.should be_success
    end
    
    it "should update topic" do
      Topic.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
      put :update, :forum_id => @forum.slug, :id => @topic.slug, :topic => {'these' => 'params'}
    end
    
    describe "DELETE destroy" do
      
      it "destroys the requested topic" do
        expect {
          delete :destroy, :forum_id => @forum.slug, :id => @topic.slug
        }.to change(Topic, :count).by(-1)
      end
      
      it "redirects to the topic lsit" do
        delete :destroy, :forum_id => @forum.slug, :id => @topic.slug
        response.should redirect_to(forum_path(@forum.slug))
      end
    end
    
  end

end
