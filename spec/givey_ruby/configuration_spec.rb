require 'spec_helper'

describe GiveyRuby::Configuration do

  context "api_site" do
    before(:each) do
      GiveyRuby.configure do |config|
        config.client({api_site: "http://example.com"})
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
      before { config.client }
      it { should == "v2" }
    end

    context "specified" do
      before { config.client({ api_version: "v1" }) }
      it { should == "v1" }
    end
  end
end
