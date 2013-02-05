module GiveyRuby

  class Configuration

    def client(client_options = {})
      @client ||= begin
        # TODO: ensure consumer key and secret
        @api_site    = client_options.include?(:api_site) ? client_options[:api_site] : "http://api.givey.com"
        @api_version = client_options.include?(:api_version) ? client_options[:api_version] : "v2"
        opts         = {:site => @api_site, :authorize_url => "/#{api_version}/oauth/authorize", :token_url => "/#{api_version}/oauth/token", :raise_errors => false}
        @token_file  = client_options.include?(:token_file) ? client_options[:token_file] : "../tmp/givey_token_file"
        OAuth2::Client.new(client_options[:consumer_key], client_options[:consumer_secret], opts) do |builder|
          # POST/PUT params encoders:
          builder.request :multipart
          builder.request :url_encoded
          builder.adapter :net_http
        end
      end
    end

    def api_version
      @api_version
    end

    def api_site
      @api_site
    end

    def token_file
      @token_file
    end

    def token_file=(file_path)
      @token_file = file_path
    end

  end


end
