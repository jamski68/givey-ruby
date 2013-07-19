require 'spec_helper'

describe GiveyRuby::Configuration do

  describe "without necessary configuration parameters" do
    context "without consumer_key" do
      it "raises a ConfigurationError" do
        expect { GiveyRuby.configuration.client }.to raise_error(ArgumentError)
      end
    end

    context "without consumer_secret" do
      it "raises an ArgumentError" do
        expect { GiveyRuby.configuration.client(consumer_key: "key") }.to raise_error(ArgumentError)
      end
    end
  end

  context "api_site" do
    before(:each) do
      GiveyRuby.configure do |config|
        config.client({api_site: "http://example.com", consumer_key: "key", consumer_secret: "secret"})
      end
    end

    describe "Client options" do
      it "GiveyRuby configure should set OAuth2 client correctly" do
        GiveyRuby.configuration.client.should be_kind_of(OAuth2::Client)
        GiveyRuby.configuration.client.site.should == "http://example.com"
      end
    end

    describe "Session options" do
      it "GiveyRuby configure should set OAuth2 client correctly" do
        GiveyRuby.configuration.client.should be_kind_of(OAuth2::Client)
        GiveyRuby.configuration.client.site.should == "http://example.com"
      end
    end
  end

  describe "#api_version" do
    let(:config) { GiveyRuby::Configuration.new }
    let(:subject) { config.api_version }

    context "default" do
      before { config.client({consumer_key: "key", consumer_secret: "secret"}) }
      it { should == "v2" }
    end

    context "specified" do
      before { config.client({ api_version: "v1", consumer_key: "key", consumer_secret: "secret"}) }
      it { should == "v1" }
    end
  end
end
