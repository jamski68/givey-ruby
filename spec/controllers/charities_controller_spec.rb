require 'spec_helper'

describe CharitiesController do

  describe "access_token" do

    let(:api_token) { stub('api_token', token: 'udhs7gf7ssg') }

    #it "should get new token and update session if it doesn't exist" do
    #  charity.stub_chain(:api_client, :client_credentials, :get_token).and_return(#api_token)
    #  charity.access_token.should == api_token
    #  session[:access_token].should == 'udhs7gf7ssg'
    #end

    it "should get token from existing session" do
      File.open(GiveyRuby.configuration.token_file, 'w'){|f| f.write('8h7g6f5fjshd') }
      OAuth2::AccessToken.should_receive(:new).and_return(api_token)
      get :index
      response.should == 'this'
    end

  end

end
