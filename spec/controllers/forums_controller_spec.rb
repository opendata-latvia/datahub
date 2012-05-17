require 'spec_helper'

describe ForumsController do

  before(:each) do
    @forum = create(:forum)
  end
  
  def valid_attributes
    attributes_for(:forum).except(:id, :created_at, :updated_at)
  end
  
  %w(anonymous user).each do |user|
    describe "As #{user}" do
      
      before(:each) do
        sign_in create(:user) if user != "anonymous"
      end
      
      it "should assign forum" do
        get :index
        assigns(:forums).size.should eq(1)
        assigns(:forums).first.title.should eq(@forum.title)
        response.should be_success
      end

      it "should show forum" do
        get :show, :id => @forum.slug
        assigns(:forums).size.should eq(1)
        assigns(:forum).title.should eq(@forum.title)
        response.should be_success
      end

      it "should not permit new forum" do
        get :new
        response.should redirect_to root_url
      end

      it "should not permit create forum" do
        post :create, :forum => build(:forum)
        response.should redirect_to root_url
      end

      it "should not permit edit forum" do
        get :edit, :id => @forum.slug
        response.should redirect_to root_url
      end

      it "should not permit update forum" do
        put :update, :id => @forum.slug, :forum => build(:forum)
        response.should redirect_to root_url
      end

      it "should not permit destroy forum" do
        delete :destroy, :id => @forum.slug
        response.should redirect_to root_url
      end
      
    end
    
  end

  describe "As Admin" do
    
    before :each do
      sign_in create(:admin)
    end
    
    describe "GET index" do
      it "should assign forum" do
        get :index
        assigns(:forums).size.should eq(1)
        assigns(:forums).first.title.should eq(@forum.title)
        response.should be_success
      end
    end    
    
    describe "GET show" do
      it "should show forum" do
        get :show, :id => @forum.slug
        assigns(:forums).size.should eq(1)
        assigns(:forum).title.should eq(@forum.title)
        response.should be_success
      end
    end
    
    describe "GET new" do
      it "should render new forum" do
        get :new
        assigns(:forum).should be_a_new(Forum)
      end
    end
    
    describe "POST create" do
      before(:each) do
        @forum = build(:forum)
      end
      
      it "should create forum" do
        expect {
          post :create, :forum => valid_attributes
        }.to change(Forum, :count).by(1)
      end
      
      it "assigns a newly created forum as @forum" do
        post :create, :forum => valid_attributes
        assigns(:forum).should be_a(Forum)
        assigns(:forum).should be_persisted
      end

      it "redirects to the forum" do
        post :create, :forum => valid_attributes
        forum = assigns(:forum)
        response.should redirect_to(forum_path(forum.slug))
      end
      
      it "re-renders the 'new' template" do
        post :create, :forum => {}
        response.should render_template("new")
      end
    end
    
    describe "GET edit" do
      it "should edit forum" do
        get :edit, :id => @forum.slug
        assigns(:forum).should eq(@forum)
      end
    end    
    
    describe "PUT udpate" do
      
      it "should update forum" do
        Forum.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => @forum.slug, :forum => {'these' => 'params'}
      end
      
      it "redirects to the forum" do
        put :update, :id => @forum.slug, :forum => valid_attributes
        forum = assigns(:forum)
        response.should redirect_to(forum_path(forum.slug))
      end
      
      it "re-renders the 'edit' template" do
        put :update, :id => @forum.slug, :forum => {:title => nil}
        response.should render_template("edit")
      end
    end
    
    describe "DELETE destroy" do
      it "destroys the requested agreement" do
        expect {
          delete :destroy, :id => @forum.slug
        }.to change(Forum, :count).by(-1)
      end
      
      it "redirects to the forum lsit" do
        delete :destroy, :id => @forum.slug
        response.should redirect_to(forums_path)
      end
    end
  end
  
end
