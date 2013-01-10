require 'spec_helper'

describe GiveyRuby::Configuration do

  describe "Client options" do

    it "GiveyRuby configure should set OAuth2 client correctly" do
      GiveyRuby.configure do |config|
        config.client({api_site: "http://example.com"})
      end

      GiveyRuby.configuration.client.should be_kind_of(OAuth2::Client)
      GiveyRuby.configuration.client.site.should == "http://example.com"
    end

  end

  describe "Session options" do

    it "GiveyRuby configure should set OAuth2 client correctly" do
      GiveyRuby.configure do |config|
        config.client({api_site: "http://example.com"})
      end

      GiveyRuby.configuration.client.should be_kind_of(OAuth2::Client)
      GiveyRuby.configuration.client.site.should == "http://example.com"
    end

  end

end
