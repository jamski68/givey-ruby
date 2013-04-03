module GiveyRuby

  module Controller

    module InstanceMethods

      def set_password_token(email, password)
        begin
          @access_token           = api_client.password.get_token(email, password)
          session[:access_token]  = @access_token.token
          me                      = JSON.parse(@access_token.get("/#{api_version}/me").body)
          session[:user_id]       = me['id']
          session[:business_id]   = me['business_id']
          return true
        rescue Exception => e
          return false
        end
      end

      def login_token_user(token_string)
        begin
          @access_token           = OAuth2::AccessToken.new(api_client, token_string)
          session[:access_token]  = token_string
          me                      = JSON.parse(@access_token.get("/#{api_version}/me").body)
          session[:user_id]       = me['id']
          session[:business_id]   = me['business_id']
          return true
        rescue Exception => e
          return false
        end
      end

      def access_token
        @access_token  ||= begin
          if session[:access_token]
            api_token               = OAuth2::AccessToken.new(api_client, session[:access_token])
          elsif ENV['GIVEY_TOKEN']
            api_token = OAuth2::AccessToken.new(api_client, ENV['GIVEY_TOKEN'])
          elsif givey_token = token_from_file
            api_token = OAuth2::AccessToken.new(api_client, givey_token)
          else
            api_token               = api_client.client_credentials.get_token
            session[:access_token]  = api_token.token
            token_to_file(api_token.token)
          end
          api_token
        end
      end

      # CLIENT CREDENTIALS ACCESS

      def token_sign_out
        access_token.get("/#{api_version}/oauth/revoke")
        session[:access_token]  = nil
        session[:user_id]       = nil
        session[:business_id]   = nil
      end

    end

    def self.included(receiver)
      receiver.extend         GiveyRuby::Shared::ClassMethods
      receiver.send :include, GiveyRuby::Shared::InstanceMethods
      receiver.send :include, InstanceMethods
      receiver.send :setup_givey_sdk
    end

  end

end
