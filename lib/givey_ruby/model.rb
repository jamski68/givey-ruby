module GiveyRuby

  module Model

    module ClassMethods
      def setup_givey_sdk(options = {})
        #options             = default_model_options.merge(options)
      end
    end

    module InstanceMethods

      def access_token
        @access_token  ||= begin
          if self.respond_to?(:givey_token) && self.givey_token
            api_token = OAuth2::AccessToken.new(api_client, self.givey_token)
          elsif givey_token = token_from_file
            api_token = OAuth2::AccessToken.new(api_client, givey_token)
          else
            api_token = api_client.client_credentials.get_token
            token_to_file(api_token.token)
          end
          api_token
        end
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
