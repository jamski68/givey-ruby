require 'spec_helper'

describe GiveyRuby::Model do

  # Token File
  let(:token_directory) { File.join(SPEC_ROOT, "tmp") }
  before(:all) { Dir.mkdir(token_directory)  }
  after(:all)  { Dir.delete(token_directory) }

  before(:all) do
    class Charity
      include GiveyRuby::Model
    end

    GiveyRuby.configure do |config|
      config.client({consumer_key: "key", consumer_secret: "secret"})
    end
  end

  let(:charity) { Charity.new }

  describe "token_from_file" do
    context "when file exists" do
      before { GiveyRuby.configuration.token_file = "#{SPEC_ROOT}/support/givey_token_file" }

      it "Charity object should return token string from file" do
        charity.token_from_file.should == '1234rtyfh'
      end
    end

    context "when file does not exist" do
      before { GiveyRuby.configuration.token_file = "#{SPEC_ROOT}/support/no_givey_token_file" }

      it "Charity object should return false if file doesn't exist" do
        charity.token_from_file.should be_false
      end
    end
  end

  describe "token_to_file" do
    before { GiveyRuby.configuration.token_file = "#{SPEC_ROOT}/tmp/givey_token_file" }

    it "Charity object should create and populate token string to file" do
      File.exists?(GiveyRuby.configuration.token_file).should be_false
      charity.token_to_file('8h7g6f5fjshd')
      File.exists?(GiveyRuby.configuration.token_file).should be_true
      charity.token_from_file.should == '8h7g6f5fjshd'
    end

  end

  describe "access_token" do

    let(:api_token) { double('api_token')  }
    before { api_token.stub(token: 'udhs7gf7ssg') }

    context "without token file" do
      before { GiveyRuby.configuration.token_file = "#{SPEC_ROOT}/tmp/givey_token_file" }

      it "should get new token and create token_file if it doesn't exist" do
        File.exists?(GiveyRuby.configuration.token_file).should be_false
        charity.stub_chain(:api_client, :client_credentials, :get_token).and_return(api_token)
        charity.access_token.should == api_token
        File.read(GiveyRuby.configuration.token_file).gsub(/\n/, '').should == 'udhs7gf7ssg'
      end
    end

    # The following tests initialize a separate Charity object because the access token
    # has been memoized from previous tests and #let does not re-evaluate.

    context "with token file" do
      let(:token_charity) { Charity.new }
      before { GiveyRuby.configuration.token_file = "#{SPEC_ROOT}/tmp/givey_token_file" }

      it "should get token from existing token_file" do
        File.open(GiveyRuby.configuration.token_file, 'w'){|f| f.write('8h7g6f5fjshd') }
        File.exists?(GiveyRuby.configuration.token_file).should be_true
        OAuth2::AccessToken.should_receive(:new).and_return(api_token)
        token_charity.access_token.should == api_token
      end
    end

  end

  describe "get_token_response" do
    let(:non_token_charity) { Charity.new }

    let(:api_token) { double('api_token', token: 'udhs7gf7ssg') }

    it "returns hash for requested URL" do
      File.open(GiveyRuby.configuration.token_file, 'w'){|f| f.write('8h7g6f5fjshd') }
      OAuth2::AccessToken.should_receive(:new).and_return(api_token)
      non_token_charity.access_token.stub_chain(:get, :body).and_return({this: 'that'}.to_json)
      non_token_charity.get_token_response("/this").should == {"this" => 'that'}
    end

  end

end
