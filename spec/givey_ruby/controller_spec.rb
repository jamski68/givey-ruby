require 'spec_helper'
require 'action_controller'

describe GiveyRuby::Controller do

  class CharityController
    include GiveyRuby::Controller
  end

  GiveyRuby.configure do |config|
    config.client({token_file: "#{SPEC_ROOT}/tmp/givey_token_file"})
  end

  let(:charity_controller) { CharityController.new }


  describe "access_token" do

    let(:api_token) { stub('api_token', token: 'udhs7gf7ssg') }

    it "should get new token and update session if it doesn't exist" do
      charity_controller.stub(:session).and_return({})
      charity_controller.stub_chain(:api_client, :client_credentials, :get_token).and_return(api_token)
      charity_controller.access_token.should == api_token
      charity_controller.session[:access_token].should == 'udhs7gf7ssg'
    end

    it "should get token from existing session" do
      charity_controller.should_receive(:session).twice.and_return({access_token: '8h7g6f5fjshd'})
      OAuth2::AccessToken.should_receive(:new).and_return(api_token)
      charity_controller.access_token.should == api_token
    end

  end

  describe "get_token_response" do

    let(:api_token) { stub('api_token', token: 'udhs7gf7ssg') }

    it "returns hash for requested URL" do
      charity_controller.should_receive(:session).twice.and_return({access_token: '8h7g6f5fjshd'})
      OAuth2::AccessToken.should_receive(:new).and_return(api_token)
      charity_controller.access_token.stub_chain(:get, :body).and_return({this: 'that'}.to_json)
      charity_controller.get_token_response("/this").should == {"this" => 'that'}
    end

  end

end
