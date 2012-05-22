# encoding: UTF-8
require 'spec_helper'
PROVIDERS = %w(twitter facebook google_oauth2)

describe Users::OmniauthCallbacksController do

  before(:each) do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "Authentication" do
    before(:all) {
      OmniAuth.config.test_mode = true
      PROVIDERS.each do |provider|
        OmniAuth.config.mock_auth[provider.to_sym] = omniauth_credentials(provider)
      end
    }

    PROVIDERS.each do |provider|

      it "should add #{provider} service for logged in user" do
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[provider.to_sym]
        sign_in :user, user = FactoryGirl.create(:user)

        expect {
          get provider
        }.to change(UserToken, :count).by(1)

        response.should redirect_to(edit_user_registration_path)
        flash[:notice].should eq("Veiksmīgi autorizēts ar #{UserToken.provider_name(provider)} lietotāju.")
      end

      it "should authenticate existing user with existing service #{provider}" do
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[provider.to_sym]
        token = FactoryGirl.create(:user_token, :provider => provider, :uid =>omniauth_credentials(provider)["uid"] )
        get provider
        response.should redirect_to(account_profile_path(token.user.login))
        flash[:notice].should == "Veiksmīgi autorizēts ar #{UserToken.provider_name(provider)} lietotāju."
      end

      it "should send to registration new user for #{provider}" do
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[provider.to_sym].except("info")
        get provider
        response.should redirect_to(new_user_registration_path)
      end

      it "should register new user for #{provider}" do
        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[provider.to_sym].merge("info" => {"name"=>"John Doe", "email" => "john.doe@gmail.com", "nickname" => "johndoe"})
        get provider
        response.should redirect_to(account_profile_path("johndoe"))
        flash[:notice].should == "Veiksmīgi autorizēts ar #{UserToken.provider_name(provider)} lietotāju."
      end

    end
  end

  describe "Remove service" do

    it "should remove service for user" do
      token = FactoryGirl.create(:user_token, :provider => "twitter", :uid =>omniauth_credentials("twitter")["uid"] )
      sign_in :user, token.user
      expect {
        delete :destroy, :id => token.id
      }.to change(UserToken, :count).by(-1)
      response.should redirect_to(edit_user_registration_path)
    end

  end

  def omniauth_credentials(provider)
    {
      "twitter" => {
        "provider"=>"twitter",
        "uid"=>"123321",
        "credentials"=>{
          "token"=>"123123123123",
          "secret"=>"321123321123"
        },
        "info"=>{
          "nickname"=>"johndoe",
          "name"=>"John Doe",
          "location"=>"Riga",
          "image"=>"http://twitter.com/John.Doe.jpg",
          "description"=>"",
          "urls"=>{"Website"=>"http://johndoe.lv", "Twitter"=>"http://twitter.com/johndoe"}
        }
      },
      "facebook" => {
        "provider"=>"facebook",
        "uid"=>"34235234",
        "credentials"=>{
          "token"=>"456456456456"
        },
        "info"=>{
          "nickname"=>"johndoe",
          "email"=>"john.doe@gmail.com",
          "name"=>"John Doe",
          "image"=>"http://facebook.com/John.Doe.jpg",
          "urls"=>{"Facebook"=>"http://www.facebook.com/John.Doe", "Website"=>nil}
        }
      },
      "google_oauth2" => {
        "provider"=>"google_oauth2",
        "uid"=>"9897987987987",
        "info"=>{
          "email"=>"john.doe@gmail.com",
          "name"=>"John Doe"
        }
      }
      }[provider]
  end
end